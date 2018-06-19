pragma solidity ^0.4.18;

import "../main/OptionFactory.sol";
import "./MockOptionPair.sol";

contract MockOptionFactory is OptionFactory {

  function MockOptionFactory(address _feeCalculator, address _erc721token)
    public
    onlyOwner
   OptionFactory (_feeCalculator, _erc721token) {}
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
            feeCalculator));
      OptionTokenCreated(
           opAddr,
           _underlying,
           _basisToken,
           _strike,
           _underlyingQty,
           _expireTime, msg.sender);
        return opAddr;
    }

}
