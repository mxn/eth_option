# Option contracts as ERC20-compatible tokens

## Preface

Currently it seems that there is no suitable analog for "off-chain" option contracts in Ethereum blockchain, although, due to numbers of tokens and market volatility, there are much requirements for them. Here is an attempt to implement one. General information about option contracts one can read in Wikipedia [Option (finance)](https://en.wikipedia.org/wiki/Option_(finance)) article. Below there are some specific things about implementation, based on Ethereum smart contracts.

## Contracts

*Option Contract*. Gives its owner a right to get specified underlying (ERC20) tokens in exchange for basis ERC20 tokens during the period before expiration at the specified price (strike price). The transaction, which uses this right is called "exercise"

*Anti-Option Contract*. Gives a right to get "non-exercised" part of deposited underlying and “exercised” part of basis token after the expiration date, or, if combined with *Option Contract*, to get the corresponding token amount before the expiration date.

## Actors

1. *Option House*: owner the generating contracts, defines the fee policy.

2. *Option "Line" Creator*: creates the “meta” option contract, which specifies ERC20 token pair (underlying and basis), strike price  and expiration date. As compensation she receives part (e.g. 15/16) of fee paid by *Option Writer* (s. below).

3. *Option Writer*. Deposits the  "underlying" ERC20-compatible tokens with minimum amount specified by by Option Line. in exchange she gets ERC20-compatible option contract  as well  as ERC20-compatible “anti-option” contract (s. later). For this transaction *Option Writer* pays fee.

4. *Option Buyer*. Buys *Option Contracts* e.g. on exchanges (the *Option Contracts* are fully ERC20-compatible), via 0x protocol etc.

5. *Anti-Option Buyer*. As *Option Writer* side of contracts is tokenized, one can sell / buy the *Option Writer* right to withdraw the deposit after expiration time too.

## Example 1

Ann creates "meta" option contract with the underlying WETH (wrapped Ethereum, to make it ERC20-compatible) and basis DAI, with the strike price 3000 and expiration date 31.12.2018 (current price at the time of writing is about  900 DAI per WETH).

Bob "writes" 10 option contracts. That is he deposits 10 WETH and get 10 Option (OPT_WETH_DAI_2018_12_31) and 10 Anti-Option contracts (A_OPT_WETH_DAI_2018_12_31).  At this point the fee are taken, 0.016 per contract, that is 0.16 ETH. 0.15 ETH went to Ann, as *Option Line Creator* and 0.01 ETH to *Option House* (preliminary split fee taker split ratio). Note in the tables below the fees are not considered!

<table>
  <tr>
    <td></td>
    <td>OPT_WETH_DAI_2018_12_31</td>
    <td>A_OPT_WETH_D
AI_2018_12_31</td>
    <td>WETH</td>
    <td>DAI</td>
  </tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>10</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>10</td>
    <td>10</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>350</td>
  </tr>
</table>


Bob sells 7  OPT_WETH_DAI_31_12_2018 contracts to Clair for 50 DAI (actually could be any asset)

<table>
  <tr>
    <td></td>
    <td>OPT_WETH_DAI_2018_12_31</td>
    <td>A_OPT_WETH_D
AI_2018_12_31</td>
    <td>WETH</td>
    <td>DAI</td>
  </tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>10</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>3</td>
    <td>10</td>
    <td>0</td>
    <td>350</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>7</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
</table>


At 01.09.2018 Bob will get back some WETH. He "annihilates" the remaining 3 OPT_1_WETH_3000_DAI_2018_12_31 with 3 anti-option contracts (A_OPT_1_WETH_3000_DAI_2018_12_31) and gets 3 from WETH back

<table>
  <tr>
    <td></td>
    <td>OPT_1_WETH_3000_DAI_2018_12_31</td>
    <td>A_OPT_1_WETH_3000_DAI_2018_12_31</td>
    <td>WETH</td>
    <td>DAI</td>
  </tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>7</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>0</td>
    <td>7</td>
    <td>3</td>
    <td>350</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>7</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
</table>


The price of Ethereum went up and per 2018-11-01 the price reaches 4000 DAI per WETH. Clair decides to exercise 5 of her options. So she borrows and transfers 5 * 3000 (strike price) to meta-option contract and get back 5 WETH. These 5 WETH she sells on exchange at 4000 to make 5000 (5 * (4000 - 3000) ) DAI. Two option contracts she would like to hold for further growth.

<table>
<tr>
  <td></td>
  <td>OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>A_OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>WETH</td>
  <td>DAI</td>
</tr>
  </tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>2</td>
    <td>15000</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>0</td>
    <td>7</td>
    <td>3</td>
    <td>350</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>2</td>
    <td>0</td>
    <td>5</td>
    <td>0</td>
  </tr>
</table>


<table>
<tr>
  <td></td>
  <td>OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>A_OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>WETH</td>
  <td>DAI</td>
</tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>2</td>
    <td>15000</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>0</td>
    <td>7</td>
    <td>3</td>
    <td>350</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>2</td>
    <td>0</td>
    <td>0</td>
    <td>5000</td>
  </tr>
</table>


Suddenly the price drops for 2000 DAI (below strike) per WETH and remains below the strike price till expiration date. After expiration date Bob can withdraw the remaining 2 WETH (10 initial - 3 annihilated - 5 exercised) and 15000 DAI (from exercised part)



<table>
<tr>
  <td></td>
  <td>OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>A_OPT_1_WETH_3000_DAI_2018_12_31</td>
  <td>WETH</td>
  <td>DAI</td>
</tr>
  <tr>
    <td>Meta-Option Contract</td>
    <td></td>
    <td></td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Bob</td>
    <td>0</td>
    <td>0</td>
    <td>5</td>
    <td>15350</td>
  </tr>
  <tr>
    <td>Clair</td>
    <td>2 (expired)</td>
    <td>0</td>
    <td>0</td>
    <td>5000</td>
  </tr>
</table>


## Others

* Put option contract

    * There is no need for them: just swap underlying and base token. In this case Ann needs to create line with underlying DAI, base WETH, e.g. 1 WETH per 500 DAI

* Differences to "normal" option contract

    * Due to tokenissation of the writer part of the contracts, the exercised and not-execrisced part of the contracts are shared among all writers. E.g if Bob writes 10 options by deposiing 10 WETH, Dan writed 30 options (30 WETH) and only 10 of them were executed for strike 3000 DAI, after expiration date Bob can withfraw 7.5 WETH plus 2.5 * 3000 DAI and Dan can withdraw 22.5 WETH and 7.5 * 3000 DAI



## Current State

As POC the smart contracts with pluggable fee taker mechanism are implemented, and partially tested (code audit is needed). I believe that one needs to make some community  and option line creator (in the example Ann) should be chosen on one hand via auction, on the other should be paid back with some governance tokens. This governance mechanism should be more thoroughly thought and implemented. European style option could be implemented relatively easily.

The implementation was in my spare time, I am now a little under stress on my main job. Generally I would be glad to find some partners and investors to proceed with the things further with more dedicated time for it and for further development (I have a couple other ideas).
