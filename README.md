# ENS contracts — security review workspace

This repository holds **Ethereum Name Service (ENS) contract sources**, local review notes, and **test harnesses** used for security research.

It is intended for **defensive analysis**, reproducible builds, and **responsible disclosure** workflows—not for deploying anything on mainnet without review.

## Layout

- **`contracts/`** — Per-contract source trees (metadata, ABI, Solidity) used for static review and tests.
- **`test/`** — Foundry tests and scenarios used during analysis.
- **`script/`** — Deployment and fork-testing scripts (require explicit RPC / keys via environment variables).

Upstream protocol contracts remain the authoritative source; this tree is a working copy for review.

## Ethics & safety

- Do **not** use this repo to harm users or the ENS protocol.
- Report serious issues through appropriate **coordinated disclosure** channels.
- Scripts that touch networks require **`DEPLOYER_PRIVATE_KEY`**, **`MAINNET_RPC_URL`**, and similar variables—**never commit secrets**.

## Build

Requires [Foundry](https://book.getfoundry.sh/). From the repo root:

```bash
forge build
```

## License / notices

Contract sources may follow their original licenses (see files under `contracts/`). Original ENS work belongs to the ENS DAO and contributors.
