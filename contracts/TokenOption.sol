pragma solidity ^0.4.18;

import "./BaseTokenOption.sol";

contract TokenOption is BaseTokenOption {
  function isAntiOption() public view returns(bool) {
    return false;
  }
}
