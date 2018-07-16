pragma solidity ^0.4.18;


/**
* make corresponding signatures from
*/
contract IOasisExchangeProxy {
  function sellAllAmount(address pay_gem, uint pay_amt, address buy_gem,
    uint min_fill_amount)
    public
    returns (uint);
  function getBuyAmount(address buy_gem, address pay_gem, uint pay_amt)
    public
    constant
    returns (uint fill_amt);
}
