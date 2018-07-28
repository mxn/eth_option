pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract  EscrowAccount  {
    
    function EscrowAccount(address _erc20) {
      ERC20(_erc20).approve(msg.sender, 2 ** 256 - 1);
    }

    function takeEscrow721Ownership(address _erc721, uint _erc721tokenId) {
      ERC721(_erc721).takeOwnership(_erc721tokenId);
      ERC721(_erc721).approve(msg.sender, _erc721tokenId);   
    }
}