// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrimeStorage {
    struct CrimeCase {
        uint256 caseNumber;
        uint256 numberOfImages;
        mapping(uint256 => string) description;
        mapping(uint256 => string) images; // Mapping from image ID to IPFS hash
    }

    mapping(uint256 => CrimeCase) public cases; // Mapping from case number to CrimeCase struct
    mapping(uint256 => string[]) public caseImageHashes;
    event ImageUploaded(
        uint256 caseNumber,
        string description,
        string ipfsHash
    );

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
        uint256 caseNumber,
        uint256 imageId
    ) public view returns (string memory) {
        return cases[caseNumber].images[imageId];
    }
}
