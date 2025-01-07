// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    function setUp() external {
        DeployFundMe deployedFundMe = new DeployFundMe();
        fundMe = deployedFundMe.run();
        vm.deal(USER, 10e18);
        vm.deal(USER2, 10e18);
    }
    function testDemo() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }
    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testSendNotEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: 1e8}();
    }

    function testSendEnoughEth() public {
        vm.prank(USER);
        fundMe.fund{value: 2e17}();
        uint256 amountfounded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountfounded, 2e17);
    }

    function testAddFunderToArray() public {
        vm.prank(USER);
        fundMe.fund{value: 2e17}();
        vm.prank(USER2);
        fundMe.fund{value: 2e17}();
        assertEq(fundMe.getFunder(0), USER);
        assertEq(fundMe.getFunder(1), USER2);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 2e17}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }
}
