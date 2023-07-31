//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG =
        "https://ipfs.io/ipfs/QmboeX5jgE6uWgZTFWPw8KHWkegi8MVdWDeXDZspryp7CQ?filename=pug.txt";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        //cant compare strings (arrays of bytes cant be compared)
        //so we convert them to bytes32, hash them, compare the hashes
        bytes32 expectedNameBytes32 = keccak256(abi.encodePacked(expectedName));
        bytes32 actualNameBytes32 = keccak256(abi.encodePacked(actualName));
        assert(expectedNameBytes32 == actualNameBytes32);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }
}
