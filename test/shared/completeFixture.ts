import { Fixture } from "ethereum-waffle";
import { constants } from "ethers";
import { ethers } from "hardhat";

// eslint-disable-next-line node/no-missing-import
import { TestERC20, VaultManager } from "../../typechain";

const completeFixture: Fixture<{
  vault: VaultManager;
  token: TestERC20;
}> = async ([wallet], provider) => {
  const tokenFactory = await ethers.getContractFactory("TestERC20");
  const vaultFactory = await ethers.getContractFactory("VaultManager");

  const token: TestERC20 = await tokenFactory.deploy(
    constants.MaxUint256.div(2)
  );

  const vault: VaultManager = await vaultFactory.deploy();

  return { token, vault };
};

export default completeFixture;
