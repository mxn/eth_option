pragma solidity ^0.4.18;

import './ITokenReceiver.sol';

import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ERC721ReceiverToOwner is ITokenReceiver, Ownable {
  function onReceive(address tokenAddress, uint eitherQtyOrTokenId, address origin) 
  public {
    ERC721(tokenAddress).transfer(owner, eitherQtyOrTokenId);
  }
}