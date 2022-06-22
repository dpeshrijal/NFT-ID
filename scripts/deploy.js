
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("IdNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("NFT Contract is deployed to: ", nftContract.address);

    let txn = await nftContract.makeIdNFT("Deepesh Rijal", "20th June 2022", "deepeshrijal@gmail.com");
    await txn.wait();
    console.log("Your NFT ID has been minted!");

}

const runMain = async () => {
    try {
        await main();
        process.exit(0)
    }
    catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();

