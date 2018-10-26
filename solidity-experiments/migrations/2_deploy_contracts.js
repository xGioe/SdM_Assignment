var purchase = artifacts.require("../contracts/purchase.sol");
var escrow = artifacts.require("../contracts/escrow.sol");
module.exports = function(deployer) {
   deployer.deploy(purchase);
   deployer.deploy(escrow, '0x3590aca93338b0721966a8d0c96ebf2c4c87c544', '0x4e79423a920def8a35f312c9632cd6429025e44c');
};
