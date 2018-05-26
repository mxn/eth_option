pragma solidity ^0.4.18;

import "./BaseTokenOption.sol";

contract TokenAntiOption is BaseTokenOption {
  function isAntiOption() public view returns(bool) {
    return true;
  }
}
