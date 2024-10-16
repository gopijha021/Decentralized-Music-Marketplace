import React, { useState } from 'react';
import Web3 from 'web3';
import DecentralizedMusicMarketplace from '../artifacts/DecentralizedMusicMarketplace.json';

const RegisterUser = () => {
    const [isArtist, setIsArtist] = useState(false);
    const [account, setAccount] = useState('');

    const register = async () => {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const contractAddress = DecentralizedMusicMarketplace.networks[networkId].address;
        const contract = new web3.eth.Contract(DecentralizedMusicMarketplace.abi, contractAddress);

        await contract.methods.registerUser(isArtist).send({ from: account });
        alert('User registered successfully!');
    };

    return (
        <div>
            <h2>Register User</h2>
            <input type="text" placeholder="Your Ethereum Address" onChange={(e) => setAccount(e.target.value)} />
            <label>
                <input type="checkbox" onChange={(e) => setIsArtist(e.target.checked)} /> I am an artist
            </label>
            <button onClick={register}>Register</button>
        </div>
    );
};

export default RegisterUser;
