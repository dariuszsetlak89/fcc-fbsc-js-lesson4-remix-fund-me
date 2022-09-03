// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Libraries can't have any state variables and also can't send ether
// and all the functions in a library are gonna be internal

library PriceConverter {

    function getPrice() internal view returns (uint256) {
        // ABI
        // Goerli ETH / USD contract adddress: 	0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // https://docs.chain.link/docs/ethereum-addresses/ 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // priceFeed give back ETH/USD rate value with 8 digits: 156000000000 == $1560 - 04.09.22
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH/USD rate with 18 digits: 1560_00000000 * 1e10 == 1560_00000000_0000000000 == $1560 - 04.09.22
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        // ETH / USD price: 1560_00000000_0000000000 == $1560 - 04.09.22
        // 1_00000000_0000000000 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // The actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

}