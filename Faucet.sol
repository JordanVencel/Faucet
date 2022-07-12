// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/// @title A Secure Faucet Contract
/// @author Jordan V Martinez
/// @notice A basic implementation of a secure faucet smart contract in solidity. 
/// @dev Functions written to optimize for security. 

contract Faucet {
    address contractOwner;
    uint256 public balance; 

    constructor() {
        contractOwner = msg.sender;
        balance = 0;
    }

    // Accept any incoming payment
    fallback() external payable {
        balance += msg.value;
        emit depositEvent(msg.sender, msg.value);
    }

    event withdrawalEvent(address indexed to, uint amount);
    event depositEvent(address indexed from, uint amount);

    // Withdraw function to send out ether to an address that asks 
    ///@param withdrawAmount signifies the amount of ether the recipient is requesting
    function withdraw(uint withdrawAmount) public {
        // Limit withdrawal amount
        require(withdrawAmount <= 0.1 ether, "You have requested too much ether. Please enter an amount less than 0.1 ether.");
        require (balance > 0.1 ether, "Insufficient faucet funds. Please try again later.");
         // Send the amount to the address that requested it
         payable(msg.sender).transfer(withdrawAmount);
         emit withdrawalEvent(msg.sender, withdrawAmount);
    }

    ///@dev self-destruct function that destroys the contract and sends the ether remaining in this contract to the address specified
    function destroyFaucet() public {
        require (msg.sender == contractOwner, "Only the creator of this contract can call this function!");
        selfdestruct(payable(contractOwner));
    }

}