import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const nftChoose: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("NftChoose", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });
};

export default nftChoose;

nftChoose.tags = ["NftChoose"];
