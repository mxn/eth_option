pragma solidity ^0.4.18;


import "../main/IExchangeAdapter.sol";
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';
import 'zeppelin-solidity/contracts/ReentrancyGuard.sol';


contract MockExchangeAdapter is IExchangeAdapter {

  using SafeERC20 for ERC20;
  using SafeMath for uint256;

  address quotationToken;
  address token;
  uint quotationAmount;
  uint tokenAmount;

  function MockExchangeAdapter(address _quotationToken, address _token,
    uint _quotationAmount, uint _tokenAmount) {
      quotationToken = _quotationToken;
      token = _token;
      quotationAmount = _quotationAmount;
      tokenAmount = _tokenAmount;
  }

  function sell(address _tokenToSell, uint _sellAmount, address _tokenToBuy,
      uint _minLimitAmountTokenToBuy, address _feeSponsor)
      external
      nonReentrant {
        //ignore _maxLimitAmountTokenToBuy
        uint amountToGive = getAmountToGet(_tokenToSell, _sellAmount,
          _tokenToBuy);

        require( ERC20(_tokenToSell).allowance(msg.sender, this) >= _sellAmount);
        ERC20(_tokenToSell).safeTransferFrom(msg.sender, this, _sellAmount);
        uint tokenToGiveBalance = ERC20(_tokenToBuy).balanceOf(address(this));
        ERC20(_tokenToBuy).safeTransfer(msg.sender, amountToGive);
      }

  function getAmountToGet(address _tokenToSell, uint _sellAmount,
    address _tokenToGet)
    public
    view
    returns(uint) {
      require(_tokenToGet == quotationToken && _tokenToSell == token);
      return _sellAmount.mul(quotationAmount).div(tokenAmount);
  }
}
