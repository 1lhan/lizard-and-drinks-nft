// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LizardsAndDrinks is ERC721Enumerable, Ownable{
    uint256 public maxSupply = 4;
    uint256 public price = 1000000000000000; // 0.001 ether
    string public baseURI;

    constructor(string memory baseURI_) ERC721("Lizards And Drinks", "LAD") Ownable(msg.sender){
        baseURI = baseURI_;
    }

    function mint(uint256 _amount) public payable{
        require(totalSupply() + _amount <= maxSupply, "Exceeds maximum supply");
        require(_amount == 1, "Only 1 nft can mint at a time");
        require(msg.value >= price, "Mint price value is not correct");

        for(uint256 i = 0; i < _amount; i++){
            _safeMint(msg.sender, totalSupply() + i);
        }
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function _baseURI() internal view override returns (string memory){
        return baseURI;
    }
}