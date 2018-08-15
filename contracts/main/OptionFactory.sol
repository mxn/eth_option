pragma solidity ^0.4.18;

import './OptionPair.sol';
import './OptionSerieToken.sol';
import './WithdrawableByOwner.sol';
import 'zeppelin-solidity/contracts/ReentrancyGuard.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';



contract OptionFactory is Ownable, ReentrancyGuard {

  using SafeERC20 for ERC20;
  using SafeMath for uint256;

  address public feeCalculator;
  OptionSerieToken public optionSerieOwnerToken;

  mapping (uint => bool) solvedToken;

  event OptionTokenCreated(address optionPair,
      address indexed underlying, address indexed basisToken,
       uint strike, uint underlyingQty, uint expireTime);

  modifier onlyTokenOwner(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) {
     uint tokenId = optionSerieOwnerToken.getTokenId(_underlying, _basisToken,
     _strike, _underlyingQty, _expireTime);
     require(!isSolved(tokenId));
     address tokenOwner = optionSerieOwnerToken.ownerOf(tokenId);
     require(tokenOwner == msg.sender);
     _;
  }

  function OptionFactory (address _feeCalculator, address _optionSerieOwnerToken)
  Ownable()
  ReentrancyGuard()
  public {
          feeCalculator = _feeCalculator;
          optionSerieOwnerToken = OptionSerieToken(_optionSerieOwnerToken);
  }

  function () payable {
    revert(); //do not accept ETH
  }

  function createOptionPairContract(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime)
   public
   onlyTokenOwner(_underlying, _basisToken,
     _strike, _underlyingQty, _expireTime)
   returns(address) {
    //address escrowFeeTaker = address(0); //address(new WithdrawableByOwner());
    address opAddr =  address(new OptionPair (
        _underlying,
        _basisToken,
        _strike,
        _underlyingQty,
        _expireTime,
        feeCalculator,
        address(new WithdrawableByOwner())
        ));
    //delete escrowFeeTaker;
   OptionTokenCreated(
        opAddr,
        _underlying,
        _basisToken,
        _strike,
        _underlyingQty,
        _expireTime);
    return opAddr;
 }

 function withdraw(address _token, uint _amount) public onlyOwner {
   require(msg.sender == owner);
   ERC20 tokenErc20 = ERC20 (_token);
   require(tokenErc20.balanceOf(this) >= _amount);
   tokenErc20.safeTransfer(owner, _amount);
 }

 function _proxyTransfer(address _token, address _target, uint _amount)
 private {
   ERC20 erc20 =  ERC20(_token);
   erc20.safeTransferFrom(msg.sender, this, _amount);
   erc20.approve(_target, _amount);
   require(erc20.allowance(this, _target) == _amount);
 }

 function writeOptions(address _optionPair, uint _qty)
 external
 nonReentrant
 returns (bool) {
   OptionPair optionPairObj = OptionPair(_optionPair);
   uint underlyingQtyPerContract = optionPairObj.underlyingQty();
   address underlying = optionPairObj.underlying();
   uint underlyingQty = underlyingQtyPerContract.mul(_qty);

   address feeToken;
   uint fee;
   address optionPairFeeCalculator = optionPairObj.feeCalculator();
   (feeToken,  fee) = IFeeCalculator(optionPairFeeCalculator)
    .calcFee(_optionPair, _qty);
   if (feeToken == underlying) {
     _proxyTransfer(underlying, _optionPair, fee.add(underlyingQty));
   } else if (fee > 0) {
     _proxyTransfer(underlying, _optionPair, underlyingQty);
     _proxyTransfer(feeToken, _optionPair, fee);
   }

   return optionPairObj.writeOptionsFor(_qty, msg.sender, false);
  }

  function exerciseOptions(address _optionPair, uint _qty)
  external
  nonReentrant {
    _exerciseOptions(_optionPair, _qty);
  }

  function exerciseAllAvailableOptions(address _optionPair)
  external
  nonReentrant
  {
    uint qty = ERC20(OptionPair(_optionPair).tokenOption()).balanceOf(msg.sender);
    _exerciseOptions(_optionPair, qty);
  }

  function _exerciseOptions(address _optionPair, uint _qty)
  private
  {
    OptionPair optionPairObj = OptionPair(_optionPair);
    address basisToken = optionPairObj.basisToken();
    uint basisAmount = optionPairObj.strike().mul(_qty);
    _proxyTransfer(basisToken, _optionPair, basisAmount);
    optionPairObj.executeFor(msg.sender, _qty);
  }

  function isSolved(uint tokenId)
  public
  view
  returns(bool)
  {
    return solvedToken[tokenId];
  }

}
