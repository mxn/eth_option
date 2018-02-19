pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/mocks/StandardTokenMock.sol';

contract MockToken1 is StandardTokenMock {
  function MockToken1() public
  StandardTokenMock(0x5aeda56215b167893e80b4fe645ba6d5bab767de, 1000000000) {}
}


