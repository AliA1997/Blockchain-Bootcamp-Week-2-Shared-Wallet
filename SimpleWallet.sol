pragma solidity ^0.8.0;
import "./Allowance.sol";

contract SimpleWallet is Allowance {
    
    ///Make the _benefiicary indexed to search on it via the site chain.
    event MoneySent(address indexed _beneficiary, uint _amount);
    
    ///Make the _from indexed to search on it via the site chain.
    event MoneyReceived(address indexed _from, uint _amount);
    

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        
        require(_amount <= address(this).balance, "There are not enough funds stored in smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("Can't renounce ownership here.");
    }
    
    //Fallback function to deposit funds.
    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    
    receive() external payable {
        
    }
}