pragma solidity ^0.4.18;

import './ChildOwnershipClaimable.sol';

contract IOptionSerieRequestHandler is ChildOwnershipClaimable {
  function requestToken(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime)
    public
    returns(uint);
  function requestTokenPayable(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime)
    public
    payable
    returns(uint);
}
