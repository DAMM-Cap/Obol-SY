// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@forge-std/Script.sol";
import "@src/PendleObolSY.sol";

address constant OBOL = 0x0B010000b7624eb9B3DfBC279673C76E9D29D5F7;
address constant ST_OBOL = 0x6590cBBCCbE6B83eF3774Ef1904D86A7B02c2fCC;
address constant PENDLE_PAUSE_CONTROLLER = 0x2aD631F72fB16d91c4953A7f4260A97C2fE2f31e;

contract Deploy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PK");
        vm.startBroadcast(deployerPrivateKey);

        PendleObolSY pendleObolSY = new PendleObolSY("SY Obol Network", "SY-stOBOL", OBOL, ST_OBOL);
        pendleObolSY.transferOwnership(PENDLE_PAUSE_CONTROLLER, true, false);

        vm.stopBroadcast();

        console.log("PendleObolSY deployed at:", address(pendleObolSY));
    }
}
