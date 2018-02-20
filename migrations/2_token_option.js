var MockToken1 = artifacts.require("MockToken1")
var MockToken2 = artifacts.require("MockToken2")
var TokenOption = artifacts.require("TokenOption")
var TokenAntiOption = artifacts.require("TokenAntiOption")

module.exports = function(deployer) {
  deployer.deploy(MockToken1)
  .then( () => deployer.deploy(MockToken2))
  .then( () => deployer.deploy(TokenOption))
  .then( () => deployer.deploy(TokenAntiOption))
}
