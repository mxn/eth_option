pragma solidity ^0.4.18;

import './MockOptionFactory.sol';

contract MockWethOptionFactory is MockOptionFactory {
  function MockWethOptionFactory(address _feeCalculator)
    MockOptionFactory(_feeCalculator) {
    }
}
