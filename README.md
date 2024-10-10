**STEPS TO RUN AND DEPLOY SOLIDITY CONTRACT ON REMIX IDE** 





Step 1: Open Remix IDE

Go to Remix IDE.
Remix is a web-based tool, so no installations are required. It works directly in your browser.


step 2: Create and Set Up the Smart Contract

Create a New File:
In Remix, navigate to the contracts folder and click the "Create New File" button.
Name your file DecentralizedmusicMarketplace.sol.
Paste the Smart Contract Code:



  step 3: Compile the Contract

On the left-hand panel, click on the Solidity Compiler (second tab).
Select the appropriate compiler version (e.g., 0.8.27) that matches the Solidity version in the contract.
Click the Compile DecentralizedmusicMarketplace.sol button.


Step 5: Deploy the Contract


**USING 0 ETHER**


click on deploy and run transition.
then select Remix VM (cacum) from the environment section it will automatically have one address consist of some ether .
it will show some gas limit leave as it is ,now click on deploy it will deploy the contract WITH THE address like **0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47**

**USING ETHER**

download 
metamask: A web wallet for interacting with Ethereum and other blockchains.
Rinkeby Test Ether: You need some test Ether on the Rinkeby network. You can get it from Rinkeby Faucet.

 create an account on metamask  ,make sure that you have some ether in your wallet .

 click on Wallet connect option from environment section ,now it will connect your metamask account with remix ide .
 click on deploy option now this will take you to the metamask account and there you have to pay some ether inorder to deploy this contract .
 now the smart contract is deployed you can see it in rinkeby .


  **Test User Registration as Listener**
Step 1: Call registerUser

In the Deployed Contracts section, find your deployed contract.
Open the registerUser function.
For _isArtist, enter false (since this will register as a listener).
Click transact to execute the registration.


Step 2: Register as an Artist

Switch to another wallet account in Remix.
Call the registerUser function with _isArtist set to true to register as an artist.
Verify the registration as in the previous step (use the artist's address).

 **Test Song Upload (Artist Only)**

 
While using the artist's wallet account, call the uploadSong function with appropriate parameters:
_title: The name of the song (e.g., "Song A").
_price: The price of the song in Wei (e.g., 1000000000000000000 for 1 Ether).
_songHash: A hash of the song (you can generate a random hash for testing, e.g., 0x123456...).
Verify the song upload by calling the songs function with songId = 1. It should return the song details.

**Test Donation to Artist**


While still using the listener's account, call the donateToArtist function:
_artist: The artist's address.
Value: The amount of Ether you want to donate.
Verify the donation by checking the artist's balance in the Remix IDE's "Accounts" section (the balance should increase by the donation amount).


**Test Song Purchase (Listener Only)**


Switch back to the listener's account.
Ensure you have enough Ether to purchase the song. Call the purchaseSong function with:
_songId: The ID of the song you want to purchase (e.g., 1).
Value (in Wei): The exact price of the song (set in the uploadSong function).
Verify the purchase by checking the songPurchased mapping with the listener's address and songId. It should return true.


**Test Getting Song Details**


Call the getSong function with a songId (e.g., 1).
Verify the returned song details (title, price, artist, and songHash) match the uploaded song.



 BY USING HARDHAT OR TRUFFLE 

 you can also deployed it using hardhat or truffle 
 





