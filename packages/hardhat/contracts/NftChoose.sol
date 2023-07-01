// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/*
    Jeftar Mascarenhas
    twitter: @jeftar
    github: jeftarmascarenhas
    site: jeftar.com.br
    youtube.com/@nftchoose
*/

/*
    Specs
    [x] Deve ser uma coleção de 3 itens com nome e symbol
    [x] Qualquer pessoa pode mintar apenas 1 NFT por endereço quando não estive pausado
    [x] Valor do NFT será 0.1 ether
    [x] Pode alterar uri apenas pelo owner
    [x] Pode alterar o valor do NFT apenas pelo owner
    [x] Pode pausar o contrato apenas pelo owner
    [x] Deve ser possível retirar os Ethers do contrato apenas apenas pelo owner apenas pelo owner
*/

interface INftChoose {
    error MaxSupplyExceeded();
    error MaxPerMint();
    error InsufficientFunds(uint);
    error MaxPerAddress(address);
}

contract NftChoose is ERC721A, Ownable, Pausable, INftChoose {
    uint256 private constant _MAX_SUPPLY = 3;
    uint256 private constant _MAX_PER_MINT = 1;
    uint256 public price = 0.1 ether;
    string private _uri = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";

    constructor(
    ) ERC721A("NFT Choose", "NFTChose")  {
    }

    function mint(uint quantity_) external payable {
        if (quantity_ > _MAX_PER_MINT) revert MaxPerMint();
        if (totalSupply() >= _MAX_SUPPLY) revert MaxSupplyExceeded();
        if (quantity_ * price >= msg.value) revert InsufficientFunds(msg.value);
        if (balanceOf(msg.sender) >= 1) revert MaxPerAddress(msg.sender);

        _safeMint(msg.sender, quantity_, "");
    }

    function _baseURI() internal view override returns (string memory) {
        return _uri;
    }

    function setURI(string calldata uri_) external onlyOwner {
        _uri = uri_;
    }
    
    function setPrice(uint price_) external onlyOwner {
        price = price_;
    }

    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override whenNotPaused  {
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}(""); 
        require(success, "withdraw failed");
    }

}