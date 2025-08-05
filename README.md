# PendleObolSY

A Standardized Yield (SY) contract for integrating stOBOL and OBOL tokens with the Pendle protocol. This contract enables seamless interaction between The Obol Collective's liquid staking tokens and Pendle's yield-trading infrastructure.

## Development

This project uses Foundry for development.

### Prerequisites

- [Foundry](https://getfoundry.sh/)
- Solidity ^0.8.0

### Build

```bash
forge build
```

### Format

```bash
forge fmt
```

### Deploy

> Include `DEPLOYER_PK` in `.env` file at root before deployment.

```bash
forge script script/DeployPendleObolSY.s.sol --rpc-url <your_rpc_url>
```

## Security

### Audit

This contract has been audited by **WatchPug** to ensure security and reliability.

📋 **[View Audit Report](./audits/Obol-SY_Audit_Report_by_WatchPug.pdf)**

### Authorization

This contract was authorized and developed by **[DAMM Capital](https://dammcap.finance)**.

## License

This project is licensed under the GPL-3.0-or-later License.

## Support

For questions and support, please reach out to the DAMM Capital team or create an issue in this repository.
