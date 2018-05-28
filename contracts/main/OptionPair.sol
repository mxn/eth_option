pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';
import 'zeppelin-solidity/contracts/ReentrancyGuard.sol';

import './IFeeCalculator.sol';
import './TokenOption.sol';
import './TokenAntiOption.sol';

contract OptionPair is Ownable, ReentrancyGuard {
  using SafeMath for uint256;
  using SafeERC20 for TokenOption;
  using SafeERC20 for ERC20;
  using SafeERC20 for TokenAntiOption;

  uint8 public decimals = 0; //we operate contracts at whole

  address public underlying;
  address public basisToken;
  uint public strike;
  uint public underlyingQty;
  uint public expireTime;

  address public feeCalculator;

  address public tokenOption;
  address public tokenAntiOption;

  uint totalWritten;

  modifier onlyBeforeExpiration() {
    require(getCurrentTime() < expireTime);
    _;
  }

  modifier onlyAfterExpiration() {
    require(getCurrentTime() >= expireTime);
    _;
  }

  function OptionPair (address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime,  address _feeCalculator)
    Ownable()
    ReentrancyGuard()
    public
    {
      underlying = _underlying;
      basisToken = _basisToken;
      strike = _strike;
      underlyingQty = _underlyingQty;
      expireTime = _expireTime;
      feeCalculator = _feeCalculator;
      tokenOption = address(new TokenOption());
      tokenAntiOption = address(new TokenAntiOption());
  }

  function () public payable {
    revert();
  }

  function writeOptions(uint256 _qty) external nonReentrant returns (bool) {
    return _writeOptionFor(_qty, msg.sender, msg.sender);
  }

  function writeOptionsFor(uint256 _qty, address _writer, bool _feeFromWriter) external nonReentrant returns (bool) {
    return _writeOptionFor(_qty, _writer, msg.sender, _feeFromWriter);
  }

  function _writeOptionFor(uint256 _qty, address _writer, address _sponsor) private returns (bool) {
    return _writeOptionFor(_qty, _writer, _sponsor, true);
  }

  function _writeOptionFor(uint256 _qty, address _writer, address _sponsor, bool _feeFromWriter) onlyBeforeExpiration private returns (bool) {
    require(_qty > 0);
    uint calcUnderlyngQty = _qty.mul(underlyingQty);
    ERC20 underlyingErc20 =  ERC20(underlying);
    require(underlyingErc20.allowance(_sponsor, this) >= calcUnderlyngQty); //TODO
    require(underlyingErc20.balanceOf(_sponsor) >= calcUnderlyngQty);

    totalWritten = totalWritten.add(_qty);

    underlyingErc20.safeTransferFrom(_sponsor, this, calcUnderlyngQty);

    TokenOption(tokenOption).mint(_writer, _qty);
    TokenAntiOption(tokenAntiOption).mint(_writer, _qty);
    if (_feeFromWriter) {
      _takeFee(_qty, _writer);
    } else {
      _takeFee(_qty, _sponsor);
    }

    return true;
  }

  function annihilate(uint _qty) external nonReentrant returns (bool) {
    return _annihilateFor(msg.sender, _qty);
  }

  function _annihilateFor(address _holder, uint _qty) private returns (bool) {
    TokenOption tokenOptionErc20 = TokenOption(tokenOption);
    TokenAntiOption tokenAntiOptionErc20 = TokenAntiOption(tokenAntiOption);
    require(tokenOptionErc20.balanceOf(_holder) >= _qty);
    require(tokenAntiOptionErc20.balanceOf(_holder) >= _qty);

    _withdrawFor(_holder, _qty); //anti-options are burned there
    tokenOptionErc20.safeTransferFrom(_holder, this, _qty); //first we transfer into OptionPair accounnt as only from this account the tokens can be burned
    tokenOptionErc20.burn(_qty);
    return true;
  }

  function getTotalOpenInterest() public view returns(uint res) {
    return ERC20(tokenOption).totalSupply();
  }

  function getTotalExecuted() public view returns(uint res) {
    return totalWritten - ERC20(tokenOption).totalSupply();
  }

  function execute(uint _qty) external nonReentrant
    returns (bool) {
    return _executeFor(msg.sender, msg.sender, _qty);
  }

  function executeFor(address _buyer, uint _qty) external nonReentrant
    returns (bool) {
    return _executeFor(_buyer, msg.sender, _qty);
  }

  //from client perspective it is easier to approve option tokens for pair,
  // butr unerlyiung and basis for some "stable" address, e.g. OptionFactory
  function _executeFor (address _buyer, address _sponsorBasisTokens,  uint _qty)
    private
    onlyBeforeExpiration()
    returns (bool) {
    TokenOption tokenOptionObj =  TokenOption(tokenOption);
    require (tokenOptionObj.balanceOf(_buyer) >= _qty);
    uint baseAmount = _qty.mul(strike);
    ERC20(basisToken).safeTransferFrom(_sponsorBasisTokens, this, baseAmount);
    tokenOptionObj.safeTransferFrom(_buyer, this, _qty);
    tokenOptionObj.burn(_qty);
    ERC20(underlying).safeTransfer(_buyer, _qty.mul(underlyingQty));
    return true;
  }

  function withdrawAll () external nonReentrant onlyAfterExpiration returns (bool) {
    return _withdrawFor(msg.sender, TokenAntiOption(tokenAntiOption).balanceOf(msg.sender));
  }

  function withdraw (uint _qty) external nonReentrant onlyAfterExpiration returns (bool) {
    return _withdrawFor(msg.sender, _qty);
  }

  function _withdrawFor(address _writer, uint _qty) private  returns (bool) {
    TokenAntiOption tokenAntiOptionObj = TokenAntiOption(tokenAntiOption);
    require (tokenAntiOptionObj.balanceOf(_writer) >= _qty);
    require(ERC20(underlying).balanceOf(this).mul(_qty) >= 0); //to prevent oveflows
    require(ERC20(basisToken).balanceOf(this).mul(_qty) >= 0); //to prevent oveflows

    tokenAntiOptionObj.safeTransferFrom(_writer, this, _qty);

    uint underlyingAvailableForAntiOption  =  ERC20(underlying).balanceOf(this).mul(_qty).div(tokenAntiOptionObj.totalSupply()); // can not use safe div
    if (underlyingAvailableForAntiOption > 0) {
        ERC20(underlying).safeTransfer(_writer, underlyingAvailableForAntiOption);
    }

    uint basisTokensAvailableForAntiOption  =  ERC20(basisToken).balanceOf(this).mul(_qty).div(tokenAntiOptionObj.totalSupply()); // can not use safe div
    if (basisTokensAvailableForAntiOption > 0) {
      ERC20(basisToken).safeTransfer(_writer, basisTokensAvailableForAntiOption);
    }

    tokenAntiOptionObj.burn(_qty);
    return true;
  }

  function getAvailableUnderlying(address holder) public view returns(uint) {
    TokenAntiOption tokenAntiOptionObj = TokenAntiOption(tokenAntiOption);
    return ERC20(underlying).balanceOf(this).mul(tokenAntiOptionObj.balanceOf(holder)).div(tokenAntiOptionObj.totalSupply());
  }

  function getCurrentTime() public view returns (uint) { // made as function to be overridable for testing purposes
    return now;
  }

  function updateMockTime(uint /* _mockTime */) public returns (bool) {
    revert();
  }

  function _takeFee (uint _optionQty, address _feePayer) private {
    if (_feePayer != owner) {
      IFeeCalculator feeCalculatorObj =  IFeeCalculator(feeCalculator);
      uint fee;
      address feeToken;
      (feeToken, fee) = feeCalculatorObj.calcFee(address(this), _optionQty);
      ERC20 feeTokenObj = ERC20(feeToken);
      feeTokenObj.safeTransferFrom(_feePayer, owner, fee);
    }
  }

}
