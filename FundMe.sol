// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// 1. Set a minimum funding value in USD
// 2. Get funds from users
// 3. Withdraw funds

import "./PriceConverter.sol";


error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;  // 1 * 10 ** 18   // constant - safe gas
    
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;   // immutable - safe gas similar amount to constant, i naming convention

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!");  // 1e18 == 1 * 10 ** 18 == 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        // Reset the mapping
        /* starting index, ending index, step amount */
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // Reset the array
        funders = new address[](0);
        
        // Withdraw the funds
        // 1. transfer - automaticly reverts when the transfer fails
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);
        // 2. send - only revert transaction when fails, if we add require statement
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // 3. call - low level code (advanced), recomended for sending Ether
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

    modifier onlyOwner {
        //require(msg.sender == i_owner, "Sender is not owner!");   // Revert string message uses lots of gas
        if(msg.sender != i_owner) { revert NotOwner(); }    // Safe gas
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}