pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract OptionSerieValidator is Ownable {
  address feeCalculator;
  uint maxTimeSpan;
  
  function OptionSerieValidator (address _feeCalculator) {
    setFeeCalculator(_feeCalculator);
    setMaxTimeSpan(180 days);
  }

  function setFeeCalculator(address _feeCalculator) public onlyOwner {
    feeCalculator = _feeCalculator;
  }

  function setMaxTimeSpan (uint _maxTimeSpan) public onlyOwner {
    maxTimeSpan = _maxTimeSpan;
  }

  function isValidRequest(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime, address _feeCalculator)
   public
   view
   returns(bool) {
     return _feeCalculator == feeCalculator  && (now + maxTimeSpan > _expireTime);
   }
   
}