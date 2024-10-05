// SPDX-License-Identifier: MIT
// License identifier that specifies the code's license (MIT in this case).

pragma solidity ^0.8.0;
// Specifies the version of Solidity the code is written in (0.8.0 or higher).

contract DecentralizedMusicMarketplace {
// Defines a contract named DecentralizedMusicMarketplace, which contains the logic for the music marketplace.

    struct Song {
        uint256 id;
        string title;
        uint256 price;
        address payable artist;
        bytes32 songHash;
    }
    // A struct to define the attributes of a song: id, title, price, artist's address, and songHash (a unique identifier).

    struct User {
        bool isArtist;
        bool isRegistered;
    }
    // A struct to define the attributes of a user: whether they are an artist and if they are registered.

    uint256 public songCount = 0;
    // A state variable to track the number of songs in the marketplace (initially set to 0).

    mapping(uint256 => Song) public songs;
    // A mapping that stores Song structs, with song IDs as keys.

    mapping(address => User) public users;
    // A mapping that stores User structs, with Ethereum addresses as keys.

    mapping(address => mapping(uint256 => bool)) public songPurchased;
    // A nested mapping to track which songs a user has purchased (address => songId => true/false).

    event UserRegistered(address indexed user, bool isArtist);
    // An event emitted when a user registers, storing their address and role (artist or listener).

    event SongUploaded(uint256 indexed songId, string title, address indexed artist, uint256 price, bytes32 songHash);
    // An event emitted when an artist uploads a song, with the song's details.

    event SongPurchased(uint256 indexed songId, address indexed buyer, address indexed artist, uint256 price);
    // An event emitted when a listener purchases a song, with details of the transaction.

    event DonationMade(address indexed donor, address indexed artist, uint256 amount);
    // An event emitted when a donation is made to an artist, including donor and artist addresses, and the donation amount.

    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "You must register first.");
        _;
    }
    // A modifier to restrict access to functions to only registered users. If the user is not registered, it throws an error.

    modifier onlyArtist() {
        require(users[msg.sender].isArtist, "Only artists can upload songs.");
        _;
    }
    // A modifier to restrict access to functions to only artists. Throws an error if the caller is not an artist.

    // Register as a listener or artist
    function registerUser(bool _isArtist) public {
        require(!users[msg.sender].isRegistered, "User is already registered.");
        // Ensure the user is not already registered.
        
        users[msg.sender] = User({
            isArtist: _isArtist,
            isRegistered: true
        });
        // Register the user as either an artist or listener, depending on _isArtist.
        
        emit UserRegistered(msg.sender, _isArtist);
        // Emit an event to signal that the user has registered.
    }

    // Artist uploads a song
    function uploadSong(string memory _title, uint256 _price, bytes32 _songHash) public onlyArtist onlyRegistered {
        require(_price > 0, "Price should be greater than zero.");
        // Ensure the price of the song is greater than zero.

        songCount++;
        // Increment the song count.

        songs[songCount] = Song({
            id: songCount,
            title: _title,
            price: _price,
            artist: payable(msg.sender),
            songHash: _songHash  // Unique identifier for the song (can be a hash of the song file).
        });
        // Store the new song in the `songs` mapping with an incremented ID.

        emit SongUploaded(songCount, _title, msg.sender, _price, _songHash);
        // Emit an event to signal that a new song has been uploaded.
    }

    // Listener purchases a song
    function purchaseSong(uint256 _songId) public payable onlyRegistered {
        Song memory song = songs[_songId];
        // Retrieve the song details based on the provided songId.

        require(msg.value == song.price, "Incorrect Ether amount sent.");
        // Ensure the Ether sent matches the price of the song.

        require(!songPurchased[msg.sender][_songId], "You have already purchased this song.");
        // Ensure the user has not already purchased this song.

        song.artist.transfer(msg.value);
        // Transfer the Ether to the artist.

        songPurchased[msg.sender][_songId] = true;
        // Mark the song as purchased by the user.

        emit SongPurchased(_songId, msg.sender, song.artist, song.price);
        // Emit an event to signal that the song has been purchased.
    }

    // Listener donates to an artist
    function donateToArtist(address payable _artist) public payable onlyRegistered {
        require(users[_artist].isArtist, "Recipient is not an artist.");
        // Ensure the recipient is a registered artist.

        require(msg.value > 0, "Donation amount must be greater than zero.");
        // Ensure the donation amount is greater than zero.

        _artist.transfer(msg.value);
        // Transfer the donation amount to the artist.

        emit DonationMade(msg.sender, _artist, msg.value);
        // Emit an event to signal that a donation has been made.
    }

    // Get song details by songId
    function getSong(uint256 _songId) public view returns (string memory title, uint256 price, address artist, bytes32 songHash) {
        Song memory song = songs[_songId];
        // Retrieve the song details from the mapping.

        return (song.title, song.price, song.artist, song.songHash);
        // Return the song details (title, price, artist address, and song hash).
    }
}
