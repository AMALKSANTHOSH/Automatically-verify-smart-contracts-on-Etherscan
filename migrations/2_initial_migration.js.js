module.exports = async function(deployer) {
  const AMAL = artifacts.require("AMAL");

  await deployer.deploy(AMAL);
  const contract = await AMAL.deployed();

  console.log("Contract address:", contract.address)
};