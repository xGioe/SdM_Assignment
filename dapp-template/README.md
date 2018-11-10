# DApp Template

1. Clone me and install dependencies
```
git clone https://github.com/Blockchain-Learning-Group/dapp-template.git
cd dapp-template && npm install
```

2. Start testrpc, in a separate window
```
$ testrpc
```

3. Deploy the contract
```
dapp-template $ truffle migrate --reset
```

4. Update the contract address in app/client/home.js, line 5
```
const contractAddress = '0x06f79f557ebdf223b7d088edb10ddd44d304ac4c'
```

5. Run the server
```
dapp-template $ cd app
app $ node server
```

6. Load the app, [http://localhost:9191/](http://localhost:9191/)
