pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ReentrancyGuard.sol';

contract IExchangeAdapter is ReentrancyGuard{
  function sell(address tokenToSell, uint sellAmount, address tokenToGet,
      uint minLimitAmountTokenToBuy, address feeSponsor)
      external
      nonReentrant;
  function getAmountToGet(address tokenToSell, uint sellAmount, address tokenToGet)
    public
    view
    returns(uint);
}
