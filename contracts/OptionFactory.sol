pragma solidity ^0.4.18;

import "./FeeTaker.sol";
import "./OptionPair.sol";
import "./OptionRegistry.sol";

contract OptionFactory {

  address public optionRegistry;
  address public feeTaker;

  event OptionTokenCreated(address optionPair,
      address indexed underlying, address indexed basisToken,
       uint strike, uint underlyingQty, uint expireTime,  address creator);

  function OptionFactory (address _feeTaker, address _optionRegistry) public {
          feeTaker =_feeTaker;
          optionRegistry = _optionRegistry;
  }

  function createOptionPairContract(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) public
   returns(address) {
     OptionRegistry optionRegistryObj = OptionRegistry(optionRegistry);
     bytes32 optHash = optionRegistryObj.getOptionHash(_underlying,
      _basisToken,
      _strike,
      _underlyingQty,
      _expireTime);
    require(optionRegistryObj.getOptionPair(optHash) == address(0));
    address opAddr =  address(new OptionPair (
        _underlying,
        _basisToken,
        _strike,
        _underlyingQty,
        _expireTime,
        feeTaker, msg.sender));
    optionRegistryObj.register(optHash, opAddr);
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


