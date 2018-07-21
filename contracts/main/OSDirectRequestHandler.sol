pragma solidity ^0.4.18;

import './OptionSerieToken.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract OSDirectRequestHandler is Ownable {

  uint public fee;
  OptionSerieToken optionSerieToken;
  function OSDirectRequestHandler(uint _price, address _optionSerieToken) {
    fee = fee;
    optionSerieToken = OptionSerieToken(_optionSerieToken);
  }

  function requestToken(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime)
    public
    returns(uint) {
      revert("This functionality is not available in the implentation");
    }

  function requestTokenPayable(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime)
    public
    payable
    returns(uint) {
      require(msg.value == fee);
      optionSerieToken.mintExt( msg.sender, _underlying,  _basisToken, _strike,
        _underlyingQty, _expireTime);
    }
}
