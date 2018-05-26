pragma solidity ^0.4.18;

import './IFeeCalculator.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract SimpleFeeCalculator is IFeeCalculator {

  using SafeMath for uint;

  uint public numerator;
  uint public denominator;
  uint public optionCreationFee;

  address private addrFeeToken; //not made as feeToken due to compilation
  //problem

  function SimpleFeeCalculator(address _feeToken, uint _numerator, uint _denominator) public {
    addrFeeToken = _feeToken;
    numerator = _numerator;
    denominator = _denominator;
  }

  function feeToken () public view returns (address)  {
    return addrFeeToken;
  }

  function calcFee (address /* _tokenOption*/, uint _qty) public view returns (address, uint) {
    return (addrFeeToken, numerator.mul(_qty).div(denominator));
  }

}
