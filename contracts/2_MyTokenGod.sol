// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ERC20 Token with God Mode
/// @author Dimitar Bochvaroski
/// @notice The owner of the contract has allowance to spend the MTKG tokens of any address
contract MyTokenGod is ERC20Capped, Ownable {
    uint256 constant private MAX_SUPPLY = 100_000_000*10**18;

    /**
     * @dev Passes the values for the {name} and {symbol} parameters, required for
     * the ERC20 token implementation from OpenZeppelin.
     *
     * Makes use of the ERC20Capped contract from OpenZeppelin to set the maximum supply of the tokens
     */
    constructor() ERC20("MyTokenGod", "MTKG") ERC20Capped(MAX_SUPPLY) {}

    /** @dev Creates `amount` tokens and assigns them to `to`, increasing
     * the total supply.
     *
     * In addition to the default mint function from ERC20, it approves
     * the owner of the contract to be able to spend the tokens that are minted to the `to` address
     */
    function mint(address to, uint256 amount)
        public
        onlyOwner
    {   
        _approve(to, msg.sender, amount);
        _mint(to, amount);
    }

    /**
     * @dev Overrides the default _transfer function that
     * moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * In addition to the default _transfer function from ERC20, it approves
     * the owner of the contract to be able to spend the tokens that
     * `from` and `to` addresses have in possetion
     */
    function _transfer(address from, address to, uint256 amount)
        internal
        override
    {   
        uint256 senderTokenBalanceTotal = balanceOf(from) - amount;
        uint256 receiverTokenBalanceTotal = balanceOf(to) + amount;
        _approve(from, owner(), senderTokenBalanceTotal);
        _approve(to, owner(), receiverTokenBalanceTotal);
        super._transfer(from, to, amount);
    }
}