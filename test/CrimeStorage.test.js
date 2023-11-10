const CrimeStorage = artifacts.require("./CrimeStorage");
const EVM_REVERT = "VM Exception while processing transaction: revert";

require("chai").use(require("chai-as-promised")).should();

contract("CrimeStorage", ([deployer]) => {
  const caseNumber = 1;
  const description = "fadsjkfdfadfa";
  const cid = "fdafkdjadkfer32r3";
  let crimeStorage;

  beforeEach(async () => {
    crimeStorage = await CrimeStorage.new();
  });

  describe("upload", () => {
    let result;

    beforeEach(async () => {
      result = await crimeStorage.uploadImage(caseNumber, description, cid, {
        from: deployer,
      });
    });

    it("emits an ImageUploaded event", async () => {
      const log = result.logs[0];
      log.event.should.equal("ImageUploaded");

      const event = log.args;
      event.caseNumber
        .toNumber()
        .should.equal(caseNumber, "caseNumber is correct");
      event.ipfsHash.should.equal(cid, "cid is correct");
    });

    it("checks the mapping after uploading", async () => {
      const uploadedImage = await crimeStorage.cases(caseNumber);
      const numberOfImages = uploadedImage.numberOfImages.toNumber();

      let isImageFound = false;
      for (let i = 0; i < numberOfImages; i++) {
        const imageHash = await crimeStorage.getImageHash(caseNumber);
        if (imageHash === cid) {
          isImageFound = true;
          break;
        }
      }
      
      assert.equal(
        isImageFound,
        true,
        "Image IPFS hash should be found in the uploaded images"
      );
    });
  });
});
