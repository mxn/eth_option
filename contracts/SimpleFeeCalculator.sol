pragma solidity ^0.4.18;

import './TokenOption.sol';
import './IFeeCalculator.sol';

contract SimpleFeeCalculator is IFeeCalculator {
  uint public coef;
  uint public optionCreationFee;

  address addrFeeToken; //retrived by method

  function SimpleFeeCalculator(ERC20 _feeToken, uint _coef, uint _optionCreationFee) public {
    addrFeeToken = _feeToken;
    coef = _coef;
    optionCreationFee = _optionCreationFee;
  }

  function feeToken () public view returns (address)  {
    return addrFeeToken;
  }

  function calcFee (address /* _tokenOption*/, uint _qty) public view returns (uint) {
    return _qty * coef;
  }

  function calcOptionCreationFee(address , address , uint, uint, uint) public view returns(uint) {
      return optionCreationFee;
    }
}
