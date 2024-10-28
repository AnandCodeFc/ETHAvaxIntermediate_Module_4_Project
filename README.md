# Module 4 Building On Avalanche 

## Project Overview

The **GameCloneToken** is an ERC20 token smart contract specifically designed for the Degen Gaming ecosystem. This contract allows players to mint, transfer, and redeem tokens for in-game items, thereby enhancing user engagement and interaction within the game. The contract is designed to be deployed on the Avalanche Fuji test network, utilizing the capabilities of smart contracts to facilitate seamless transactions.

## Table of Contents

1. [Features](#features)
2. [Smart Contract Details](#smart-contract-details)
3. [Usage](#usage)
4. [Installation](#installation)
5. [Deployment on Avalanche Fuji](#deployment-on-avalanche-fuji)
6. [Example Interaction](#example-interaction)

## Features

- **Token Minting**: The contract owner can mint new tokens to reward players.
- **Token Transfer**: Players can transfer their tokens to others.
- **Item Redemption**: Tokens can be redeemed for in-game items, enhancing gameplay.
- **Balance Inquiry**: Players can check their token balances at any time.
- **Token Burning**: Players can burn tokens they no longer need, reducing the total supply.

## Smart Contract Details

### License

This project is licensed under the MIT License.

### Solidity Version

The contract is written in Solidity version `0.8.10`.

### Dependencies

The contract relies on the OpenZeppelin library for ERC20 implementation. Ensure the OpenZeppelin contracts are installed if you plan to use a local development environment:

```bash
npm install @openzeppelin/contracts
```

### Contract Structure

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameCloneToken is ERC20 {
    address public gameOwner;

    mapping(uint256 => string) public itemDescriptions;
    mapping(uint256 => uint256) public itemCosts;
    mapping(address => mapping(uint256 => bool)) public purchasedItems;
    mapping(address => uint256) public totalPurchasedItems;

    constructor() ERC20("Degen", "DGN") {
        gameOwner = msg.sender;
        _initializeStore(0, "sticker", 500);
        _initializeStore(1, "phone", 1000);
        _initializeStore(2, "laptop", 20000);
        _initializeStore(3, "servers", 25000);
    }

    modifier onlyOwner() {
        require(gameOwner == msg.sender, "Only Have Access To Execute this function!");
        _;
    }

    event Purchase(address indexed user, string item);

    function _initializeStore(uint256 itemId, string memory _itemDescription, uint256 _itemCost) internal {
        itemDescriptions[itemId] = _itemDescription;
        itemCosts[itemId] = _itemCost;
    }

    function addItem(uint256 itemId, string memory _itemDescription, uint256 _itemCost) public onlyOwner {
        _initializeStore(itemId, _itemDescription, _itemCost);
    }

    function mintTokens(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }

    function burnTokens(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function purchaseItem(uint256 itemId) public returns (string memory) {
        uint256 cost = itemCosts[itemId];
        require(balanceOf(msg.sender) >= cost, "Not enough tokens to purchase the item.");

        _burn(msg.sender, cost);
        purchasedItems[msg.sender][itemId] = true;
        totalPurchasedItems[msg.sender]++;
        emit Purchase(msg.sender, itemDescriptions[itemId]);

        return itemDescriptions[itemId];
    }

    function getTotalPurchasedItems(address user) public view returns (uint256) {
        return totalPurchasedItems[user];
    }
}
```

#### State Variables

- `address public gameOwner`: The address of the contract owner.
- `mapping(uint256 => string) public itemDescriptions`: Descriptions of purchasable items.
- `mapping(uint256 => uint256) public itemCosts`: Costs associated with each item.
- `mapping(address => mapping(uint256 => bool)) public purchasedItems`: Tracks items purchased by each player.
- `mapping(address => uint256) public totalPurchasedItems`: Total number of items purchased by each player.

#### Functions

- **addItem**: Allows the owner to add new items to the store.
- **mintTokens**: Enables the owner to mint new tokens.
- **burnTokens**: Allows users to burn their tokens.
- **purchaseItem**: Facilitates item purchases using tokens.
- **getTotalPurchasedItems**: Returns the total number of items a user has purchased.

## Usage

### Deploying the Contract

You can deploy the **GameCloneToken** contract using Remix IDE. Follow these steps:

1. **Open Remix IDE**: Navigate to [Remix IDE](https://remix.ethereum.org).
2. **Create a New File**: In the file explorer, create a new file named `GameCloneToken.sol`.
3. **Copy the Contract Code**: Paste the entire contract code into your new file.
4. **Compile the Contract**: 
   - Click on the "Solidity Compiler" tab.
   - Select the appropriate compiler version (0.8.10).
   - Click "Compile GameCloneToken.sol".

### Deployment on Avalanche Fuji

1. **Connect to Avalanche Fuji**: 
   - Switch to the "Deploy & Run Transactions" tab.
   - Select "Injected Web3" as the environment (ensure you have MetaMask set up to connect to Avalanche Fuji).
   - Make sure your MetaMask is configured to the Avalanche Fuji test network.

2. **Deploy the Contract**: 
   - Select the `GameCloneToken` contract from the dropdown.
   - Click "Deploy" and confirm the transaction in your wallet.

3. **Interact with the Contract**: After deployment, you can interact with the contract directly through Remix.

## Example Interaction

Here’s how to interact with the deployed contract using Remix:

1. **Mint Tokens**: 
   - Call the `mintTokens` function to mint new tokens (only accessible to the owner).
   
   ```solidity
   // Example: Minting 1000 tokens
   mintTokens(1000);
   ```

2. **Purchase an Item**:
   - Call `purchaseItem` with the desired item ID to purchase an item.

   ```solidity
   // Example: Purchasing item with ID 1
   purchaseItem(1);
   ```

3. **Check Total Purchased Items**:
   - Use `getTotalPurchasedItems` to see how many items a user has purchased.

   ```solidity
   // Example: Checking total items purchased by a user
   uint256 total = getTotalPurchasedItems(msg.sender);
   ```
