/*

Used for dev purposes instead of canonical wrapped ETH
*/

pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract Weth is StandardToken {
    using SafeMath for uint;

  string constant public name = "Wrapped Etherem";
  string constant public symbol = "WETH";
  uint8 constant public decimals = 18;

  /// @dev Fallback to calling deposit when ether is sent directly to contract.
  function()
    public
    payable
  {
    deposit();
  }

  /// @dev Buys tokens with Ether, exchanging them 1:1.
  function deposit()
    public
    payable
  {
    balances[msg.sender] = balances[msg.sender].add(msg.value);
    totalSupply_ = totalSupply_.add(msg.value);
  }

  function withdraw(uint amount)
    public
  {
    balances[msg.sender] = balances[msg.sender].sub(amount);
    totalSupply_ = totalSupply_.sub(amount);
    require(msg.sender.send(amount));
  }
}
