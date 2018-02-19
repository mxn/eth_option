pragma solidity ^0.4.18;

import "./FeeTaker.sol";

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';
import 'zeppelin-solidity/contracts/ReentrancyGuard.sol';

import './TokenOption.sol';
import './TokenAntiOption.sol';

contract OptionPair is ReentrancyGuard {
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
//  string public name;

  address feeTaker;

  address public tokenOption;
  address public tokenAntiOption;

  uint totalWritten;

  address public owner; //can not make Ownable,as deployment give out of gas

  modifier onlyBeforeExpiration() {
    require(getCurrentTime() < expireTime);
    _;
  }

  modifier onlyAfterExpiration() {
    require(getCurrentTime() >= expireTime);
    _;
  }

  function OptionPair (address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime,  address _feeTaker, address _owner)
    public
    {

      underlying = _underlying;
      basisToken = _basisToken;
      strike = _strike;
      underlyingQty = _underlyingQty;
      expireTime = _expireTime;
      feeTaker = _feeTaker;

      FeeTaker feeTakerObj = FeeTaker(feeTaker);
      feeTakerObj.takeOptionPairCreationFee(_underlying, _basisToken,
        _strike, _underlyingQty, _expireTime, _owner);

      tokenOption = address(new TokenOption());
      tokenAntiOption = address(new TokenAntiOption());
      owner = _owner;
  }

  function () public payable {
    revert();
  }

  function writeOptions(uint256 _qty) external nonReentrant returns (bool) {
    return _writeOptionFor(_qty, msg.sender);
  }

  function _writeOptionFor(uint256 _qty, address _writer) onlyBeforeExpiration private returns (bool) {
    require(_qty > 0);
    uint calcUnderlyngQty = _qty.mul(underlyingQty);
    ERC20 underlyingErc20 =  ERC20(underlying);
    require(underlyingErc20.allowance(_writer, this) >= calcUnderlyngQty); //TODO
    require(underlyingErc20.balanceOf(_writer) >= calcUnderlyngQty);

    totalWritten = totalWritten.add(_qty);
    FeeTaker(feeTaker).takeFee(this, _qty, _writer);
    underlyingErc20.safeTransferFrom(_writer, this, calcUnderlyngQty);
    TokenOption(tokenOption).mint(_writer, _qty);
    TokenAntiOption(tokenAntiOption).mint(_writer, _qty);
    return true;
  }

  function annihilate(uint _qty) external nonReentrant {
    _annihilateFor(msg.sender, _qty);
  }

  function _annihilateFor(address _holder, uint _qty) private {
    TokenOption tokenOptionErc20 = TokenOption(tokenOption);
    TokenAntiOption tokenAntiOptionErc20 = TokenAntiOption(tokenAntiOption);
    require(tokenOptionErc20.balanceOf(_holder) >= _qty);
    require(tokenAntiOptionErc20.balanceOf(_holder) >= _qty);
    tokenOptionErc20.safeTransferFrom(_holder, this, _qty); //first we transfer into OptionPair accounnt as only from this account the tokens can be burned
    tokenAntiOptionErc20.safeTransferFrom(_holder, this, _qty);
    tokenOptionErc20.burn(_qty);
    tokenAntiOptionErc20.burn(_qty);
    ERC20(underlying).safeTransfer(_holder, underlyingQty.mul(_qty));
  }

  function getTotalOpenInterest() public view returns(uint res) {
    return ERC20(tokenOption).totalSupply();
  }

  function getTotalExecuted() public view returns(uint res) {
    return totalWritten - ERC20(tokenOption).totalSupply();
  }

  function execute(uint _qty) external nonReentrant
    returns (bool) {
    return executeFor(msg.sender, _qty);
  }

  function executeFor (address _buyer, uint _qty)  private onlyBeforeExpiration() returns (bool) {
    TokenOption tokenOptionObj =  TokenOption(tokenOption);
    require (tokenOptionObj.balanceOf(_buyer) >= _qty);
    uint baseAmount = _qty.mul(strike);
    ERC20(basisToken).safeTransferFrom(_buyer, this, baseAmount);
    tokenOptionObj.safeTransferFrom(_buyer, this, _qty);
    tokenOptionObj.burn(_qty);
    ERC20(underlying).safeTransfer(_buyer, _qty.mul(underlyingQty));
    return true;
  }

  function withdrawAll () external nonReentrant returns (bool) {
    return withdrawFor(msg.sender, TokenAntiOption(tokenAntiOption).balanceOf(msg.sender));
  }

  function withdraw (uint _qty) external nonReentrant returns (bool) {
    return withdrawFor(msg.sender, _qty);
  }

  function withdrawFor(address _writer, uint _qty) private onlyAfterExpiration returns (bool) {
    TokenAntiOption tokenAntiOptionObj = TokenAntiOption(tokenAntiOption);
    require (tokenAntiOptionObj.balanceOf(_writer) >= _qty);
    require(ERC20(underlying).balanceOf(this).mul(_qty) >= 0); //to prevent oveflows
    require(ERC20(basisToken).balanceOf(this).mul(_qty) >= 0); //to prevent oveflows

    tokenAntiOptionObj.safeTransferFrom(_writer, this, _qty);

    uint underlyingAvailableForAntiOption  =  ERC20(underlying).balanceOf(this).mul(_qty) / tokenAntiOptionObj.totalSupply(); // can not use safe div
    if (underlyingAvailableForAntiOption > 0) {
        ERC20(underlying).safeTransfer(_writer, underlyingAvailableForAntiOption);
    }

    uint basisTokensAvailableForAntiOption  =  ERC20(basisToken).balanceOf(this).mul(_qty) / tokenAntiOptionObj.totalSupply(); // can not use safe div
    if (basisTokensAvailableForAntiOption > 0) {
      ERC20(basisToken).safeTransfer(_writer, basisTokensAvailableForAntiOption);
    }

    tokenAntiOptionObj.burn(_qty);
    return true;
  }

  function getAvailableUnderlying(address holder) public view returns(uint) {
    TokenAntiOption tokenAntiOptionObj = TokenAntiOption(tokenAntiOption);
    return ERC20(underlying).balanceOf(this).mul(tokenAntiOptionObj.balanceOf(holder)) / tokenAntiOptionObj.totalSupply();
  }

  function getCurrentTime() public view returns (uint) { // made as function to be overridable for testing purposes
    return now;
  }

  function updateMockTime(uint /* _mockTime */) public returns (bool) {
    revert();
  }

}


