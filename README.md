# Blockchain for diamond tracing
## Descritpion
This is the final assignment for Secure Data Management(SdM) course by group 2. 
The project simulates a local Ethereum blockchain based on PoA consensus protocol (Clique) in which anyone can:
- register a new diamond via one of the Certification Autorities
- buy and sell diamonds certified by certification labs
- keep track of the history of ownership for a diamond 

## Structure
The project is structured as follows:
- **address-keys/** : contains the public/private keys and the passwords for each node
- **docker/** : here are the files to set up the local blockchain
- **solidity-experiments/** : from these directory is possible to access the contract's sourcecode named "Diamond2.sol" and can be deployed via truffle
- **etherwallet/** : MyEtherWallet main directory to launch a offline version of the wallet and interact with the nodes
- **dapp-template/** : dAPP for users to check the list of available diamonds, buy/sell diamonds and check the history of the diamonds 

## How to
### Starting the local network
*See README.md in docker/ dir*

### Deploy the smart-contract
In **solidity-experiments/** run: `truffle migrate`
The smart contract we use is Dimond2.sol

### Access the node with a wallet DApp
In **etherwallet/** open *index.html* and connect to one of the node

## dAPP
*See README.md in dapp-template/*

***Note***: This project is a fork from [javahippie](https://github.com/javahippie/geth-dev) repo. All credits reserved.
