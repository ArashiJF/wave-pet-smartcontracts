# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
# Set the environment

To deploy you need to add a .env file in the root of the project with the following vars:

- RINKEBY_URL - This is the rinkeby URL where the app is hosted, in this case Im using the Alchemy platform and pointing to it
- ACCOUNT - This is your private account key, KEEP THIS SECURE, DO NOT COMMIT DO NOT SAVE SOMEWHERE PUBLIC

