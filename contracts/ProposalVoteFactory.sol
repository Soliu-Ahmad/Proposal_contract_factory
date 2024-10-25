// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.27;

// import "./ProposalVote.sol";

// contract ProposalVoteFactory {
//     ProposalVote[] public proposalVotes;

//     mapping(address => ProposalVote[]) public userProposals;

//     event ProposalVoteDeployed(
//         address indexed contractAddress,
//         address indexed creator
//     );

 
//     function createProposalVote() external {
//         ProposalVote newProposalVote = new ProposalVote();

//         proposalVotes.push(newProposalVote);

//         userProposals[msg.sender].push(newProposalVote);

//         emit ProposalVoteDeployed(address(newProposalVote), msg.sender);
//     }

//     function getAllProposalVotes()
//         external
//         view
//         returns (ProposalVote[] memory)
//     {
//         return proposalVotes;
//     }

//     function getUserProposals(
//         address _user
//     ) external view returns (ProposalVote[] memory) {
//         return userProposals[_user];
//     }

//     function createProposal(
//         uint256 _index,
//         string memory _title,
//         string memory _desc,
//         uint16 _quorum
//     ) external {
//         require(
//             _index < proposalVotes.length,
//             "ProposalVote instance does not exist"
//         );

//         ProposalVote proposalVote = proposalVotes[_index];
//         proposalVote.createProposal(_title, _desc, _quorum);
//     }

  
//     function voteOnProposal(
//         uint256 _contractIndex,
//         uint8 _proposalIndex
//     ) external {
//         require(
//             _contractIndex < proposalVotes.length,
//             "ProposalVote instance does not exist"
//         );

//         ProposalVote proposalVote = proposalVotes[_contractIndex];
//         proposalVote.voteOnProposal(_proposalIndex);
//     }

  
//     function getProposal(
//         uint256 _contractIndex,
//         uint8 _proposalIndex
//     )
//         external
//         view
//         returns (
//             string memory title_,
//             string memory desc_,
//             uint16 voteCount_,
//             address[] memory voters_,
//             uint16 quorum_,
//             ProposalVote.PropsStatus status_
//         )
//     {
//         require(
//             _contractIndex < proposalVotes.length,
//             "ProposalVote instance does not exist"
//         );

//         ProposalVote proposalVote = proposalVotes[_contractIndex];
//         return proposalVote.getProposal(_proposalIndex);
//     }
// }



pragma solidity ^0.8.20;

import "./ProposalVote.sol";
import "./ProposalType.sol";
import {IProposalVote} from "./IProposal.sol";


contract ProposalVoteFactory {
    

    struct DeployedContractInfo {
        address deployer;
        address deployedContract;
    }

    mapping (address => DeployedContractInfo[]) allUserDeployedContracts;
    DeployedContractInfo[] allContracts;

    function deployClaimFaucet () external  returns (address contractAddress_) {
        require(msg.sender != address(0),  "Zero not allowed");

        address _address = address(new ProposalVote());
        contractAddress_ = _address;

        DeployedContractInfo memory _deployedContract;
        _deployedContract.deployer = msg.sender;
        _deployedContract.deployedContract = _address;

        allUserDeployedContracts[msg.sender].push(_deployedContract);
        allContracts.push(_deployedContract);
    }

    function getAllContractsDeployed() external view returns (DeployedContractInfo[] memory) {
        return allContracts;
    }

    function getUserDeployedContracts () external view returns (DeployedContractInfo[] memory) {
        return allUserDeployedContracts[msg.sender];
    }
    
    function getUserDeployedContractByIndex (uint8 _index) external view returns(address deployer_, address deployedContract_) {
        require(_index < allUserDeployedContracts[msg.sender].length, "Out of bound");
        DeployedContractInfo memory _deployedContract = allUserDeployedContracts[msg.sender][_index];

        deployer_ = _deployedContract.deployer;
        deployedContract_ = _deployedContract.deployedContract;
    }

    function getLengthOfDeployedContract () external view returns (uint256) {
        return allContracts.length;
    }

    function createAProposal(address _proposalContract, string memory _name, string memory _desc, uint16 _quorum) external {
        IProposalVote(_proposalContract).createProposal(_name, _desc, _quorum);
    }

    function VoteOnAProposal(address _proposalContract, uint8 _index) external {
        IProposalVote(_proposalContract).voteOnProposal(_index);
    }

    function getAsingleProposal(
        address _proposalContract, 
        uint8 _index
    ) external view returns (
        string memory name_, 
        string memory desc_, 
        uint16 count_, 
        address[] memory voters_, 
        uint16 quorum_, 
        PropsStatus status_
    ) {
        (name_, desc_, count_, voters_, quorum_, status_) = IProposalVote(_proposalContract).getAProposal(_index);
    }


    function getAllProposals(address _proposalContract) external view returns(Proposal[] memory) {

        return IProposalVote(_proposalContract).getAllProposals();
    }
}