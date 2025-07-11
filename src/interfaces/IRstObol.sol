// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IRstObol {
    function unstake(uint256 _amount) external returns (uint256);
    function stake(uint256 _amount) external returns (uint256);
    function sharesForStake(uint256 _amount) external view returns (uint256);
    function stakeForShares(uint256 _amount) external view returns (uint256);
    function SHARE_SCALE_FACTOR() external view returns (uint256);
}
