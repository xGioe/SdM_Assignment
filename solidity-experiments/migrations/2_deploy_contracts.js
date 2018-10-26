var Purchase = artifacts.require("./Purchase.sol");
var Escrow = artifacts.require("./Escrow.sol");
var Test = artifacts.require("./Test.sol");
module.exports = function(deployer) {
   // deployer.deploy(purchase);
   // deployer.deploy(Escrow, '0x3590aca93338b0721966a8d0c96ebf2c4c87c544', '0x4e79423a920def8a35f312c9632cd6429025e44c');
   deployer.deploy(Test);
};
