var MockToken1 = artifacts.require("MockToken1")
var MockToken2 = artifacts.require("MockToken2")
var TokenOption = artifacts.require("TokenOption")
var TokenAntiOption = artifacts.require("TokenAntiOption")
var Weth = artifacts.require("Weth")
var Dai = artifacts.require("DAI")

module.exports = function(deployer, network) {
  switch (network) {
    case "ropsten":
    case "kovan":
      deployer.deploy(Dai)
      .then(registry => new Promise(resolve => setTimeout(() => resolve(registry), 60000)))
      .then(dai =>
       web3.eth.getAccounts((e, accs) =>
        accs.map(acc => dai.transfer(acc, 100000*(10**18)))))
      break
  default:
    deployer.deploy(MockToken1)
    .then( () => deployer.deploy(MockToken2))
    .then( () => deployer.deploy(Weth))
    .then( () => deployer.deploy(Dai))
    .then( dai =>
     web3.eth.getAccounts((e, accs) =>
       accs.map((acc) =>
     dai.transfer(acc, 1000*(10**18)))))
   }
}
