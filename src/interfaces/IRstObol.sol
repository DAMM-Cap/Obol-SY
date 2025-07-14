// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IRstObol {
    function sharesForStake(uint256 _amount) external view returns (uint256);
    function SHARE_SCALE_FACTOR() external view returns (uint256);
}
