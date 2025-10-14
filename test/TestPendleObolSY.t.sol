import {SYTest} from "pendle-sy-tests/common/SYTest.t.sol";
import {PendleObolSY} from "./PendleObolSY.flat.sol";
import {IStandardizedYield} from "pendle-sy/interfaces/IStandardizedYield.sol";

address constant OBOL = 0x0B010000b7624eb9B3DfBC279673C76E9D29D5F7;
address constant WST_OBOL = 0x33e4A7D15de9923C680542CB10d76ea4868123fc;

contract TestPendleObolSY is SYTest {
    function setUpFork() internal override {
        // Set up your fork - specify the network and optionally block number
        vm.createSelectFork("ethereum");
        // or simply: vm.createSelectFork("ethereum");
    }

    function deploySY() internal override {
        vm.startPrank(deployer);

        // Deploy your SY implementation
        sy = IStandardizedYield(address(new PendleObolSY("SY Wrapped Staked Obol", "SY-wstOBOL", OBOL, WST_OBOL)));
        // sy = IStandardizedYield(
        //     deployTransparentProxy(logic, deployer, abi.encodeCall(PendleObolSY.initialize, (/* init args */)))
        // );

        vm.stopPrank();
    }

    function initializeSY() internal override {
        super.initializeSY();

        // Set the starting token for tests
        startToken = address(OBOL);

        // Any additional initialization logic
    }

    function hasFee() internal pure override returns (bool) {
        return false; // set to true if your protocol has mint/redemption fee
    }

    function getPreviewTestAllowedEps() internal pure virtual override returns (uint256) {
        // Specify the acceptable error margin (epsilon) for preview calculations,
        // accommodating minor rounding differences in protocols with fees.
        return 1e15; // e.g: 0.001%
    }

    function hasReward() internal pure override returns (bool) {
        return false; // set to true if protocol has reward
    }

    function addFakeRewards() internal override returns (bool[] memory) {
        // This function simulates the accrual of rewards over time for testing purposes.
        // It allows us to test the reward distribution logic without relying on real user activity.
        // By "fast-forwarding" the blockchain state, we can trigger reward calculations
        // as if a significant amount of time has passed.

        bool[] memory ret = new bool[](3);

        ret[0] = false;
        ret[1] = false;
        ret[2] = false;

        return ret;
    }
}
