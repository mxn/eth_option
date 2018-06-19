pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract OptionSerieToken is ERC721Token, Ownable {

  function mint(address _to, uint256 _tokenId)
  public
  onlyOwner {
    _mint(_to, _tokenId);
  }
}
