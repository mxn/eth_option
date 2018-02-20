var OptionPair = artifacts.require("OptionPair")
var MockOptionPair = artifacts.require("MockOptionPair")
var MockToken1 = artifacts.require("MockToken1")
var MockToken2 = artifacts.require("MockToken2")
var FeeCalculator = artifacts.require("FeeCalculator")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var OptionFactory = artifacts.require("OptionFactory")
var MockOptionFactory = artifacts.require("MockOptionFactory")
var EBOE = artifacts.require("EBOE")
var FeeTaker = artifacts.require("FeeTaker")


module.exports = function(deployer) {
  deployer.deploy(SimpleFeeCalculator, MockToken2.address, 2, 20)
//  .then( () => deployer.deploy(OptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
//  .then( () => deployer.deploy(MockOptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
}
