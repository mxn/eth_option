pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract OptionSerieToken is ERC721Token, Ownable {

  function mint(address _to, uint256 _tokenId)
  public
  onlyOwner {
    _mint(_to, _tokenId);
  }

  function calcHash(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime)
   public view
   returns (bytes32) {
         return keccak256(_strike, _basisToken,
            _underlyingQty, _underlying, _expireTime);
  }

  function getTokenId(address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime)
   public
   view
   returns (uint) {
     bytes32 optionSerieHash = calcHash(_underlying, _basisToken, _strike, _underlyingQty,
       _expireTime);
     return uint(optionSerieHash);
   }

}
