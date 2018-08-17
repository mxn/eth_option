pragma solidity ^0.4.18;

contract ITokenReceiver {
  /**
    suppose that a contract first transfer token(s) and then call this callback method
    @param tokenAddress ERC721 or ERC20 token address
    @param eitherQtyOrTokenId in case of ERC20: amount, in case of ERC721: tokenId
   */
  function onReceive(address tokenAddress, uint eitherQtyOrTokenId) public;

}