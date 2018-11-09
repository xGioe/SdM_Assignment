# Local Ethereum Network
A set of Docker images to create a local Ethereum network with three nodes and a monitor. This was built to understand how local Ethereum networks have to be set up and to provide a local test environment. **Never use this in a productive environment, as the docker-compose.yml contains hardcoded passwords and private keys for convenience**

## Usage
Setting up this networks requires you to install Docker. Clone the repository, and run `docker-compose up` from the repository root. The network should start and synchronize without any further configuration. The networks uses go-ethereum 1.18.15 and swarm 0.3.4, the network is set up for clique proof-of-authority similar to the Ethereum Rinkeby testnet. For more information on clique POA see https://github.com/ethereum/EIPs/issues/225 .

## The bootnode
The nodes in the network are connecting with the bootnode. This is a special ethereum node, designed to provide a register of the existing nodes in the network. The parameter `nodekeyhex`in the `docker-compose.yml` is needed to derive the `enodeID` which is later passed to the other nodes. The IP needs to be fixed, as the other nodes need to know where to find the bootnode, and DNS is not supported. The bootnode does not participate in synchronization of state or mining.

## Validators
There are three nodes that participate in the network. The state is synchronized between them and they are trying to create blocks with mining. Initially they connect to the bootnode with the information derived from the fixed IP and the nodekeyhex. If you want to interact with the network, you need to connect via RPC. You can attach a geth instance, connect Remix IDE or connect your browser with web3 and build a ÐApp.

The RPC Ports of the nodes are mapped to your localhost, the addresses are:

* [http://localhost:8545](http://localhost:8545) - geth-ca-1
* [http://localhost:8546](http://localhost:8546) - geth-ca-2

## Nodes
There are two simple nodes namely a buyer and a seller to simulate a demo scenario of a diamond purchase, tracked on the platform

* [http://localhost:8547](http://localhost:8547) - geth-seller-1
* [http://localhost:8548](http://localhost:8547) - geth-buyer-1

## Master Node
This is the node managed by the platform owner which is responsible only to the deployment of the smart contract "Diamond2.sol"

[http://localhost:8549](http://localhost:8545) - geth-master

## Monitoring
The monitoring is being provided by two nodes, the monitoring-backend and the monitoring-frontend. The backend connects to the ethereum nodes and retrieves metrics from them. It communicates with the monitoring-frontend with websockets. The frontend can be found under [http://localhost:3000](http://localhost:3000)

## Blockchain Explorer
The blockchain explorer is a simple node.js web application being provided by a seperate container: geth-explorer. The application uses the web3 javascript API to fetch the data from the nodes through RPC calls. The blockchain explorer can be found at [http://localhost:8080](http://localhost:8080) - geth-explorer
