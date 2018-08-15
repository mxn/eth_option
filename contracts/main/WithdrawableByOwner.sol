pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract WithdrawableByOwner is Ownable {

  using SafeERC20 for ERC20;
  uint constant MAX_AMOUNT = 2**256 - 1;
  address public token;

  function WithdrawableByOwner(address _erc20) {
    token = _erc20;
    ERC20(token).approve(msg.sender, MAX_AMOUNT);
  }

  function withdraw(uint _amount) public onlyOwner {
    require(msg.sender == owner);
    ERC20 tokenErc20 = ERC20 (token);
    require(tokenErc20.balanceOf(this) >= _amount);
    tokenErc20.safeTransfer(owner, _amount);
  }

}
