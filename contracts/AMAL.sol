// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AMAL is ERC20 {
    constructor() ERC20("AMAL", "AML") {}
}