// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@pendle/core/StandardizedYield/v2/SYBaseV2.sol";
import "./interfaces/IRstObol.sol";
import "./interfaces/IWstObol.sol";

/// @title PendleObolSY
/// @author [DAMM Capital](https://dammcap.finance)
contract PendleObolSY is SYBaseV2 {
    using PMath for uint256;

    address public immutable obol;
    address public immutable rstObol;
    address public immutable wstObol;
    uint256 public immutable shareScaleFactor;

    constructor(string memory _name, string memory _symbol, address _obol, address _wstObol)
        SYBaseV2(_name, _symbol, _wstObol)
    {
        obol = _obol;
        wstObol = _wstObol;
        rstObol = IWstObol(_wstObol).LST();
        shareScaleFactor = IRstObol(rstObol).SHARE_SCALE_FACTOR();

        /// @dev this will allow obol to be wrapped
        _safeApproveInf(obol, wstObol);
    }

    /*///////////////////////////////////////////////////////////////
                    DEPOSIT/REDEEM USING BASE TOKENS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev See {SYBaseV2-_deposit}
     *
     */
    function _deposit(address tokenIn, uint256 amountDeposited)
        internal
        virtual
        override
        returns (uint256 amountSharesOut)
    {
        if (tokenIn == wstObol) {
            amountSharesOut = amountDeposited;
        } else if (tokenIn == obol) {
            amountSharesOut = IWstObol(wstObol).wrapUnderlying(amountDeposited);
        }
    }

    /**
     * @dev See {SYBaseV2-_redeem}
     *
     */
    function _redeem(address receiver, address tokenOut, uint256 amountSharesToRedeem)
        internal
        virtual
        override
        returns (uint256 amountTokenOut)
    {
        _transferOut(tokenOut, receiver, amountSharesToRedeem);
        return amountSharesToRedeem;
    }

    /**
     * @notice Calculates and updates the exchange rate of shares to underlying asset token
     * @dev this is the exchange rate of wstObol to obol, 1 rstobol = 1 obol ALWAYS
     */
    function exchangeRate() public view virtual override returns (uint256) {
        return IWstObol(wstObol).previewUnwrapToRebasing(1 ether);
    }

    /**
     * @dev See {SYBaseV2-_previewDeposit}
     */
    function _previewDeposit(address tokenIn, uint256 amountTokenToDeposit)
        internal
        view
        override
        returns (uint256 amountSharesOut)
    {
        if (tokenIn == obol) {
            return IWstObol(wstObol).previewWrapUnderlying(amountTokenToDeposit);
        } else {
            return amountTokenToDeposit;
        }
    }

    /**
     * @dev See {SYBaseV2-_previewRedeem}
     */
    function _previewRedeem(address tokenOut, uint256 amountSharesToRedeem)
        internal
        view
        override
        returns (uint256 amountTokenOut)
    {
        return amountSharesToRedeem;
    }

    /**
     * @dev See {SYBaseV2-getTokensIn}
     */
    function getTokensIn() public view virtual override returns (address[] memory res) {
        res = new address[](2);
        res[0] = obol;
        res[1] = wstObol;
    }

    /**
     * @dev See {SYBaseV2-getTokensOut}
     */
    function getTokensOut() public view virtual override returns (address[] memory res) {
        res = new address[](1);
        res[0] = wstObol;
    }

    /**
     * @dev See {SYBaseV2-isValidTokenIn}
     */
    function isValidTokenIn(address token) public view virtual override returns (bool) {
        return token == obol || token == wstObol;
    }

    /**
     * @dev See {SYBaseV2-isValidTokenOut}
     */
    function isValidTokenOut(address token) public view virtual override returns (bool) {
        return token == wstObol;
    }

    /**
     * @dev See {SYBaseV2-assetInfo}
     */
    function assetInfo() external view returns (AssetType assetType, address assetAddress, uint8 assetDecimals) {
        return (AssetType.TOKEN, obol, IERC20Metadata(obol).decimals());
    }
}
