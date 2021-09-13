async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account: ", deployer.address);

  console.log("Account balance: ", (await deployer.getBalance()).toString());

  const PetToken = await hre.ethers.getContractFactory("PetVote");
  const petToken = await PetToken.deploy();

  console.log("PetVote address: ", petToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
