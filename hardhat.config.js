require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    tenderly: {
      url: process.env.TENDERLY_RPC_URL || "https://virtual.mainnet.eu.rpc.tenderly.co/b9db31e9-62e5-4198-b1b0-98a5ecece8a3",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
      chainId: 1,
      gasPrice: 20000000000, // 20 gwei
      gasLimit: 8000000
    }
  }
};