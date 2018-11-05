/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() {
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>')
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  // rpc: {
  //     host:"127.0.0.1",
  //     port:8547
  // },
  networks: {
      development: {
          host: "127.0.0.1", //our network is running on localhost
          port: 8549, // port where your blockchain is running
          network_id: "*",
          from: "0xf991a63237d8d5b97de53f2bdc2d200d2b430533", // use the account-id generated during the setup process
          // gas: 0
          gasPrice: 0,
      }
  }
};
