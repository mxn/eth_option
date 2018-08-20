pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ClaimableChildOwnership is Ownable {

  function claimOwnership(address _childContract) 
  public
  onlyOwner {
    Ownable child = Ownable(_childContract);
    require(child.owner() == address(this));
    Ownable(_childContract).transferOwnership(msg.sender);
  }
}