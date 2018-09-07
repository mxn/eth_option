pragma solidity ^0.4.18;

import "./BaseTokenOption.sol";

contract TokenOption is BaseTokenOption {
  string public constant name = "ERC20 Option";
  string public constant symbol = "OPT";
  uint8 public constant decimals = 18;

  function isAntiOption() public view returns(bool) {
    return false;
  }
}
