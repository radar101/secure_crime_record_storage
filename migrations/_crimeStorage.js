const CrimeStorage = artifacts.require("CrimeStorage");

module.exports = function(deployer)	{
	deployer.deploy(CrimeStorage);
};