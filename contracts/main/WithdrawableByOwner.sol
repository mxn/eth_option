pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract WithdrawableByOwner is Ownable {

  using SafeERC20 for ERC20;
  
  function withdrawEth(uint _amount) public onlyOwner {
    msg.sender.transfer(_amount);
  }

  function withdraw(address _token, uint _amount) public onlyOwner {
    require(msg.sender == owner);
    ERC20 tokenErc20 = ERC20 (_token);
    require(tokenErc20.balanceOf(this) >= _amount);
    tokenErc20.safeTransfer(owner, _amount);
  }

}
