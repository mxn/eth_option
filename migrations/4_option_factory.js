var FeeTaker = artifacts.require("FeeTaker")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var OptionFactory = artifacts.require("OptionFactory")
var MockOptionFactory = artifacts.require("MockOptionFactory")
var OptionRegistry = artifacts.require("OptionRegistry")

module.exports = function(deployer) {
  deployer.deploy(FeeTaker, SimpleFeeCalculator.address, 3, 4)
  .then(() => deployer.deploy(OptionRegistry, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  //.then(() => deployer.deploy(OptionPair, MockToken1.address, MockToken2.address, 100,100, new Date() / 1000 + 60*60, "H", FeeTaker.address))
  .then(() => deployer.deploy(OptionFactory, FeeTaker.address, OptionRegistry.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  .then(() => deployer.deploy(MockOptionFactory, FeeTaker.address, OptionRegistry.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  .then(() => OptionRegistry.deployed())
  .then((o) => o.transferOwnership(MockOptionFactory.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'} ))
//  .then( () => deployer.deploy(OptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  //.then( () => deployer.deploy(MockOptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
}
