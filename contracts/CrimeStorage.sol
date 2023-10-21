// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 < 0.9.0;

contract CrimeStorage {
    struct CrimeCase {
        uint256 caseNumber;
        string description;
        uint256 numberOfImages;
        mapping(uint256 => string) images; // Mapping from image ID to IPFS hash
    }

    mapping(uint256 => CrimeCase) public cases; // Mapping from case number to CrimeCase struct

    event ImageUploaded(uint256 caseNumber, uint256 imageId, string ipfsHash);

    // Function to upload an image to IPFS and store the hash on the blockchain
    function uploadImage(uint256 caseNumber, string calldata description, string calldata ipfsHash) external {
        CrimeCase storage crimeCase = cases[caseNumber];
        crimeCase.caseNumber = caseNumber;
        crimeCase.description = description;
        crimeCase.images[crimeCase.numberOfImages] = ipfsHash;
        crimeCase.numberOfImages++;

        emit ImageUploaded(caseNumber, crimeCase.numberOfImages - 1, ipfsHash);
    }

    // Function to retrieve the IPFS hash of an image by case number and image ID
    function getImage(uint256 caseNumber, uint256 imageId) external view returns (string memory) {
        CrimeCase storage crimeCase = cases[caseNumber];
        require(imageId > crimeCase.numberOfImages, "Image not found");
        return crimeCase.images[imageId];
    }
}