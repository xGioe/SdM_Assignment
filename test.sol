pragma solidity ^0.4.22;

contract Purchase {
    //diamond struct
    struct Diamond {
        address owner;
        uint id;
        string color;
    }
    
    //mapping diamonds
    mapping (uint => Diamond[]) diamonds;
    //uint[] public diamondList;

    address merchant;


    Purchase() { 
        merchant = msg.sender;
    }

    function addDiamond(uint id, address owner, uint id, string color) public {
        //var diamond = diamonds[_uint];

        //diamond.address = _age;
        //diamond.id = id;
        //diamond.color = color;
    if (msg.sender == merchant)   
        diamonds[id].push(Diamond(owner, id, color));
    else throw;

    }

    function getDiamonds() view public returns (uint[]) {
        return diamondList;
    }

    function countDiamonds() view public returns (uint) {
        return diamondList.length;
    }

    /*
    function changeOwner(Diamond diamond, address owner) {
        if (msg.sender == merchant)
            diamond.owner = owner;
        else throw;
    }
    */
    
    function changeOwner(uint id, uint index, address owner) public {
        if (msg.sender == merchant)
            diamonds[id][index].owner = owner;
        else throw; 
    }
}