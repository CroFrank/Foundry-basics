// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
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
        assertEq(fundMe.getOwner(), msg.sender);
    }
    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 0);
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
    function testWithdrawSingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }
    function testWithdrawMultipleFunders() public {
        uint160 numberOfFunders = 3;

        for (uint160 i = 1; i <= numberOfFunders; i++) {
            hoax(address(i), 1e18);
            fundMe.fund{value: 2e17}();
        }
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assert(endingFundMeBalance == 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testCheaperWithdrawMultipleFunders() public {
        uint160 numberOfFunders = 3;

        for (uint160 i = 1; i <= numberOfFunders; i++) {
            hoax(address(i), 1e18);
            fundMe.fund{value: 2e17}();
        }
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;

        assert(endingFundMeBalance == 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }
}
