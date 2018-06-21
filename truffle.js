const HDWalletProvider = require("truffle-hdwallet-provider")
require('dotenv').config()

module.exports = {
  //seems does not work with migration
  //contracts_build_directory: "./src/contracts",
  networks: {
    webtest: {
      host: "127.0.0.1",
      port: 8545,
      network_id: 5777 // match any network
    },
    ropsten: {
      provider: new HDWalletProvider(process.env.DEPLOYER_PASSPHRASE, "https://ropsten.infura.io/" + process.env.INFURA_ACCESS_TOKEN),
      network_id: 3
    },
    kovan: {
      provider: new HDWalletProvider(process.env.DEPLOYER_PASSPHRASE, "https://kovan.infura.io/" + process.env.INFURA_ACCESS_TOKEN),
      network_id: 42
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 5
    }
  }
};
