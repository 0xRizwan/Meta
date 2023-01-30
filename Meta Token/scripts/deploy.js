
const hre = require("hardhat");

async function main() {
  const MetaToken = await hre.ethers.getContractFactory("MetaToken");
  const metaToken = await MetaToken.deploy();

  await metaToken.deployed();

  console.log(`MetaToken address: ${metaToken.address}`);

  const mint = await metaToken.mint("0x9Ea3efa3F1145A46c4eEc34B5a995De570b8050b", "1000000000000000000000")
  await mint.wait();
  console.log("Tokens are minted successfully minted");
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
