pragma solidity ^0.4.18;

contract IExchangeAdapter {
  function sell(address tokenToSell, uint sellAmount, address tokenToBuy,
      uint minLimitAmountTokenToBuy, address feeSponsor);
}
