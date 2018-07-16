pragma solidity ^0.4.18;

import './IExchangeAdapter.sol';
import './IOasisExchangeProxy.sol';


contract ExchangeAdapterOasisImpl is IExchangeAdapter {

  IOasisExchangeProxy private oasisExchange;

  function ExchangeAdapterOasisImpl(address _oasisExchange) {
      oasisExchange = IOasisExchangeProxy(_oasisExchange);
  }

  function sell(address _tokenToSell, uint _sellAmount, address _tokenToGet,
      uint _minLimitAmountTokenToBuy, address _feeSponsor)
      external
      nonReentrant {
        oasisExchange.sellAllAmount(_tokenToSell, _sellAmount, _tokenToGet,
             _minLimitAmountTokenToBuy);
  }

  function getAmountToGet(address tokenToSell, uint sellAmount,
    address tokenToGet)
    public
    view
    returns(uint) {
      return oasisExchange.getBuyAmount(tokenToGet, tokenToSell, sellAmount);
  }


}
