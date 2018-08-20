pragma solidity ^0.4.18;

import './ITokenReceiver.sol';
import './OptionFactory.sol';
import './OptionSerieValidator.sol';
import './OptionSerieToken.sol';

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract OSDirectRequestHandler is Ownable {

  uint public fee;
  OptionSerieToken public optionSerieToken;
  OptionFactory public optionFactory;
  OptionSerieValidator public optionSerieValidator;
  ITokenReceiver public tokenReceiver;

  mapping (uint => address) optionSerietoken2optionPair;

  function OSDirectRequestHandler(address _optionSerieValidator,  address _optionSerieToken, 
  address _optionFactory, address _tokenReceiver) {
    optionSerieToken = OptionSerieToken(_optionSerieToken);
    optionFactory = OptionFactory(_optionFactory);
    optionSerieValidator = OptionSerieValidator(_optionSerieValidator);
    tokenReceiver = ITokenReceiver(_tokenReceiver);
  }

  function setOptionSerieValidator(address _optionSerieValidator)
  public
  onlyOwner
  {
    optionSerieValidator = OptionSerieValidator(_optionSerieValidator);
  }

  function setTokenReceiver(address _tokenReceiver) 
  public
  onlyOwner
  {
    tokenReceiver = ITokenReceiver(_tokenReceiver);
  }

  function requestOptionSerie(address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime, address _feeCalculator)
    public
    returns(address, uint) {
      require(optionSerieValidator.isValidRequest( _underlying, _basisToken,
     _strike, _underlyingQty, _expireTime, _feeCalculator));
     
      uint tokenId = optionSerieToken.mintExt( this, _underlying,  _basisToken, _strike,
        _underlyingQty, _expireTime);
      
      assert (optionSerieToken.ownerOf(tokenId) == address(this));
      address optionPair = optionFactory.createOptionPairContract(_underlying,  _basisToken,
         _strike,  _underlyingQty,  _expireTime);
     
      optionSerietoken2optionPair[tokenId] = optionPair;
      optionSerieToken.transfer(tokenReceiver, tokenId);
      tokenReceiver.onReceive(optionSerieToken, tokenId, msg.sender);
      return (optionPair, tokenId);
    }
}
