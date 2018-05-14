module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  /* networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 17984452, // Block Gas Limit same as latest on Mainnet https://ethstats.net/
      //gasPrice: 2000000000, // same as latest on Mainnet https://ethstats.net/
    }
  }, */
  solc: {
  optimizer: {
    enabled: true,
    runs: 3
  }
}

};
