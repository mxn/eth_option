pragma solidity ^0.4.18;

contract OptionSerieValidator {
  
  function isValidRequest(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime) 
   public
   view
   returns(bool) {
     return true;
   }

}