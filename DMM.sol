// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Build the contract
contract DecentralizedMusicMarketplace {

    // Structure representing a Song
    struct Song {
        uint256 id;              
        string title;            
        uint256 price;           // Song price in Wei (1 Ether = 10^18 Wei)
        address payable artist;  
        bytes32 songHash;        // Unique hash of the song (can be used to store file hash)
    }

    // Structure representing a User
    struct User {
        bool isArtist;          // Indicates if the user is an artist
        bool isRegistered;      // Indicates if the user is registered
    }

    // Counter for tracking the total number of songs uploaded
    uint256 public songCount = 0;

    // Mapping from song ID to the Song struct
    mapping(uint256 => Song) public songs;

    // Mapping from user address to User struct
    mapping(address => User) public users;

    // Nested mapping to track if a specific user has purchased a specific song
    mapping(address => mapping(uint256 => bool)) public songPurchased;

    // Events to log important actions
    event UserRegistered(address indexed user, bool isArtist);
    event SongUploaded(uint256 indexed songId, string title, address indexed artist, uint256 price, bytes32 songHash);
    event SongPurchased(uint256 indexed songId, address indexed buyer, address indexed artist, uint256 price);
    event DonationMade(address indexed donor, address indexed artist, uint256 amount);

    // Modifier to ensure only registered users can interact with certain functions
    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "You must register first.");
        _;
    }

    // Modifier to ensure only registered artists can upload songs
    modifier onlyArtist() {
        require(users[msg.sender].isArtist, "Only artists can upload songs.");
        _;
    }

    // Register as either a listener or an artist
    function registerUser(bool _isArtist) public {
        // Ensure that the user is not already registered
        require(!users[msg.sender].isRegistered, "User is already registered.");
        
        // Register the user with the provided role (artist or listener)
        users[msg.sender] = User({
            isArtist: _isArtist,
            isRegistered: true
        });

        // Emit an event that the user has been registered
        emit UserRegistered(msg.sender, _isArtist);
    }

   
    function uploadSong(string memory _title, uint256 _price, bytes32 _songHash) public onlyArtist onlyRegistered {
        // Ensure that the price is greater than zero
        require(_price > 0, "Price should be greater than zero.");
        
        // Increment the song counter and create a new song entry
        songCount++;
        songs[songCount] = Song({
            id: songCount,
            title: _title,
            price: _price,
            artist: payable(msg.sender),  // Artist is the sender of the transaction
            songHash: _songHash  // Hash that represents the song, typically its file hash
        });

        // Emit an event when the song is uploaded
        emit SongUploaded(songCount, _title, msg.sender, _price, _songHash);
    }

    // Registered users can purchase songs
    function purchaseSong(uint256 _songId) public payable onlyRegistered {
        // Retrieve the song from the mapping using the song ID
        Song memory song = songs[_songId];

        // Ensure the buyer sends the correct Ether amount
        require(msg.value == song.price, "Incorrect Ether amount sent.");
        
        // Check if the user has already purchased the song
        require(!songPurchased[msg.sender][_songId], "You have already purchased this song.");
        
        // Transfer Ether to the artist (song's seller)
        song.artist.transfer(msg.value);

        // Mark the song as purchased for this user
        songPurchased[msg.sender][_songId] = true;

        // Emit an event when a song is purchased
        emit SongPurchased(_songId, msg.sender, song.artist, song.price);
    }

    // Registered users can donate to artists
    function donateToArtist(address payable _artist) public payable onlyRegistered {
        
        require(users[_artist].isArtist, "Recipient is not an artist.");
        
      
        require(msg.value > 0, "Donation amount must be greater than zero.");
        
        // Transfer the donation to the artist
        _artist.transfer(msg.value);

        // Emit an event when a donation is made
        emit DonationMade(msg.sender, _artist, msg.value);
    }

    // Function to get details of a song by song ID
    function getSong(uint256 _songId) public view returns (string memory title, uint256 price, address artist, bytes32 songHash) {
        // Retrieve the song details from the mapping
        Song memory song = songs[_songId];
        
        // Return the song details
        return (song.title, song.price, song.artist, song.songHash);
    }
}
