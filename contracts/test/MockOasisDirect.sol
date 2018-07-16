pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';

contract MockOasisDirect {

  using SafeERC20 for ERC20;

  uint exRate = 110;

  function sellAllAmount(address _pay_gem, uint _pay_amt, address _buy_gem,
    uint _min_fill_amount)
    public
    returns (uint) {
      uint amountToGive = getBuyAmount(_buy_gem, _pay_gem,
        _pay_amt);

      require( ERC20(_pay_gem).allowance(msg.sender, this) >= _pay_amt);
      ERC20(_pay_gem).safeTransferFrom(msg.sender, this, _pay_amt);
      ERC20(_buy_gem).safeTransfer(msg.sender, amountToGive);
      return amountToGive;
    }
  function getBuyAmount(address _buy_gem, address _pay_gem, uint _pay_amt)
    public
    constant
    returns (uint fill_amt) {
      return _pay_amt * exRate;
    }
}
