// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//build the contract
contract DecentralizedMusicMarketplace {
    struct Song {
        uint256 id;
        string title;
        uint256 price;
        address payable artist;
        bytes32 songHash;
    }

    struct User {
        bool isArtist; //to specify between artist and listener 
        bool isRegistered;
    }

    uint256 public songCount = 0;
    mapping(uint256 => Song) public songs;
    mapping(address => User) public users;
    mapping(address => mapping(uint256 => bool)) public songPurchased;

    event UserRegistered(address indexed user, bool isArtist);
    event SongUploaded(uint256 indexed songId, string title, address indexed artist, uint256 price, bytes32 songHash);
    event SongPurchased(uint256 indexed songId, address indexed buyer, address indexed artist, uint256 price);
    event DonationMade(address indexed donor, address indexed artist, uint256 amount);

    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "You must register first.");
        _;
    }

    modifier onlyArtist() {
        require(users[msg.sender].isArtist, "Only artists can upload songs.");
        _;
    }

    // Register as a listener or artist
    function registerUser(bool _isArtist) public {
        require(!users[msg.sender].isRegistered, "User is already registered.");
        users[msg.sender] = User({
            isArtist: _isArtist,
            isRegistered: true
        });
        emit UserRegistered(msg.sender, _isArtist);
    }

    // Artist uploads a song
    function uploadSong(string memory _title, uint256 _price, bytes32 _songHash) public onlyArtist onlyRegistered {
        require(_price > 0, "Price should be greater than zero.");
        songCount++;
        songs[songCount] = Song({
            id: songCount,
            title: _title,
            price: _price,
            artist: payable(msg.sender),
            songHash: _songHash  // Unique identifier for the song (can be a hash of the song file)
        });
        emit SongUploaded(songCount, _title, msg.sender, _price, _songHash);
    }

    // Listener purchases a song
    function purchaseSong(uint256 _songId) public payable onlyRegistered {
        Song memory song = songs[_songId];
        require(msg.value == song.price, "Incorrect Ether amount sent.");
        require(!songPurchased[msg.sender][_songId], "You have already purchased this song.");
        
        song.artist.transfer(msg.value);  // Send Ether to the artist
        songPurchased[msg.sender][_songId] = true;

        emit SongPurchased(_songId, msg.sender, song.artist, song.price);
    }

    // Listener donates to an artist
    function donateToArtist(address payable _artist) public payable onlyRegistered {
        require(users[_artist].isArtist, "Recipient is not an artist.");
        require(msg.value > 0, "Donation amount must be greater than zero.");
        
        _artist.transfer(msg.value);  // Transfer donation to the artist
        emit DonationMade(msg.sender, _artist, msg.value);
    }

    // Get song details by songId
    function getSong(uint256 _songId) public view returns (string memory title, uint256 price, address artist, bytes32 songHash) {
        Song memory song = songs[_songId];
        return (song.title, song.price, song.artist, song.songHash);
    }
}
