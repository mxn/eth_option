pragma solidity ^0.4.18;

import "./BaseTokenOption.sol";

contract TokenOption is BaseTokenOption {
  string public constant name = "ERC20 Option";
  string public constant symbol = "OPT";

  function isAntiOption() public view returns(bool) {
    return false;
  }
}
