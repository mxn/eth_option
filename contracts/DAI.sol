/*

Used for dev purposes instead of canonical DAI
*/

pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract Weth is StandardToken {
  string constant public name = "DAI";
  string constant public symbol = "DAI";
  uint8 constant public decimals = 18;
}
