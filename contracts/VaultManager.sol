// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IVaultManager.sol";


/// @title Vault Manager
/// @author 0xAndrew - https://github.com/0xandrew
/// @notice Locks ERC20 tokens for a specified amount of time
contract VaultManager is IVaultManager {
    using SafeERC20 for IERC20;

    // details about
    struct Deposit {
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

    /// @dev Deposits by user address
    mapping(address => Deposit) public _deposits;

    /// @inheritdoc IVaultManager
    function createDeposit(DepositParams calldata params) external {
        require(msg.sender != address(0), "VaultManager::createDeposit:IA");
        require(
            params.releaseTimestamp >= block.timestamp,
            "VaultManager::createDeposit:IT"
        );

        params.token.transferFrom(msg.sender, address(this), params.amount);

        Deposit memory _deposit = Deposit(
            msg.sender,
            params.token,
            params.amount,
            params.releaseTimestamp,
            false
        );

        _deposits[msg.sender] = _deposit;

        event DepositCreated(msg.sender, params.token, params.amount, params.releaseTimestamp); 
    }
}
