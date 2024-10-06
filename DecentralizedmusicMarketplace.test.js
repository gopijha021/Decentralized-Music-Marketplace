const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DecentralizedMusicMarketplace", function () {
  let marketplace, owner, artist, listener;

  beforeEach(async () => {
    [owner, artist, listener] = await ethers.getSigners();

    const Marketplace = await ethers.getContractFactory("DecentralizedMusicMarketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();
  });

  it("Should allow user registration as an artist", async () => {
    await marketplace.connect(artist).registerUser(true);
    const user = await marketplace.users(artist.address);
    expect(user.isArtist).to.equal(true);
    expect(user.isRegistered).to.equal(true);
  });

  it("Should allow user registration as a listener", async () => {
    await marketplace.connect(listener).registerUser(false);
    const user = await marketplace.users(listener.address);
    expect(user.isArtist).to.equal(false);
    expect(user.isRegistered).to.equal(true);
  });

  it("Should allow an artist to upload a song", async () => {
    await marketplace.connect(artist).registerUser(true);
    await marketplace.connect(artist).uploadSong("Test Song", ethers.utils.parseEther("1"), ethers.utils.keccak256(ethers.utils.toUtf8Bytes("song")));
    
    const song = await marketplace.songs(1);
    expect(song.title).to.equal("Test Song");
    expect(song.price).to.equal(ethers.utils.parseEther("1"));
  });

  it("Should allow listener to purchase a song", async () => {
    await marketplace.connect(artist).registerUser(true);
    await marketplace.connect(listener).registerUser(false);

    await marketplace.connect(artist).uploadSong("Test Song", ethers.utils.parseEther("1"), ethers.utils.keccak256(ethers.utils.toUtf8Bytes("song")));
    
    await marketplace.connect(listener).purchaseSong(1, { value: ethers.utils.parseEther("1") });
    const hasPurchased = await marketplace.songPurchased(listener.address, 1);
    expect(hasPurchased).to.equal(true);
  });

  it("Should allow listener to donate to an artist", async () => {
    await marketplace.connect(artist).registerUser(true);
    await marketplace.connect(listener).registerUser(false);
    
    const donationAmount = ethers.utils.parseEther("0.5");
    await marketplace.connect(listener).donateToArtist(artist.address, { value: donationAmount });
    // Check artist's balance after donation
  });
});
