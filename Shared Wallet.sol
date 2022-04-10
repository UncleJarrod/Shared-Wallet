//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

import "./Ownable.sol";
import "./Allowance.sol";

contract SharedWallet is Ownable, Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);

    }
    
    address public myAddress;
 
    function setAddress(address _address) public {
    myAddress = _address;
    }

    function getBalanceOfAddress () public view returns (uint) {
    return myAddress.balance;
    }


    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}