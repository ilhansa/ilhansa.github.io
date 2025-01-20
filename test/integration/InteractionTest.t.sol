// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionTest is Test {
    
    FundMe fundMe;
    address USER = makeAddr("user"); // make an address and assigns it to USER
    uint256 STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000
    uint256 constant GAS_PRICE = 1;

    function setUp() external { 
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER,STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // fund arrange
        FundFundMe fundFundMe = new FundFundMe();
        // fund act
        vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe)); // fund
        // fund assert
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER); // check USER is registered as a funder

        // withdraw arrange
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        // withdraw act
        vm.prank(msg.sender);
        withdrawFundMe.withdrawFundMe(address(fundMe));
        // withdraw assert
        assertEq(address(fundMe).balance, 0); //c check funds were withdrawn 
    }
}