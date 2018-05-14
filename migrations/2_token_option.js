var MockToken1 = artifacts.require("MockToken1")
var MockToken2 = artifacts.require("MockToken2")
var TokenOption = artifacts.require("TokenOption")
var TokenAntiOption = artifacts.require("TokenAntiOption")
var Weth = artifacts.require("Weth")
var Dai = artifacts.require("DAI")


module.exports = function(deployer) {
  deployer.deploy(MockToken1)
  .then( () => deployer.deploy(MockToken2))
  .then( () => deployer.deploy(TokenOption))
  .then( () => deployer.deploy(Weth))
  .then( () => deployer.deploy(Dai))
  .then( dai =>
   Promise.all(web3.eth.accounts.map((acc) =>
   dai.transfer(acc, 1000*(10**18)))))
  .then( () => deployer.deploy(TokenAntiOption))
}
