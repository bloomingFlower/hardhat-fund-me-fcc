const { network } = require("hardhat")
const { networkConfig, developmentChain } = require("../helper-hardhat-config")

// modeule.exports.default = deployFunc()

// const helperConfig = require("../helper-hardhat-config")
// const networkConfig = helperConfig.networkConfig

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId

  const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]

  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: [address],
    log: true
    //    waitConfirmations:
  })
}
