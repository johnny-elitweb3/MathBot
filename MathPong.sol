// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MathPong {
    address public immutable beneficiary;
    mapping(address => uint256) public playerScores;
    uint256 public constant FEE_AMOUNT = 0.001 ether;

    event RoundLost(address indexed player, uint256 feeCharged);
    event ScoreUpdated(address indexed player, uint256 newScore);
    event MessageSent(address indexed sender, string message);

    constructor(address _beneficiary) {
        require(_beneficiary != address(0), "Beneficiary address cannot be zero");
        beneficiary = _beneficiary;
    }

    function loseRound() external payable {
        require(msg.value >= FEE_AMOUNT, "Insufficient fee");

        unchecked {
            playerScores[msg.sender]++;
        }

        emit RoundLost(msg.sender, FEE_AMOUNT);
        emit ScoreUpdated(msg.sender, playerScores[msg.sender]);

        uint256 excessPayment = msg.value - FEE_AMOUNT;
        if (excessPayment > 0) {
            payable(msg.sender).transfer(excessPayment);
        }

        payable(beneficiary).transfer(FEE_AMOUNT);
    }

    function getScore(address player) external view returns (uint256) {
        return playerScores[player];
    }

    function sendMessage(string calldata message) external {
        emit MessageSent(msg.sender, message);
    }
}