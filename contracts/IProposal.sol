// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;
import "./ProposalType.sol";



interface  IProposalVote {
    

    function createProposal(string memory _name, string memory _desc, uint16 _quorum) external ;
    function voteOnProposal(uint8 _index) external ;
    function getAProposal(uint8 _index) external  view  returns (string memory name_, string memory desc_, uint16 count_, address[] memory voters_, uint16 quorum_, PropsStatus status_);
     function getAllProposals() external view returns (Proposal[] memory) ;



    
}