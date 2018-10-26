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
    address buyer;
    address seller;
    address agent;

    // function Purchase();


    // function Purchase(address _agent, address _seller, address _buyer) {
    //     merchant = msg.sender;
    //     agent = _agent;
    //     buyer = _buyer;
    //     seller = _seller;
    // }

    function release() {
        if (msg.sender == agent)
            suicide(seller); // Send all funds to seller
            //call change ownership
        else throw;
    }

    function cancel() {
        if (msg.sender == agent)
            suicide(buyer); // Cancel escrow and return all funds to buyer
            //no need to call change ownership
        else throw;
    }

    function addDiamond(uint id, address owner, uint id2, string color) public {
        //var diamond = diamonds[_uint];

        //diamond.address = _age;
        //diamond.id = id;
        //diamond.color = color;
    if (msg.sender == merchant)
        diamonds[id].push(Diamond(owner, id2, color));
    else throw;
    }


    // function getDiamonds() view public returns (uint[]) {
    //     return diamonds;
    // }
    //
    // function countDiamonds() view public returns (uint) {
    //     return diamonds.length;
    // }

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
