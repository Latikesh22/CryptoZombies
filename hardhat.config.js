/** @type import('hardhat/config').HardhatUserConfig */
// import { HardhatUserConfig, task } from "hardhat/config";
require('@nomiclabs/hardhat-ethers');
const { alchemyApiKey, mnemonic } = require('./secrets.json');
module.exports = {
  solidity: "0.8.17",
     networks: {
        goerli: {
          url: `https://eth-goerli.alchemyapi.io/v2/${alchemyApiKey}`,
          accounts: { mnemonic: mnemonic },
         },
      },
};
