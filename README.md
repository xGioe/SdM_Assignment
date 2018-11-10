# Blockchain for diamond tracing
## Descritpion
This is the final assignment for Secure Data Management(SdM) course.
The project simulates a local Ethereum blockchain based on PoA consensus protocol in which anyone can:
- register new diamond via one of the certification autorities;
- buy and sell diamonds certified by trusted authorities;
- keep track of the history of ownership for a diamond. 

## Structure
The project is structured as follows:
- **address-keys/** : contains the public/private keys and the passwords for each node
- **docker/** : here are the files to set up the local blockchain
- **solidity-experiments/** : from these directory is possible to access the contract's sourcecode named "Diamond2.sol" and can be deployed via truffle
- **etherwallet/** : MyEtherWallet main directory to launch a offline version of the wallet and interact with the nodes

## How to
### Starting the local network
*See README.md in docker/ dir*

### Deploy the smart-contract
In **solidity-experiments/** run: `truffle migrate`

### Access the node with a wallet DApp
In **etherwallet/** open *index.html* and connect to one of the node

***Note***: This project is a fork from [javahippie](https://github.com/javahippie/geth-dev) repo. All credits reserved.
