pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {
    using SafeMath for uint;
    
    //Create events to hold data on site chain, that live outside soldiity
    //Index the forWho and fromWhom argument to search for them in the site chain.
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint  _oldAmount, uint _newAmount);
    
    mapping(address => uint) public allowance;
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    
    function isOwner() internal view returns(bool) {
        return (msg.sender == owner());
    }
    
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "Not authorized");
        _;
    }
    
    modifier allowedToTakeFromAllowance() {
        require(!isOwner(), "Cannot reduce allowance");
        _;
    }
    
    //make it internal not private so it can be used in other derived smart contacts.
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub( _amount);
    }
    
    
}