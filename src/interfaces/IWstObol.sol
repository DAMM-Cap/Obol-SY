// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

library Staker {
    type DepositIdentifier is uint256;
}

interface IWstObol {
    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC2612ExpiredSignature(uint256 deadline);
    error ERC2612InvalidSigner(address signer, address owner);
    error InvalidAccountNonce(address account, uint256 currentNonce);
    error InvalidShortString();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error StringTooLong(string str);
    error WrappedGovLst__InvalidAmount();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event DelegateeSet(address indexed oldDelegatee, address indexed newDelegatee);
    event EIP712DomainChanged();
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event UnwrapFixed(address indexed holder, uint256 lstAmount, uint256 wrappedAmount);
    event UnwrapRebasing(address indexed holder, uint256 lstAmount, uint256 wrappedAmount);
    event WrappedFixed(address indexed holder, uint256 fixedAmount, uint256 wrappedAmount);
    event WrappedRebasing(address indexed holder, uint256 rebasingAmount, uint256 wrappedAmount);
    event WrappedUnderlying(address indexed holder, uint256 underlyingAmount, uint256 wrappedAmount);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function FIXED_LST() external view returns (address);
    function LST() external view returns (address);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function delegatee() external view returns (address);
    function depositId() external view returns (Staker.DepositIdentifier);
    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        );
    function name() external view returns (string memory);
    function nonces(address owner) external view returns (uint256);
    function owner() external view returns (address);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;
    function previewUnwrapToFixed(uint256 _wrappedAmount) external view returns (uint256);
    function previewUnwrapToRebasing(uint256 _wrappedAmount) external view returns (uint256);
    function previewWrapRebasing(uint256 _stakeTokensToWrap) external view returns (uint256);
    function previewWrapUnderlying(uint256 _stakeTokensToWrap) external view returns (uint256);
    function renounceOwnership() external;
    function setDelegatee(address _newDelegatee) external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transferOwnership(address newOwner) external;
    function unwrapToFixed(uint256 _wrappedAmount) external returns (uint256 _fixedTokensUnwrapped);

    function unwrapToRebase(uint256 _wrappedAmount) external returns (uint256);
    function wrapFixed(uint256 _fixedTokensToWrap) external returns (uint256);
    function wrapRebasing(uint256 _lstAmountToWrap) external returns (uint256 _wrappedAmount);
    function wrapUnderlying(uint256 _stakeTokensToWrap) external returns (uint256);
}
