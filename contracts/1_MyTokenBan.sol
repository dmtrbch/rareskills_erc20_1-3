// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenBan is ERC20Capped, Ownable {
    uint256 constant public MAX_SUPPLY = 100_000_000;

    mapping(address => bool) public bannedAddresses;

    modifier notBanned(address _address) {
        require(bannedAddresses[_address] == false, "Recipient or Receiver address has been banned and is not able to send or receive tokens, neither to approve or be approved for transfers!");
        _;
    }

    constructor() ERC20("MyTokenBan", "MTKB") ERC20Capped(MAX_SUPPLY) {}

    function mint(address to, uint256 amount) public 
        onlyOwner
        notBanned(to)
    {
        _mint(to, amount);
    }

    function banAddress(address addressToBan) external onlyOwner {
        bannedAddresses[addressToBan] = true;
    }

    function _transfer(address from, address to, uint256 amount)
        internal
        virtual
        override
        notBanned(from)
        notBanned(to)
    {
        super._transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount)
        internal
        virtual
        override
        notBanned(owner)
        notBanned(spender)
    {
        super._approve(owner, spender, amount);
    }
}