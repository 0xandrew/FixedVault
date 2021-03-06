// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
interface IVaultManager {
    /// @notice Emitted when deposit is made
    /// @param depositor Address of depositor
    /// @param token Address of ERC20 token
    /// @param amount Amount deposited
    /// @param releaseTimestamp release timestamp
    event DepositCreated(
        address depositor,
        address token,
        uint256 amount,
        uint256 releaseTimestamp
    );

    /// @notice Emitted when deposit is claimed
    /// @param depositor Address of depositor
    /// @param token Address of ERC20 token
    /// @param amount Amount deposited
    event DepositClaimed(
        address depositor,
        address token,
        uint256 amount
    );

    struct DepositParams {
        IERC20 token;
        uint256 amount;
        uint256 releaseTimestamp;
    }

    /// @notice Creates a time-locked deposit for an ERC20 token
    /// @param params The params necessary to create a deposit in vault, encoded as `MintParams` in calldata
    function createDeposit(DepositParams calldata params) external;

    /// @notice Withdraws tokens past release timestamp
    /// @param did Deposit id
    function withdraw(uint256 did) external;
}
