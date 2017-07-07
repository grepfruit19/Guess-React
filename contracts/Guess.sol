pragma solidity ^0.4.4;

import "./MetaCoin.sol";

contract Guess {
    MetaCoin coin;
    uint index = 0;
    uint numArrayMax = 5;
    int[5] numArray;

    mapping (address => bool) registered;


    function Guess(){
        //Random numbers
        numArray = [3,4,2,5,1];
    }

    // Construct MetaCoin and credit 10k to this contract.
    function initializeCoin() returns (address){
        MetaCoin metaCoin = new MetaCoin();
        coin = metaCoin;
        return metaCoin;
    }

    function getOwnBalance() returns (uint){
        return coin.getBalance(this);
    }

    function getBalance(address arg) returns (uint){
        return coin.getBalance(arg);
    }

    function registerUser() returns (bool){
        address currentAddress = msg.sender;

        if (registered[currentAddress] == false){
            registered[currentAddress] = true;
            coin.sendCoin(currentAddress, 100);
            return true;
        } else {
            return false;
        }
    }

    function approveValue(uint256 value) returns (bool){
        //msg.sender approves this contract to take "value" coins.
        return coin.approve(msg.sender, this, value);
    }

    function takeCoin(uint256 value) returns (bool){
        return coin.takeCoin(msg.sender, this, value);
    }

    function takeGuess(int guess) returns (bool){
        uint balance = getBalance(msg.sender);
        if (balance>0){
            int actual = popNumber();
            if (guess == actual){
                coin.sendCoin(msg.sender, 4);
                return true;
            } else {
                coin.takeCoin(msg.sender, this, 1);
                return true;
            }
        } else {
            return false;
        }
        return false;
    }

    // Returns current number without moving index.
    function peekNumber() returns (int){
        return numArray[index];
    }

    // Returns current number and increments index.
    function popNumber() returns (int){
        int output;
        if (index == numArrayMax -1){
            output = numArray[index];
            index = 0;
        } else {
            output = numArray[index];
            index = index + 1;
        }
        return output;
    }

}
