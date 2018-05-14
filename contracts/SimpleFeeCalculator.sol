pragma solidity ^0.4.18;

import './IFeeCalculator.sol';

import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract SimpleFeeCalculator is IFeeCalculator {

  using SafeMath for uint;

  uint public coef;
  uint public optionCreationFee;

  address addrFeeToken; //retrived by method

  function SimpleFeeCalculator(address _feeToken, uint _coef, uint _optionCreationFee) public {
    addrFeeToken = _feeToken;
    coef = _coef;
    optionCreationFee = _optionCreationFee;
  }

  function feeToken () public view returns (address)  {
    return addrFeeToken;
  }

  function calcFee (address /* _tokenOption*/, uint _qty) public view returns (address, uint) {
    return (addrFeeToken, coef.mul(_qty));
  }

}
