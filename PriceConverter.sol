// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Libraries can't have any state variables and also can't send ether
// and all the functions in a library are gonna be internal

library PriceConverter {

    function getPrice() internal view returns (uint256) {
        // ABI
        // Rinkeby ETH / USD contract adddress: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        // https://docs.chain.link/docs/ethereum-addresses/ 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        // priceFeed give back ETH/USD rate value with 8 digits: 155000000000 == $1550 - 05.09.22
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH/USD rate with 18 digits: 1550_00000000 * 1e10 == 1550_00000000_0000000000 == $1550 - 05.09.22
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        // ETH / USD price: 1550_00000000_0000000000 == $1550 - 05.09.22
        // 1_00000000_0000000000 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // The actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

}