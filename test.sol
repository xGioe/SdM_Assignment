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


    function Purchase() { 
        merchant = msg.sender;
    }

/*
function add(uint id, uint _x) public {
        foo[id].push(Foo(_x));
    }
*/
    function addDiamond(uint id, address owner, uint id, string color) public {
        //var diamond = diamonds[_uint];

        //diamond.address = _age;
        //diamond.id = id;
        //diamond.color = color;
        
        diamonds[id].push(Diamond(owner, id, color));
    }

    function getDiamonds() view public returns (uint[]) {
        return diamondList;
    }

    function countDiamonds() view public returns (uint) {
        return diamondList.length;
    }

    function changeOwner(address owner) {
        if (msg.sender == merchant)
            diamond.owner = owner;
        else throw;
    }
}