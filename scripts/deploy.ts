import { ethers } from "hardhat";

async function main() {
  const VaultManager = await ethers.getContractFactory("VaultManager");
  const vault = await VaultManager.deploy();

  console.log(`🎉 Contract deploy at ${vault.address}`);
}

main().catch((error) => {
  console.error(error);
  throw error;
});
