// Copyright (C) 2023-2024 StorSwift Inc.
// This file is part of the PowerVoting library.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity ^0.8.19;

import { Ownable2StepUpgradeable } from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { IPowerVoting } from "./interfaces/IPowerVoting-bob.sol";
import { Proposal, VoteInfo } from "./types.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract PowerVoting is IPowerVoting, Ownable2StepUpgradeable, UUPSUpgradeable {

    using Counters for Counters.Counter;

    // proposal id
    Counters.Counter public proposalId;

    // proposal mapping, key: proposal id, value: Proposal
    mapping(uint256 => Proposal) public idToProposal;

    // proposal id to vote, out key: proposal id, inner key: vote id, value: vote info
    mapping(uint256 => mapping(uint256 => VoteInfo)) public proposalToVote;

    // override from UUPSUpgradeable
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function initialize() public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);
    }

    /**
     * create a proposal and store it into mapping
     *
     * @param proposalCid: proposal content is stored in ipfs, proposal cid is ipfs cid for proposal content
     * @param expTime: proposal expiration timestamp, second
     * @param proposalType: proposal type
     */
    function createProposal(string calldata proposalCid, uint248 expTime, uint256 proposalType) override external {
        // increment proposal id
        proposalId.increment();
        uint256 id  = proposalId.current();
        // create proposal
        Proposal storage proposal = idToProposal[id];
        proposal.cid = proposalCid;
        proposal.creator = msg.sender;
        proposal.expTime = expTime;
        proposal.proposalType = proposalType;
        emit ProposalCreate(id, proposal);
    }

    /**
     * vote
     *
     * @param id: proposal id
     * @param info: vote info, IPFS cid
     */
    function vote(uint256 id, string calldata info) override external{
        Proposal storage proposal = idToProposal[id];
        // if proposal is expired, won't be allowed to vote
        if(proposal.expTime <= block.timestamp){
            revert TimeError("Proposal expiration time reached.");
        }
        // increment votesCount
        uint256 vid = ++proposal.votesCount;
        // use votesCount as vote id
        VoteInfo storage voteInfo = proposalToVote[id][vid];
        voteInfo.voteInfo = info;
        voteInfo.voter = msg.sender;
        emit Vote(id, msg.sender, info);
    }

}
