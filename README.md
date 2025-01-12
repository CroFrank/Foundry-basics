## FundMe
This is a smart contract, written in foundry framework, that enables users to send funds to a smart contract. The project leverages Chainlink Price Feeds to fetch real-time price data and facilitates accurate conversions. Only the owner of the contract has the ability to withdraw the accumulated funds.

This project was built under the guidance of [Patrick Collinst](https://github.com/patrickalphac) from [Cyfrin](https://www.cyfrin.io/)and includes comprehensive testing to ensure reliability and correctness.

## Features
Fund Contract: Users can send ETH to the smart contract.
Price Conversion: Chainlink Price Feeds are used to convert ETH to USD, ensuring users meet the minimum funding threshold.
Withdraw Funds: Only the contract owner can withdraw the accumulated funds.
Testing: Comprehensive tests are implemented to verify contract functionality.

## Technologies Used
-Solidity: Smart contract development.
-Chainlink: For fetching real-time price feeds.
-Foundry: Development environment for compiling, testing, and deploying contracts.
-MetaMask: Browser wallet for transactions.
-Anvil: Local Foundry testing network for rapid development.

## Foundry Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Learning and Guidance
This project was created as part of my learning journey with Patrick Collins and Cyfrin. The course emphasized best practices in Solidity, secure smart contract development, and the use of Chainlink oracles.

## Acknowledgments
Special thanks to:

Patrick Collins for the comprehensive lessons.
Chainlink for providing reliable price data.
