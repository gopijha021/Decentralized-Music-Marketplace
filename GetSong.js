import React, { useState } from 'react';
import Web3 from 'web3';
import DecentralizedMusicMarketplace from '../artifacts/DecentralizedMusicMarketplace.json';

const PurchaseSong = () => {
    const [songId, setSongId] = useState('');
    const [account, setAccount] = useState('');

    const purchase = async () => {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const contractAddress = DecentralizedMusicMarketplace.networks[networkId].address;
        const contract = new web3.eth.Contract(DecentralizedMusicMarketplace.abi, contractAddress);

        const song = await contract.methods.songs(songId).call();
        await contract.methods.purchaseSong(songId).send({ from: account, value: song.price });
        alert('Song purchased successfully!');
    };

    return (
        <div>
            <h2>Purchase Song</h2>
            <input type="text" placeholder="Your Ethereum Address" onChange={(e) => setAccount(e.target.value)} />
            <input type="number" placeholder="Song ID" onChange={(e) => setSongId(e.target.value)} />
            <button onClick={purchase}>Purchase</button>
        </div>
    );
};

export default PurchaseSong;
