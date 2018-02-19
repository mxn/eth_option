pragma solidity ^0.4.18;

import "./OptionPair.sol";

contract MockOptionPair is OptionPair  {
  uint mockTime  = 0;

  function MockOptionPair (address _underlying, address _basisToken,
    uint _strike, uint _underlyingQty, uint _expireTime,  address _feeTaker, address _owner)
    public
    OptionPair(_underlying,  _basisToken,
       _strike,  _underlyingQty,  _expireTime,  _feeTaker, _owner)  {}

  function getCurrentTime() public view returns(uint) {
    if (mockTime > 0) {
      return mockTime;
    }
    return now;
  }

  function updateMockTime(uint _mockTime) public returns(bool) {
    mockTime = _mockTime;
    return true;
  }

}


