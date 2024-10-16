import React, { useState } from 'react';
import Web3 from 'web3';
import DecentralizedMusicMarketplace from '../artifacts/DecentralizedMusicMarketplace.json';

const DonateToArtist = () => {
    const [artistAddress, setArtistAddress] = useState('');
    const [amount, setAmount] = useState('');
    const [account, setAccount] = useState('');

    const donate = async () => {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const contractAddress = DecentralizedMusicMarketplace.networks[networkId].address;
        const contract = new web3.eth.Contract(DecentralizedMusicMarketplace.abi, contractAddress);

        await contract.methods.donateToArtist(artistAddress).send({ from: account, value: Web3.utils.toWei(amount, 'ether') });
        alert('Donation made successfully!');
    };

    return (
        <div>
            <h2>Donate to Artist</h2>
            <input type="text" placeholder="Your Ethereum Address" onChange={(e) => setAccount(e.target.value)} />
            <input type="text" placeholder="Artist's Ethereum Address" onChange={(e) => setArtistAddress(e.target.value)} />
            <input type="number" placeholder="Amount in Ether" onChange={(e) => setAmount(e.target.value)} />
            <button onClick={donate}>Donate</button>
        </div>
    );
};

export default DonateToArtist;
