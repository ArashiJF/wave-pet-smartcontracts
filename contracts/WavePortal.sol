//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract PetVote {
    // Represents the user vote in the blockchain
    struct Voter {
        address voter;
        bool voted;
        string vote;
    }

    struct VoteHistory {
        address voter;
        string reason;
        string vote;
    }

    // Represents the type of pet you can vote in the blockchain
    struct Option {
        string petName;
        uint voteCount;
    }

    string[5] petNames = ["Dogs", "Cats", "Birds", "Fishes", "Turtles"];

    event NewVote(address indexed from, uint timestamp, string reason, string petName);

    VoteHistory[] public voterHistory;

    // Map to access the voters by their address so they can only vote once per wallet!
    mapping(address => Voter) public voters;

    // Voting options for the contract!
    mapping(string => Option) public options;

    // Initialize the contract with predefined pets!
    constructor() {
        for (uint i = 0; i < petNames.length; i++) {
            options[petNames[i]] = Option({ petName: petNames[i], voteCount: 0});
        }
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address!");
        _;
    }

    // Function to vote one of the pets!, can also pass a reason as to why they chose that one
    function vote(string memory _petName, string memory _reason)
        public
        validAddress(msg.sender)
    {
        Voter storage sender = voters[msg.sender];
        // Validate that the user has not voted!
        require(!sender.voted, "You already voted.");

        Option storage option = options[_petName];
        
        // Update the vote count!
        option.voteCount += 1;

        // Update the user info if they have not voted already!
        sender.voted = true; // mark that the user has voted!
        sender.vote = _petName; // mark which pet type they voted for!
        sender.voter = msg.sender; // save their address!

        // Save the user vote along with their reason in the VoteHistory
        voterHistory.push(VoteHistory({ voter: msg.sender, reason: _reason, vote: _petName }));
        emit NewVote(msg.sender, block.timestamp, _reason, _petName);
    }

    // Check if the user has voted or not!
    function alreadyVoted()
        public
        view
        validAddress(msg.sender)
        returns (bool)
    {
        bool voted = voters[msg.sender].voted;
        return voted;
    }

    // Get all the options with their votes!
    function getOptions() public view returns (Option[] memory) {
        // First we create a new array for the response with the length of the options delcared in petNames
        Option[] memory _options = new Option[](petNames.length);

        // We iterate over each potition, and using the mapping we save the values in our return array
        for (uint i = 0; i < petNames.length; i++) {
            _options[i] = options[petNames[i]];
        }

        // We return the array of options with the values from storage
        return _options;
    }

    // Return the array with the users that have voted with their reasons and such!
    function getVoteHistory() public view returns (VoteHistory[] memory) {
        return voterHistory;
    }
}

contract WavePortal {
    uint256 totalWaves;
    uint private seed;

    // Create an event to save more info in the blockchain's block
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint) public lastWavedAt;

    constructor() payable {
        console.log("Hello creator, what is my purpose?");
    }

    function wave(string memory _message) public {
        // check that the user waited 15 minutes before waving again!
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "wait 15m");

        // Update the new timestamp of the user that just waved
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        emit NewWave(msg.sender, block.timestamp, _message);

        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("#Random number generated: %s", randomNumber);

        seed = randomNumber;

        if (randomNumber < 25) {
            console.log("%s won!", msg.sender);
            uint prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has!");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    // Return the wave array with the user information!
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }
}
