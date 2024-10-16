import React, { useState } from 'react';
import Web3 from 'web3';
import DecentralizedMusicMarketplace from '../artifacts/DecentralizedMusicMarketplace.json';

const UploadSong = () => {
    const [title, setTitle] = useState('');
    const [price, setPrice] = useState('');
    const [songHash, setSongHash] = useState('');
    const [account, setAccount] = useState('');

    const upload = async () => {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const contractAddress = DecentralizedMusicMarketplace.networks[networkId].address;
        const contract = new web3.eth.Contract(DecentralizedMusicMarketplace.abi, contractAddress);

        await contract.methods.uploadSong(title, Web3.utils.toWei(price, 'ether'), songHash).send({ from: account });
        alert('Song uploaded successfully!');
    };

    return (
        <div>
            <h2>Upload Song</h2>
            <input type="text" placeholder="Your Ethereum Address" onChange={(e) => setAccount(e.target.value)} />
            <input type="text" placeholder="Song Title" onChange={(e) => setTitle(e.target.value)} />
            <input type="number" placeholder="Price in Ether" onChange={(e) => setPrice(e.target.value)} />
            <input type="text" placeholder="Song Hash" onChange={(e) => setSongHash(e.target.value)} />
            <button onClick={upload}>Upload</button>
        </div>
    );
};

export default UploadSong;
