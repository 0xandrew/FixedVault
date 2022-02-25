// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IVaultManager.sol";

/// @title Vault Manager
/// @author 0xAndrew - https://github.com/0xandrew
/// @notice Locks ERC20 tokens for a specified amount of time
abstract contract VaultManager is IVaultManager {
    using SafeERC20 for IERC20;

    // deposit details
    struct DepositInfo {
        // deposit id
        uint256 did;
        // depositor address
        address depositor;
        // deposit token
        IERC20 token;
        // amount
        uint256 amount;
        // release timestamp
        uint256 releaseTimestamp;
        // claimed or not
        bool claimed;
    }

    /// @dev DepositInfo by deposit id
    mapping(uint256 => DepositInfo) public _depositInfo;

    /// @dev deposits counter
    uint256 private depositCount = 0;

    /// @inheritdoc IVaultManager
    function createDeposit(DepositParams calldata params) external override {
        require(msg.sender != address(0), "VaultManager::createDeposit:IA");
        require(
            params.releaseTimestamp >= block.timestamp,
            "VaultManager::createDeposit:IT"
        );

        params.token.safeTransferFrom(
            address(msg.sender),
            address(this),
            params.amount
        );

        DepositInfo memory _deposit = DepositInfo(
            depositCount,
            msg.sender,
            params.token,
            params.amount,
            params.releaseTimestamp,
            false
        );

        _depositInfo[_deposit.did] = _deposit;

        depositCount += 1;

        emit DepositCreated(
            msg.sender,
            address(params.token),
            params.amount,
            params.releaseTimestamp
        );
    }

    /// @inheritdoc IVaultManager
    function withdraw(uint256 _did) external override {
        require(_did < depositCount, "VaultManager::withdraw:ID");

        DepositInfo memory d = _depositInfo[_did];

        require(
            d.releaseTimestamp <= block.timestamp,
            "VaultManager::withdraw:IRT"
        );
        require(!d.claimed, "VaultManager::withdraw:AC");

        d.claimed = true;

        d.token.safeTransfer(d.depositor, d.amount);

        emit DepositClaimed(msg.sender, address(d.token), d.amount);
    }
}
