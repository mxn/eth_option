pragma solidity ^0.4.18;

import "./IFeeCalculator.sol";
import "./TokenOption.sol";

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';
import './OptionPair.sol';

contract FeeTaker is Ownable, IFeeTaker {
  using SafeERC20 for ERC20;
  using SafeMath for uint;
  IFeeCalculator public feeCalculator;
  uint public pairOwnerFeePartNominator;
  uint public pairOwnerFeePartDenominator;

  function FeeTaker (address _feeCalculator, uint _pairOwnerFeePartNominator,
    uint _pairOwnerFeePartDenominator) public
    Ownable()
  {
    require (_pairOwnerFeePartDenominator >= _pairOwnerFeePartNominator);
    feeCalculator = IFeeCalculator(_feeCalculator);
    pairOwnerFeePartNominator = _pairOwnerFeePartNominator;
    pairOwnerFeePartDenominator = _pairOwnerFeePartDenominator;
  }

  function setFeeCalculator(IFeeCalculator _feeCalculator) public onlyOwner {
    feeCalculator = _feeCalculator;
  }

  function withdraw(address _token, uint _amount) public onlyOwner {
    require(msg.sender == owner);
    ERC20 tokenErc20 = ERC20 (_token);
    require(tokenErc20.balanceOf(this) >= _amount);
    tokenErc20.safeTransfer(owner, _amount);
  }

  function takeOptionPairCreationFee (address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime, address _creator) public {
    ERC20 feeToken = ERC20(feeCalculator.feeToken());
    uint fee = feeCalculator.calcOptionCreationFee(_underlying,_basisToken,
     _strike, _underlyingQty, _expireTime);
     feeToken.safeTransferFrom(_creator, this, fee);
  }

  function takeFee (address _optionPair, uint _optionQty, address _writer) public {
    uint fee = feeCalculator.calcFee(_optionPair, _optionQty);
    ERC20 feeToken = ERC20(feeCalculator.feeToken());
    uint feeForOptionPairOwner = fee.mul(pairOwnerFeePartNominator).div(pairOwnerFeePartDenominator);
    feeToken.safeTransferFrom(_writer, OptionPair(_optionPair).owner(), feeForOptionPairOwner);
    feeToken.safeTransferFrom(_writer, this, fee - feeForOptionPairOwner);
  }
}
