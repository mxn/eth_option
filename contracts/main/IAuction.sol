pragma solidity ^0.4.18;

//import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
//import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract IAuction {
  function creaateAuction(uint token) public;
  function isNew(uint token) public view returns(bool);
  function isBettingActive(uint token) public view returns(bool);
  function isRevealed(uint token) public view returns(bool);
  function getWinner(uint token) public view returns(address);
}
