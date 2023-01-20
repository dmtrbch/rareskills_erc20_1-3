// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./3_MyToken.sol";

contract Vendor is Ownable {
    /// @notice Defines the converstion rate for the MTK token
    /// @dev 1 ETH = 10000 MTK
    uint256 public constant TOKENS_PER_ETH = 10000;

    MyToken myToken;

    event BuyTokens(address buyer, uint256 amountOfTokens, uint256 amountOfETH);

    /**
     * @dev Passes the value for the {tokenAddress} parameters, that is the address of the MTK token
     */
    constructor(address tokenAddress) {
        myToken = MyToken(tokenAddress);
    }

    /**
     * @notice Vendor contract will store all the supply of the MTK token, and its' use wiil be to sell the tokens to users that want to buy them 
     * @dev By calling this function, the mint function of the MTK token is called, and we set the initial supply of the token
     * All of the token supply will belong to the address of the Vendor contract
     */
    function mintTokens()
        external
        onlyOwner
    {
        myToken.mint();
    }

    /**
     * @notice Users are able to call this function to buy the MTK token from the Vendor contract
     * @dev this is a payable function that accepts ETH, and sends to corresponding amount of MTK tokens to the `msg.sender`
     */
    function buyTokens()
        external
        payable
    {
        myToken.transfer(msg.sender, msg.value*TOKENS_PER_ETH);
        emit BuyTokens(msg.sender, msg.value, msg.value*TOKENS_PER_ETH);
    }
}