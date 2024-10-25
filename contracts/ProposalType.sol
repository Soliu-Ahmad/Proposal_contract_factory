
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


enum PropsStatus {None, Created, pending, Accepted}

 struct Proposal {
        string name;
        string description;
        uint16 voteCount;
        address[] voters;
        uint16 quorum;
        PropsStatus status;

    }