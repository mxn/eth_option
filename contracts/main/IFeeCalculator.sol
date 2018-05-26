pragma solidity ^0.4.18;

contract IFeeCalculator {
  function feeToken () public view returns (address);
  /**
  * _token OptionPair address
  * _qty number of contracts to be written
  */
  function calcFee (address _token, uint _qty) public view returns (address, uint);
}
