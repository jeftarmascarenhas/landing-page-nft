import * as dotenv from "dotenv";
dotenv.config();
import { ethers, Wallet } from "ethers";
import QRcode from "qrcode";
import { config } from "hardhat";

async function main() {
  const privateKey = process.env.DEPLOYER_PRIVATE_KEY;

  if (!privateKey) {
    console.log(
      "You dont't have a deployer account. Run `yarn generate` first"
    );
    return;
  }

  const wallet = new Wallet(privateKey);
  const address = wallet.address;

  console.log(
    await QRcode.toString(address, { type: "terminal", small: true })
  );
  console.log("Public address: ", address, "\n");

  const availableNetworks = config.networks;
  for (const networkName in availableNetworks) {
    try {
      const network = availableNetworks[networkName];
      if (!("url" in network)) continue;
      const provider = new ethers.JsonRpcProvider(network.url);
      const balance = await provider.getBalance(address);
      console.log("--", network, "--");
      console.log("  balance:", +ethers.formatEther(balance));
      console.log("  nonce:", +(await provider.getTransactionCount(address)));
    } catch (error) {
      console.log("Can't connect to network", networkName);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 0;
});
