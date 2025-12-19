// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    uint256 private s_tokenCounter;

    mapping(uint256 => Mood) s_tokenIdToMood;

    enum Mood {
        HAPPY,
        SAD
    }

    constructor(
        string memory sadSvgUri,
        string memory happySvgUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgUri;
        s_sadSvgImageUri = sadSvgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name:"',
                                name(),
                                '", description: "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": ',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }else{
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }
}
