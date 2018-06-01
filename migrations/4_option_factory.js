var MockOptionFactory = artifacts.require("MockOptionFactory")
var MockWethOptionFactory = artifacts.require("MockWethOptionFactory")
var MockToken2 = artifacts.require("MockToken2")
var Weth = artifacts.require("Weth")
var OptionFactory = artifacts.require("OptionFactory")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var SimpleFeeCalculatorTest = artifacts.require("SimpleFeeCalculatorTest")


module.exports = function(deployer, network) {
  if (network == "ropsten") {
    deployer.deploy(SimpleFeeCalculator,
      "0xc778417E063141139Fce010982780140Aa0cD5Ab", //WETH address at Ropsten
      3, 10000)
      .then(feeCalc => deployer.deploy(OptionFactory, feeCalc.address))
    return
  }
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
