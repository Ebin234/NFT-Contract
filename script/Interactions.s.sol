// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "src/MoodNft.sol";

contract MintBasicNft is Script {
    string public constant tokenUri =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("BasicNft",block.chainid);
        mintNftOnContract(mostRecentDeployment);
    }

    function mintNftOnContract(address mostRecentDeployment) public {
        vm.startBroadcast();
        BasicNft(mostRecentDeployment).mintNft(tokenUri);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script{
    function run() external{
        address mostRecentMoodNftDeployment = DevOpsTools.get_most_recent_deployment("MoodNft",block.chainid);
        mintMoodNftOnContract(mostRecentMoodNftDeployment);
    }

    function mintMoodNftOnContract(address recentDeployment) public {
        vm.startBroadcast();
        MoodNft(recentDeployment).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script{
    function run() external{
        address mostRecentMoodNftDeployment = DevOpsTools.get_most_recent_deployment("MoodNft",block.chainid);
        flipMoodNftOnContract(mostRecentMoodNftDeployment);
    }

    function flipMoodNftOnContract(address recentDeployment) public {
        vm.startBroadcast();
        MoodNft(recentDeployment).flipMood(0);
        vm.stopBroadcast();
    }
}
