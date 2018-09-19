var MockOptionFactory = artifacts.require("MockOptionFactory")
var MockWethOptionFactory = artifacts.require("MockWethOptionFactory")
var MockToken2 = artifacts.require("MockToken2")
var Weth = artifacts.require("Weth")
var OptionFactory = artifacts.require("OptionFactory")
var SimpleFeeCalculator = artifacts.require("SimpleFeeCalculator")
var SimpleFeeCalculatorTest = artifacts.require("SimpleFeeCalculatorTest")
var Dai = artifacts.require("DAI")
var OptionSerieToken = artifacts.require('OptionSerieToken')
var RequestHandler = artifacts.require('OSDirectRequestHandler')
var ERC721ReceiverToOwner = artifacts.require('ERC721ReceiverToOwner')
var OptionSerieValidator = artifacts.require('OptionSerieValidator')


function getWethAddress(network) {
  switch (network) {
    case "ropsten": return "0xc778417E063141139Fce010982780140Aa0cD5Ab"
    case "kovan": return "0xd0a1e359811322d97991e03f863a0c30c2cf029c"
    case "webtest": return Weth.address
    default: throw new Error("invalid network")
  }
}

function getDaiAddress(network) {
  switch (network) {
    case "kovan": return "0xc4375b7de8af5a38a93548eb8453a498222c4ff2"
    case "webtest": return Dai.address
    default: throw new Error("invalid network")
  }
}


module.exports = function (deployer, network) {
  const sleep = inst => new Promise(resolve => setTimeout(() => resolve(inst), network == "webtest" ? 1000 : 60000))

  switch (network) {
    case "ropsten":
    case "kovan":
    deployer.deploy(SimpleFeeCalculator, getWethAddress(network), 3, 10000)
    .then(sleep)
    .then(feeCalc => deployer.deploy(OptionFactory, feeCalc.address, OptionSerieToken.address, getWethAddress(network)))
    .then(() => deployer.deploy(ERC721ReceiverToOwner))
    .then(() => deployer.deploy(OptionSerieValidator, SimpleFeeCalculator.address))
    .then(sleep)
    .then(() => deployer.deploy(RequestHandler,
      OptionSerieValidator.address, OptionSerieToken.address, OptionFactory.address, ERC721ReceiverToOwner.address))
    .then(sleep)
    .then(requestHandlerInstance => OptionSerieToken.deployed()
      .then(optionSerieToken => {
        optionSerieToken.transferOwnership(requestHandlerInstance.address)
      }))
  break

    case "webtest":
      deployer.deploy(SimpleFeeCalculator, getWethAddress(network), 3, 10000)
        .then(sleep)
        .then(feeCalc => deployer.deploy(OptionFactory, feeCalc.address, OptionSerieToken.address, Weth.address)) 
        .then(() => deployer.deploy(ERC721ReceiverToOwner))
        .then(() => deployer.deploy(OptionSerieValidator, SimpleFeeCalculator.address))
        .then(sleep)
        .then(() => deployer.deploy(RequestHandler,
          OptionSerieValidator.address, OptionSerieToken.address, OptionFactory.address, ERC721ReceiverToOwner.address))
        .then(sleep)
        .then(requestHandlerInstance => OptionSerieToken.deployed()
          .then(optionSerieToken => {
            console.log(optionSerieToken.address)
            console.log(requestHandlerInstance.address)
            optionSerieToken.transferOwnership(requestHandlerInstance.address, 
             {from: "0x5aeda56215b167893e80b4fe645ba6d5bab767de"})
          }))
      break
    default:
      deployer.deploy(SimpleFeeCalculatorTest, Weth.address, 3, 10000)
        .then(() => deployer.deploy(SimpleFeeCalculator, MockToken2.address, 2, 1))
        .then(() => deployer.deploy(OptionFactory, SimpleFeeCalculator.address,
          OptionSerieToken.address, Weth.address,
          { from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc' }))
        .then(() => deployer.deploy(MockOptionFactory, SimpleFeeCalculator.address,
          OptionSerieToken.address, Weth.address,
          { from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc' }))
        .then(() => deployer.deploy(MockWethOptionFactory,
          SimpleFeeCalculatorTest.address, OptionSerieToken.address, Weth.address,
          { from: '0x6330a553fc93768f612722bb8c2ec78ac90b3bbc' }))
        .then(() => deployer.deploy(ERC721ReceiverToOwner))
        .then(() => deployer.deploy(OptionSerieValidator,  SimpleFeeCalculatorTest.address))
        .then(() => deployer.deploy(RequestHandler,
          OptionSerieValidator.address, OptionSerieToken.address, MockWethOptionFactory.address, ERC721ReceiverToOwner.address))
  }
}
