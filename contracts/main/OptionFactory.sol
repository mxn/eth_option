pragma solidity ^0.4.18;

import './IFeeCalculator.sol';
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
  address public optionSerieOwnerToken;

  mapping (uint => bool) solvedToken;

  event OptionTokenCreated(address optionPair,
      address indexed underlying, address indexed basisToken,
       uint strike, uint underlyingQty, uint expireTime);

  modifier onlyTokenOwner(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) {
     uint tokenId = OptionSerieToken(optionSerieOwnerToken).getTokenId(_underlying, _basisToken,
     _strike, _underlyingQty, _expireTime);
     require(!isSolved(tokenId));
     address tokenOwner = OptionSerieToken(optionSerieOwnerToken).ownerOf(tokenId);
     require(tokenOwner == msg.sender);
     _;
  }

  function OptionFactory (address _feeCalculator, address _optionSerieOwnerToken)
  Ownable()
  ReentrancyGuard()
  public {
          setFeeCalculator(_feeCalculator);
          optionSerieOwnerToken = _optionSerieOwnerToken;
  }

  function () payable {
    revert(); //do not accept ETH
  }

  function createOptionPairContract(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) 
   public {
     address[3] memory addresses = [_underlying, _basisToken, feeCalculator];
     uint[3] memory values = [_strike, _underlyingQty, _expireTime];
     createOptionPairContractFeeCalc(addresses, values);
   }

   function genOptionPairArr(address[3] _addresses, uint[3] _values)
   internal 
   returns (address) {
     return new OptionPair (
        _addresses[0],
        _addresses[1],
        _values[0],
        _values[1],
        _values[2],
        _addresses[2],
        address(new WithdrawableByOwner(IFeeCalculator(_addresses[2]).feeToken()))
        );
   }

  function createOptionPairContractFeeCalc(address[3] _addresses, uint[3] _values)
   public
   onlyTokenOwner(_addresses[0], _addresses[1],
     _values[0], _values[1], _values[2])
   returns(address) {
    address optionPair = genOptionPairArr(_addresses, _values); 
    emitEventArr(optionPair, _addresses, _values);
    return optionPair;
 }

 function emitEventArr(address _optionPair, address[3] _addresses, uint[3] _values) private {
   OptionTokenCreated(
        _optionPair,
        _addresses[0],
        _addresses[1],
        _values[0],
        _values[1],
        _values[2]);
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
   } else {
     _proxyTransfer(underlying, _optionPair, underlyingQty);
      if (fee > 0) {
        _proxyTransfer(feeToken, _optionPair, fee);
      }
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

  function withdrawFee(address _optionPair) external {
    uint tokenId = OptionSerieToken(optionSerieOwnerToken).getTokenIdForOptionPair(_optionPair);
    require(msg.sender == OptionSerieToken(optionSerieOwnerToken).ownerOf(tokenId));
    address feeTaker = OptionPair(_optionPair).feeTaker();
    address feeToken = WithdrawableByOwner(feeTaker).token();
    uint feeAmount = ERC20(feeToken).balanceOf(feeTaker);
    require(feeAmount > 0);
    ERC20(feeToken).safeTransferFrom(feeTaker, this, feeAmount);
    ERC20(feeToken).safeTransfer(msg.sender, feeAmount);
  }

  function setFeeCalculator(address _feeCalculator)
  public
  onlyOwner {
    feeCalculator = _feeCalculator;
  }

}
