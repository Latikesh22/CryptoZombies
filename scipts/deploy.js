async function main() {

  const ZombieOwnership = await ethers.getContractFactory("ZombieOwnership");
  const zombieContract = await ZombieOwnership.deploy();

  await zombieContract.deployed();

  console.log("zombie contract deployed to:", zombieContract.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});