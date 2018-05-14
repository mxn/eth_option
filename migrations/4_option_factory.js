var MockOptionFactory = artifacts.require("MockOptionFactory")
var MockToken2 = artifacts.require("MockToken2")
var OptionFactory = artifacts.require("OptionFactory")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")


module.exports = function(deployer) {
  deployer.deploy(SimpleFeeCalculator, MockToken2.address, 2, 20)
//.then(() => deployer.deploy(FeeTaker, SimpleFeeCalculator.address, 3, 4))
  .then(() => deployer.deploy(OptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
  .then(() => deployer.deploy(MockOptionFactory, SimpleFeeCalculator.address, {from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc'}))
}
