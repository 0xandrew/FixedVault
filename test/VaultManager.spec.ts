/* eslint-disable node/no-missing-import */
import { ethers, waffle } from "hardhat";
import { Wallet, constants, BigNumber } from "ethers";
import { Fixture } from "ethereum-waffle";
import { expect } from "chai";

import { VaultManager, TestERC20 } from "../typechain";
import completeFixture from "./shared/completeFixture";

describe("VaultManager", () => {
  let wallets: Wallet[];
  let wallet: Wallet, other: Wallet;

  const vaultFixture: Fixture<{
    vault: VaultManager;
    token: TestERC20;
  }> = async (wallets, provider) => {
    const { token, vault } = await completeFixture(wallets, provider);

    // approve and fund the wallet
    await token.approve(vault.address, constants.MaxUint256);
    await token.connect(other).approve(vault.address, constants.MaxUint256);
    await token.transfer(
      other.address,
      BigNumber.from(1000000).mul(BigNumber.from(10).pow(18))
    );

    return { token, vault };
  };

  let vault: VaultManager;
  let token: TestERC20;

  let loadFixture: ReturnType<typeof waffle.createFixtureLoader>;

  before("create fixture loader", async () => {
    wallets = await (ethers as any).getSigners();
    [wallet, other] = wallets;

    loadFixture = waffle.createFixtureLoader(wallets);
  });

  beforeEach("load fixture", async () => {
    ({ token, vault } = await loadFixture(vaultFixture));
  });

  describe("#createDeposit", () => {
    it("fails if zero address", async () => {
      await expect(
        vault.createDeposit(
          {
            token: token.address,
            amount: 100,
            releaseTimestamp: 1677389895,
          },
          { from: constants.AddressZero }
        )
      ).to.be.reverted;
    });

    it("fails if release timestamp is too old", async () => {
      await expect(
        vault.createDeposit({
          token: token.address,
          amount: 100,
          releaseTimestamp: 1645853400,
        })
      ).to.be.reverted;
    });

    it("fails if cannot transfer", async () => {
      await token.approve(vault.address, 0);
      await expect(
        vault.createDeposit({
          token: token.address,
          amount: 100,
          releaseTimestamp: 1677389895,
        })
      ).to.be.revertedWith("ERC20: insufficient allowance");
    });
  });

  describe("#withdraw", () => {});
});
