pragma solidity ^0.4.18;

import './MockOptionFactory.sol';

contract MockWethOptionFactory is MockOptionFactory {
  function MockWethOptionFactory(address _feeCalculator, address _erc721)
    MockOptionFactory(_feeCalculator, _erc721) {
    }
}
