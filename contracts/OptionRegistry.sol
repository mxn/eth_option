pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract OptionRegistry is Ownable {
  mapping (bytes32 => address) private createdOptions;

  function getOptionPair(bytes32 optHash) public view returns(address) {
     return createdOptions[optHash];
 }

 function getOptionHash(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) public pure returns(bytes32) {
     return keccak256(_underlying, _basisToken, _strike, uint(1), _underlyingQty, uint(1), _expireTime);
 }

 function register(bytes32 optHash, address optionPair) onlyOwner public {
     createdOptions[optHash] =  optionPair;
   }

}


