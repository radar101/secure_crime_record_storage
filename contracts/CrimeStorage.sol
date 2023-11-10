// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract CrimeStorage {

    struct CrimeCase {
        uint256 caseNumber;
        uint256 numberOfImages;
        mapping(uint256 => string) description;
        mapping(uint256 => string) images; 
    }

    mapping(uint256 => CrimeCase) public cases; 
    mapping(uint256 => string[]) public caseImageHashes;
    event ImageUploaded(
        uint256 caseNumber,
        string description,
        string ipfsHash
    );

    constructor() public {
        cases[0].caseNumber = 1;
        cases[0].numberOfImages = 1;
        cases[0].description[0] = "Dummy Case Description";
        cases[0].images[0] = "dummy_ipfs_hash_123";
        caseImageHashes[0].push("dummy_ipfs_hash_123");
        emit ImageUploaded(1, "Dummy Case Description", "dummy_ipfs_hash_123");
    }

    // Function to upload an image to IPFS and store the hash on the blockchain
    function uploadImage(
        uint256 caseNumber,
        string calldata description,
        string calldata ipfsHash
    ) external {
        cases[caseNumber].description[
            cases[caseNumber].numberOfImages
        ] = description;
        cases[caseNumber].images[cases[caseNumber].numberOfImages] = ipfsHash;
        caseImageHashes[caseNumber].push(ipfsHash);
        cases[caseNumber].numberOfImages++;
        emit ImageUploaded(caseNumber, description, ipfsHash);
    }

    function getImageHash(
        uint256 caseNumber
    ) public view returns (string[] memory) {
        return caseImageHashes[caseNumber];
    }
}
