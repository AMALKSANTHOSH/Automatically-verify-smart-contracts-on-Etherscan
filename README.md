
# Automatically verify smart contracts on Etherscan

Smart contract verification is important for decentralized projects. You can publish your project codes on etherscan.io with auto contract verification. Also, read and write function interactions will be available on etherscan.io when you verify the contract.

Although manual verification is available on etherscan.io, making verifications automated directly with Truffle is the best practice.


## Create a truffle project

Start your project with truffle init

```bash
  mkdir truffle-project
  cd truffle-project
  truffle init
```

After this command you have a boilerplate Truffle project.

Let’s code a simple smart contract.



```bash
  touch contracts/AMAL.sol
```
Add below simple lines to AMAL.sol:
    
```bash
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AMAL is ERC20 {
    constructor() ERC20("AMAL", "AML") {}
}
```

Add below lines to truffle-config.js

```bash
  compilers: {
  solc: {
    version: "0.8.6", // Fetch exact version from solc-bin (default: truffle's version)
    docker: false, // Use "0.5.1" you've installed locally with docker (default: false)
    settings: {
      // See the solidity docs for advice about optimization and evmVersion
      optimizer: {
        enabled: true,
        runs: 200,
      },
      evmVersion: "byzantium",
    },
  },
},
```
When you compile contracts you should see a success message:


```bash
  truffle compile

```
Output:


```bash
  > Compiled successfully using:
   - solc: 0.8.6+commit.11564f7e.Emscripten.clang
```

## Add truffle verification plugin to the project


```bash
  npm add -D truffle-plugin-verify
```

Then add truffle-plugin-verify inside of plugins array to truffle-config.js
```bash
plugins: [
  'truffle-plugin-verify'
  ]
```
We will install 2 packages. One for the .env file and the other one for the 
private key. You can use a private key provider or mnemonic provider. Both of
them will work.


```bash
  yarn add -D dotenv truffle-privatekey-provider

```
Add those lines at the top of your truffle-config.js
```bash
  require('dotenv').config()
  const PrivateKeyProvider = require("truffle-privatekey-provider");

```




## Create an api key on Etherscan.io

We need to generate an etherscan.io API key. Sign up and generate your API key here: https://etherscan.io/myapikey

Then add api-keys to truffle-config.js

```bash
 api_keys: {
      etherscan: process.env.ETHERSCAN_API_KEY
    }
```



## Create an api key on Infura

Create an account on infura.io and create an Ethereum project (https://infura.io/dashboard/ethereum). Click the settings of your recently created project.

Select Rinkeby testnet and copy your URL. URL should be like that: https://rinkeby.infura.io/v3/YOUR_PROJECT_ID
## Add Rinkeby network for deployment

We are about to deploy our smart contract. We need to add Rinkeby network config to truffle-config.js

```bash
  networks: {
  rinkeby: {
    provider: () => new PrivateKeyProvider(process.env.PRIVATE_KEY, process.env.RINKEBY_INFURA_URL),
    network_id: 4,       // Ropsten's id
    gas: 5500000,        // Ropsten has a lower block limit than mainnet
    confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
  },
},
```
## Create .env file and add environment variables

```bash
   touch .env

```

.env file should contain:

```bash
   
RINKEBY_INFURA_URL=https://rinkeby.infura.io/v3/YOUR_INFURA_PROJECT_URL
PRIVATE_KEY=YOUR_PRIVATE_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```
## Create a migration for the contract deployment
```bash
   truffle create migration 2_intial_migration


```
You will see a new file in the migrations folder. We will add those lines to number_storage.js
```bash
  module.exports = async function(deployer) {
  const NumberStorage = artifacts.require("NumberStorage");

  await deployer.deploy(NumberStorage);
  const contract = await NumberStorage.deployed();

  console.log("Contract address:", contract.address)
};

```
## Deploy the contract
```bash
truffle migrate --network rinkeby


```

It will take a few minutes to deploy the contract.


Contract is not verified yet, let’s verify it.




## Verify the contract
```bash
  truffle run verify NumberStorage --network rinkeby


```

It will take a while to verify.

