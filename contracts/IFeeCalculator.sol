pragma solidity ^0.4.18;

//import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract IFeeCalculator {
  function feeToken () public view returns (address);
  function calcFee (address _token, uint _qty) public view returns (uint);
  function calcOptionCreationFee(address _underlying, address _basisToken, uint _strike, uint _underlyingQty, uint _expireTime) public view returns(uint);
}
