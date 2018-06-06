var MockOptionFactory = artifacts.require("MockOptionFactory")
var MockWethOptionFactory = artifacts.require("MockWethOptionFactory")
var MockToken2 = artifacts.require("MockToken2")
var Weth = artifacts.require("Weth")
var OptionFactory = artifacts.require("OptionFactory")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var SimpleFeeCalculatorTest = artifacts.require("SimpleFeeCalculatorTest")

function getWethAddress(network) {
  switch (network) {
    case "ropsten": return "0xc778417E063141139Fce010982780140Aa0cD5Ab"
    case "kovan": return "0xd0a1e359811322d97991e03f863a0c30c2cf029c"
    default: throw new Error("invalid network")
  }
}

module.exports = function(deployer, network) {
  switch(network) {
    case "ropsten":
    case "kovan":
      deployer.deploy(SimpleFeeCalculator, getWethAddress(network), 3, 10000)
      .then(registry => new Promise(resolve => setTimeout(() => resolve(registry), 60000)))
      .then(feeCalc => deployer.deploy(OptionFactory, feeCalc.address))
      break
    default:
      deployer.deploy(SimpleFeeCalculatorTest, Weth.address, 3, 10000)
      .then(() => deployer.deploy(SimpleFeeCalculator, MockToken2.address, 2, 1))
      .then(() => deployer.deploy(OptionFactory, SimpleFeeCalculator.address,
         {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
      .then(() => deployer.deploy(MockOptionFactory, SimpleFeeCalculator.address,
         {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
      .then(() => deployer.deploy(MockWethOptionFactory,
         SimpleFeeCalculatorTest.address,
         {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  }
}
