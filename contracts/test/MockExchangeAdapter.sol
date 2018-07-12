pragma solidity ^0.4.18;


import "../main/IExchangeAdapter.sol";
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';


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
      uint _minLimitAmountTokenToBuy, address _feeSponsor) {
        //ignore _maxLimitAmountTokenToBuy
        require(_tokenToSell == quotationToken || _tokenToSell == token);
        require(_tokenToBuy == quotationToken || _tokenToBuy == token);
        require( ERC20(_tokenToSell).allowance(msg.sender, this) >= _sellAmount);

        ERC20(_tokenToSell).safeTransferFrom(msg.sender, this, _sellAmount);
        uint tokenToGiveBalance = ERC20(_tokenToBuy).balanceOf(address(this));
        uint amountToGive = _sellAmount.mul(quotationAmount).div(tokenAmount);
        ERC20(_tokenToBuy).safeTransfer(msg.sender, amountToGive);
      }
}
