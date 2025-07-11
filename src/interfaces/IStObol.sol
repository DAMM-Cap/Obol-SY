// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IStObol {
    function LST() external view returns (address);
    function stake(uint256 _stakeTokens) external returns (uint256);
}
