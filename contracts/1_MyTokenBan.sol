// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ERC20 Token with Sanctions
/// @author Dimitar Bochvaroski
/// @notice The owner of the contract is able to ban an address of choice
contract MyTokenBan is ERC20Capped, Ownable {
    uint256 constant private MAX_SUPPLY = 100_000_000*10**18;

    /// @notice Defines the list where banned addresses will be stored
    mapping(address => bool) public bannedAddresses;

    modifier notBanned(address _address) {
        require(bannedAddresses[_address] == false, "ERC20: sender or receiver address has been banned and is not able to send or receive tokens, neither to approve or be approved for transfers!");
        _;
    }

    /**
     * @dev Passes the values for the {name} and {symbol} parameters, required for
     * the ERC20 token implementation from OpenZeppelin.
     *
     * Makes use of the ERC20Capped contract from OpenZeppelin to set the maximum supply of the tokens
     */
    constructor() ERC20("MyTokenBan", "MTKB") ERC20Capped(MAX_SUPPLY) {}

    /** @dev Creates `amount` tokens and assigns them to `to`, increasing
     * the total supply.
     *
     * In addition to the default mint function from ERC20, it checks
     * if the address that the tokens should be assigned to is banned
     *
     * In case the address is banned the minting will fail
     */
    function mint(address to, uint256 amount) 
        public 
        onlyOwner
        notBanned(to)
    {
        _mint(to, amount);
    }

    /**
     * @dev Overrides the default _transfer function that
     * moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * In addition to the default _transfer function from ERC20, it checks
     * if the sender or the receiver address is banned
     *
     * In case one of the addresses is banned the transfer will fail
     */
    function _transfer(address from, address to, uint256 amount)
        internal
        override
        notBanned(from)
        notBanned(to)
    {
        super._transfer(from, to, amount);
    }

    /**
     * @dev Overrides the default _approve function that sets `amount` as the allowance of `spender` over the `owner` s tokens.
     * sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * In addition to the default _approve function from ERC20, it checks
     * if the owner or the spender address is banned
     *
     * In case one of the addresses is banned the approval will fail
     */
    function _approve(address owner, address spender, uint256 amount)
        internal
        override
        notBanned(owner)
        notBanned(spender)
    {
        super._approve(owner, spender, amount);
    }

    /**
     * @notice Owner of the contract is capable of banning an address of choice
     * @dev given an {addressToBan}, sets the {bannedAddresses} mapping of the {addressToBan} to true.
     *
     * @param addressToBan The address for baning
     */
    function banAddress(address addressToBan)
        external
        onlyOwner 
    {
        bannedAddresses[addressToBan] = true;
    }
}