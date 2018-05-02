contract IFeeTaker {
  function takeOptionPairCreationFee (address _underlying, address _basisToken,
   uint _strike, uint _underlyingQty, uint _expireTime, address _creator);
  function takeFee (address _optionPair, uint _optionQty, address _writer);
}
