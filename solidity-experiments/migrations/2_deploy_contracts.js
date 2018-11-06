var DiamondTracker2 = artifacts.require("./DiamondTracker2.sol");
var certificate_authorities = ["0x8cc5a1a0802db41db826c2fcb72423744338dcb0","0x3590aca93338b0721966a8d0c96ebf2c4c87c544"];

module.exports = function(deployer) {
  deployer.deploy(DiamondTracker2, certificate_authorities);
};
