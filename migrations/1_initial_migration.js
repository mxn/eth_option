var Migrations = artifacts.require("./Migrations.sol");

function getTransactionObject(network) {
  if (network === "kovan") {
    return {from: "0xdE4eD43183CB7AF6E46b31E0f14F90d0452b6b78"}
  } else {
    return {}
  }
}

module.exports = function(deployer, network) {
  deployer.deploy(Migrations, getTransactionObject(network));
};
