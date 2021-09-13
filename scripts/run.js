async function main() {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({ value: hre.ethers.utils.parseEther("0.1")});
  await waveContract.deployed();
  
  console.log("Contract was deployed to: ", waveContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance: ", hre.ethers.utils.formatEther(contractBalance));

  let waveTxn = await waveContract.wave("A message! #1");
  await waveTxn.wait(); // wait for it to be mined!

  waveTxn = await waveContract.wave("A message! #2");
  await waveTxn.wait(); // wait for it to be mined!

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance: ", hre.ethers.utils.formatEther(contractBalance));

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  console.log("-----------------------")
  console.log("----------PET----------");
  console.log("-----------------------");

  const petContractFactory = await hre.ethers.getContractFactory("PetVote");
  const petContract = await petContractFactory.deploy();
  await petContract.deployed();

  console.log("Contract was deployed to: ", petContract.address);

  // Check if the options were properly initialized
  let options = await petContract.getOptions();
  console.log("Options: ", options);
  
  let voteTxn = await petContract.vote("Dogs", "They are good boys!");
  await voteTxn.wait(); // wait for it to be mined

  let voteHistory = await petContract.getVoteHistory();
  console.log(voteHistory);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
