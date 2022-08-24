// function deployFunc() {
//     console.log("Hi")
//
// }

const { network } = require("hardhat")

// modeule.exports.default = deployFunc()

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const { networkConfig } = require("../helper-hardhat-config")
  // const helperConfig = require("../helper-hardhat-config")
  // const networkConfig = helperConfig.networkConfig
  const chainId = network.config.chainId

  const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
  

  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: [address],
    log: true
  })
}
