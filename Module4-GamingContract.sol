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
    event TokenTransfer(address indexed from, address indexed to, uint256 amount);

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

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(to != address(0), "Cannot transfer to the zero address");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");

        bool success = super.transfer(to, amount);
        if (success) {
            emit TokenTransfer(msg.sender, to, amount);
        }
        
        return success;
    }

    function getTotalPurchasedItems(address user) public view returns (uint256) {
        return totalPurchasedItems[user];
    }
}
