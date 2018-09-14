pragma solidity ^0.4.18;

import '../main/IAuction.sol';

contract MockAuction is IAuction {
  
  uint32 public auctionTime;
  uint32 public revealTime;
  mapping (uint => uint) token2startTime;

  function MockAuction(uint32 _auctionTime, uint32 _revealTime) {
    auctionTime = _auctionTime;
    revealTime = _revealTime;
  }

  function creaateAuction(uint token) public {
    require(token2startTime[token] == 0);
    token2startTime[token] = now;
  }

  function isActivated(uint _token) public view returns(bool) {
    return token2startTime[_token] > 0;
  }

  function isBettingActive(uint token) public view returns(bool) {
    uint startTime = token2startTime[token];
    return  startTime > 0 && 
      now >= startTime && 
      now < startTime + auctionTime;
  }
  
  function isRevealed(uint token) public view returns(bool) {
    
  }
  function getWinner(uint token) public view returns(address);
}