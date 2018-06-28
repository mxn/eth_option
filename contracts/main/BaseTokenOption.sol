pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol';

contract BaseTokenOption is ERC827Token, BurnableToken, MintableToken {

  uint8 public constant decimals = 18;

  function getOptionPair() public view returns (address) {
    return owner;
  }

  function isAntiOption() public view returns(bool);
}
