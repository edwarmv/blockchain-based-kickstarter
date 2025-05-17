// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.4.19;

contract Camping {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }

    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    Request[] public requests;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint minimum) {
        manager = msg.sender;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
    }

    function createRequest(
        string calldata description,
        uint value,
        address recipient
    ) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false
        });

        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
}
