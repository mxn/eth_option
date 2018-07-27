pragma solidity ^0.4.18;

contract IOptionSerieRequestHandler {
  /** returns optionpair address and tokenId */
  function requestToken(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime, address _feeCalculator)
    public
    returns(address, uint);
  /** returns option pair address and tokenId*/
  function requestTokenPayable(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime, address _feeCalculator)
    public
    payable
    returns(address, uint);
  function claimToken(uint tokenId) public;
}
