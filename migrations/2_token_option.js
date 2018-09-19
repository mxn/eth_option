var MockToken1 = artifacts.require("MockToken1")
var MockToken2 = artifacts.require("MockToken2")
var TokenOption = artifacts.require("TokenOption")
var TokenAntiOption = artifacts.require("TokenAntiOption")
var Weth = artifacts.require("Weth")
var Dai = artifacts.require("DAI")
var OptionSerieToken = artifacts.require("OptionSerieToken")

module.exports = function(deployer, network) {
  switch (network) {
    case "ropsten":
    case "kovan":
      deployer.deploy(OptionSerieToken)
      break
  default:
    deployer.deploy(MockToken1)
    .then( () => deployer.deploy(OptionSerieToken, {from: "0x5aeda56215b167893e80b4fe645ba6d5bab767de"}))
    .then( () => deployer.deploy(MockToken2))
    .then( () => deployer.deploy(Weth))
    .then( () => deployer.deploy(Dai))
    .then( dai =>
     web3.eth.getAccounts((e, accs) =>
       accs.map((acc) =>
     dai.transfer(acc, 100000*(10**18)))))
   }
}
