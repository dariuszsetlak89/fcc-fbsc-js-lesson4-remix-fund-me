// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMathTester {
    uint8 public bigNumber = 255;   // checked

    function add() public {
        // compiler version above 0.8.0 - check SafeMath by default
        // unchecked - doesn't check SafeMath for compilers above 0.7.6
        unchecked {bigNumber = bigNumber + 1;}  
    }

}