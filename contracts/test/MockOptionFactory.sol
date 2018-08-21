pragma solidity ^0.4.18;

import "../main/OptionFactory.sol";
import "./MockOptionPair.sol";

contract MockOptionFactory is OptionFactory {

  function MockOptionFactory(address _feeCalculator, address _erc721token)
    public
    onlyOwner
   OptionFactory (_feeCalculator, _erc721token) {}

  function genOptionPairArr(address[3] _addresses, uint[3] _values)
   internal 
   returns (address) {
     return new MockOptionPair (
        _addresses[0],
        _addresses[1],
        _values[0],
        _values[1],
        _values[2],
        _addresses[2],
        address(new WithdrawableByOwner(IFeeCalculator(_addresses[2]).feeToken()))
        );
   }
}
