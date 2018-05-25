var MockOptionFactory = artifacts.require("MockOptionFactory")
var MockWethOptionFactory = artifacts.require("MockWethOptionFactory")
var MockToken2 = artifacts.require("MockToken2")
var Weth = artifacts.require("Weth")
var OptionFactory = artifacts.require("OptionFactory")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var SimpleFeeCalculatorTest = artifacts.require("SimpleFeeCalculatorTest")


module.exports = function(deployer, network) {
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
