// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@pendle/core/StandardizedYield/SYBase.sol";
import "./interfaces/IStObol.sol";
import "./interfaces/IRstObol.sol";

/// @title PendleObolSY
/// @author [DAMM Capital](https://dammcap.finance)
/// @notice The rebasing variant of the liquid staked OBOL token, i.e. rstOBOL. This contract works
/// in tandem with the fixed balance staked OBOL token, i.e. stOBOL. While the fixed balance stOBOL
/// is the canonical liquid representation of staked OBOL, the two use the same underlying
/// accounting system, which is located in this contract. Unlike stOBOL, which maintains a fixed
/// balance that becomes worth more underlying OBOL tokens overtime, rstOBOL has a dynamic balance
/// function that update automatically. As such, 1 rstOBOL is always equivalent to 1 underlying
/// OBOL.
/// @notice The fixed balance variant of the liquid staked OBOL token, i.e. stOBOL. This contract
/// works in tandem with the rebasing staked OBOL token, i.e. rstOBOL. While this contract is the
/// canonical liquid representation of staked OBOL, the two use the same underlying accounting
/// system, which is located in the rebasing token contract. This contract is deployed by, and
/// interacts with, the rstOBOL contract. Unlike rstOBOL, this contract maintains a fixed balance
/// for stakers, even as rewards are distributed. While the user's balance of stOBOL stays fixed,
/// the number of underlying OBOL tokens they have a claim to grows over time. As such, 1 stOBOL
/// will be worth more and more OBOL over time.
contract PendleObolSY is SYBase {
    address public immutable obol;
    address public immutable stObol;
    address public immutable rstObol;
    uint256 public immutable shareScaleFactor;

    constructor(string memory _name, string memory _symbol, address _obol, address _stObol)
        SYBase(_name, _symbol, _stObol)
    {
        obol = _obol;
        stObol = _stObol;
        rstObol = IStObol(_stObol).LST();

        _safeApproveInf(obol, stObol);
        _safeApproveInf(stObol, rstObol);

        shareScaleFactor = IRstObol(rstObol).SHARE_SCALE_FACTOR();
    }

    /*///////////////////////////////////////////////////////////////
                    DEPOSIT/REDEEM USING BASE TOKENS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev See {SYBase-_deposit}
     *
     * The underlying yield token is stObol. If the base token deposited is obol, the function wraps
     * it into stObol.
     * If the base token deposited is rstObol, the function unwraps it into stObol.
     *
     * The exchange rate of stObol to shares is 1:1
     */
    function _deposit(address tokenIn, uint256 amountDeposited)
        internal
        virtual
        override
        returns (uint256 amountSharesOut)
    {
        if (tokenIn == stObol) {
            amountSharesOut = amountDeposited;
        } else if (tokenIn == obol) {
            amountSharesOut = IStObol(stObol).stake(amountDeposited);
        } else {
            amountSharesOut = IRstObol(rstObol).unstake(amountDeposited);
        }
    }

    /**
     * @dev See {SYBase-_redeem}
     *
     * The shares are redeemed into the same amount of stObol. If `tokenOut` is rstObol, the function also
     * wraps said amount of stObol into rstObol for redemption.
     * Cannot redeem into obol because of *potential* latency of the unstaking process.
     */
    function _redeem(address receiver, address tokenOut, uint256 amountSharesToRedeem)
        internal
        virtual
        override
        returns (uint256 amountTokenOut)
    {
        if (tokenOut == stObol) {
            amountTokenOut = amountSharesToRedeem;
        } else if (tokenOut == rstObol) {
            amountTokenOut = IRstObol(rstObol).stake(amountSharesToRedeem);
        }
        _transferOut(tokenOut, receiver, amountTokenOut);
    }

    /**
     * @notice Calculates and updates the exchange rate of shares to underlying asset token
     * @dev It is the exchange rate of stObol to rstObol
     */
    function exchangeRate() public view virtual override returns (uint256) {
        return IRstObol(rstObol).sharesForStake(1 ether) / shareScaleFactor;
    }

    function _previewDeposit(address tokenIn, uint256 amountTokenToDeposit)
        internal
        view
        override
        returns (uint256 amountSharesOut)
    {
        if (tokenIn == stObol || tokenIn == obol) {
            amountSharesOut = amountTokenToDeposit;
        } else if (tokenIn == rstObol) {
            amountSharesOut = IRstObol(rstObol).sharesForStake(amountTokenToDeposit) / shareScaleFactor;
        }
    }

    function _previewRedeem(address tokenOut, uint256 amountSharesToRedeem)
        internal
        view
        override
        returns (uint256 amountTokenOut)
    {
        if (tokenOut == stObol) {
            amountTokenOut = amountSharesToRedeem;
        } else if (tokenOut == rstObol) {
            amountTokenOut = IRstObol(rstObol).stakeForShares(amountSharesToRedeem);
        }
    }

    function getTokensIn() public view virtual override returns (address[] memory res) {
        res = new address[](3);
        res[0] = obol;
        res[1] = stObol;
        res[2] = rstObol;
    }

    function getTokensOut() public view virtual override returns (address[] memory res) {
        res = new address[](2);
        res[0] = stObol;
        res[1] = rstObol;
    }

    function isValidTokenIn(address token) public view virtual override returns (bool) {
        return token == obol || token == stObol || token == rstObol;
    }

    function isValidTokenOut(address token) public view virtual override returns (bool) {
        return token == stObol || token == rstObol;
    }

    function assetInfo() external view returns (AssetType assetType, address assetAddress, uint8 assetDecimals) {
        return (AssetType.TOKEN, obol, IERC20Metadata(obol).decimals());
    }
}
