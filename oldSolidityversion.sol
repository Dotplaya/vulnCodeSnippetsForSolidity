pragma solidity ^0.4.0;

contract VulnerableContract {
    address owner;

    function VulnerableContract() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) {
        if (msg.sender == owner) {
            owner = newOwner;
        }
    }

    function withdraw() {
        require(msg.sender == owner); // Vulnerability: Lack of access control
        msg.sender.transfer(this.balance);
    }

    // Other contract functions...
}
    // Lack of constructor visibility: In older versions of Solidity, the constructor had the same name as the contract
    //  and acted as the constructor function. However, the visibility specifier was missing. This allowed anyone to call 
    //  the constructor multiple times, potentially leading to undesired effects or reinitialization of state variables.

    // Lack of access control: The withdraw() function does not implement proper access control. It fails to check if the
    //  caller of the function is the owner before allowing a withdrawal. This means that anyone can call this function and
    //   withdraw funds from the contract, resulting in unauthorized access and potential loss of funds.


    // Mitigations for the above code snippet

pragma solidity ^0.4.22;

contract SecureContract {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function withdraw() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    // Other contract functions...
}

// Explanation:

//     Constructor visibility: In Solidity versions starting from 0.4.22, the constructor must be defined as a separate 
//     function with the constructor keyword. This ensures that it can only be called during contract deployment and is
//      not vulnerable to being called multiple times.

//     Access control modifier: The onlyOwner modifier is defined to restrict access to specific functions to only the
//      contract owner. The modifier checks if the caller of the function is the owner before allowing the function 
//      execution. By adding this modifier to the transferOwnership and withdraw functions, only the contract owner
//       can call these functions, effectively mitigating the vulnerability.
