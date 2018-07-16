pragma solidity ^0.4.18;

import './IExchangeAdapter.sol';
import './IOasisExchangeProxy.sol';

import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';


contract ExchangeAdapterOasisImpl is IExchangeAdapter {

  using SafeERC20 for ERC20;

  IOasisExchangeProxy private oasisExchange;

  function ExchangeAdapterOasisImpl(address _oasisExchange) {
      oasisExchange = IOasisExchangeProxy(_oasisExchange);
  }

  function sell(address _tokenToSell, uint _sellAmount, address _tokenToGet,
      uint _minLimitAmountTokenToBuy, address _feeSponsor)
      external
      nonReentrant {
        ERC20(_tokenToSell).safeTransferFrom(msg.sender, this, _sellAmount);
        ERC20(_tokenToSell).approve(address(oasisExchange), _sellAmount);
        uint amountToGive = oasisExchange.sellAllAmount(_tokenToSell, _sellAmount, _tokenToGet,
             _minLimitAmountTokenToBuy);
        ERC20(_tokenToGet).safeTransfer(msg.sender, amountToGive);
  }

  function getAmountToGet(address tokenToSell, uint sellAmount,
    address tokenToGet)
    public
    view
    returns(uint) {
      return oasisExchange.getBuyAmount(tokenToGet, tokenToSell, sellAmount);
  }


}
