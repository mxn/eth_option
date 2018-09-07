pragma solidity ^0.4.18;

import "./BaseTokenOption.sol";

contract TokenAntiOption is BaseTokenOption {
  string public constant name = "ERC20 Anti-Option";
  string public constant symbol = "AOPT";
  uint8 public constant decimals = 18;

  function isAntiOption() public view returns(bool) {
    return true;
  }
}
