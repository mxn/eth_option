var MockExchangeAdapter = artifacts.require("MockExchangeAdapter")
var MockOasisDirect = artifacts.require("MockOasisDirect")
var Dai = artifacts.require("DAI")
var Weth = artifacts.require("Weth")
var ExchangeAdapterOasisImpl = artifacts.require("ExchangeAdapterOasisImpl")


module.exports = function(deployer, network) {
  switch (network) {
    case "ropsten":
    case "kovan":
      deployer.deploy(ExchangeAdapterOasisImpl,
        "0xee419971e63734fed782cfe49110b1544ae8a773")
      break
  default:
    deployer.deploy(MockExchangeAdapter,
      Dai.address, Weth.address, 220, 2) //for unit testing purposes
    .then(() => deployer.deploy(MockOasisDirect))
    .then(exch => Dai.deployed().then(daiInst => daiInst.transfer(exch.address, 100000*(10**18))))
    .then(() => deployer.deploy(ExchangeAdapterOasisImpl,
      MockOasisDirect.address))
  }
}
