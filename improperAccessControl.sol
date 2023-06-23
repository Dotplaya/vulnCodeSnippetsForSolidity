// example 1
pragma solidity ^0.8.0;

contract VulnerableContract {
    address public owner;
    uint256 public balance;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        balance += msg.value;
    }

    function withdraw() public {
        address payable recipient = payable(msg.sender);
        recipient.transfer(balance);
        balance = 0;    
    }
}

// Explanation:

// In the code snippet provided, there is a vulnerability related to incorrect access control. The withdraw 
// function is intended to be only called by the contract owner (msg.sender == owner). However, the function
//  does not enforce this properly, allowing anyone to call it and withdraw the entire contract balance.

// This vulnerability allows unauthorized individuals to drain the contract's funds and potentially cause
//  financial loss or disrupt the intended functionality of the contract.

// Mitigation

pragma solidity ^0.8.0;

contract SecureContract {
    address public owner;
    uint256 public balance;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        balance += msg.value;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the contract owner can withdraw funds.");
        address payable recipient = payable(msg.sender);
        recipient.transfer(balance);
        balance = 0;
    }
}

// Explanation 

    // Modifier: The withdraw function includes a require statement to check if the caller of the function (msg.sender)
    //  is the contract owner (owner). If the condition evaluates to false, it throws an exception and prevents the 
    //  execution of the function.

    // Error message: The require statement includes an error message that clearly states that only the contract owner
    //  can withdraw funds. This provides a helpful explanation to the user and helps prevent confusion or misuse of 
    //  the contract.


// Example 2

pragma solidity ^0.8.0;

contract VulnerableContract {
    uint256 public secretNumber;

    function setSecretNumber(uint256 _number) public {
        secretNumber = _number;
    }

    function getSecretNumber() public view returns (uint256) {
        return secretNumber;
    }
}

// Explanation:

//  In the code snippet provided, there is a vulnerability related to incorrect access control. The setSecretNumber
//  function is defined as public, allowing anyone to call it and modify the secretNumber state variable. This can
//   lead to unauthorized modifications of sensitive data, potentially compromising the integrity and security of 
//   the contract.

// Mitigation 

pragma solidity ^0.8.0;

contract SecureContract {

    uint256 private secretNumber;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    function setSecretNumber(uint256 _number) public onlyOwner {
        secretNumber = _number;
    }

    function getSecretNumber() public view returns (uint256) {
        return secretNumber;
    }
}

// Explanation 

    // Access Control: The secretNumber state variable is changed to private visibility to restrict direct access from
    //  outside the contract. This makes it accessible only within the contract.

    // Modifier: The onlyOwner modifier is introduced, which is used as a function modifier for the setSecretNumber
    //  function. This modifier checks if the caller of the function (msg.sender) is the contract owner (owner). 
    //  If the condition evaluates to false, it throws an exception and prevents the execution of the function.
