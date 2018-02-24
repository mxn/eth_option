pragma solidity ^0.4.18;

import "./OptionFactory.sol";
import "./MockOptionPair.sol";
import "./FeeTaker.sol";

contract MockOptionFactory is OptionFactory {

  function MockOptionFactory(address _feeTaker) public
   OptionFactory (_feeTaker) {}
     /*
     Need to copy logic from parent class as refactoring brings problem with the gas
     */
     function createOptionPairContract( address _underlying, address _basisToken,
      uint _strike, uint _underlyingQty, uint _expireTime) public
      returns(address) {
        address opAddr =  address(new MockOptionPair(
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
