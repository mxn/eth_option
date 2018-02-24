pragma solidity ^0.4.18;

import "./FeeTaker.sol";
import "./OptionPair.sol";

contract OptionFactory {

  address public feeTaker;

  event OptionTokenCreated(address optionPair,
      address indexed underlying, address indexed basisToken,
       uint strike, uint underlyingQty, uint expireTime,  address creator);

  function OptionFactory (address _feeTaker) public {
          feeTaker =_feeTaker;
  }

  function createOptionPairContract(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) public
   returns(address) {
    address opAddr =  address(new OptionPair (
        _underlying,
        _basisToken,
        _strike,
        _underlyingQty,
        _expireTime,
        feeTaker, msg.sender));
    OptionTokenCreated(
        opAddr,
        _underlying,
        _basisToken,
        _strike,
        _underlyingQty,
        _expireTime,
        msg.sender);
    return opAddr;
 }

}
