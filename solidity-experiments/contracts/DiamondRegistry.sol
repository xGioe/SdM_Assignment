pragma solidity ^0.4.22;

contract DiamondRegistry {

    //diamond struct
    struct Diamond {
      uint id;
      string color;
      string type;
    }

    //the mapping between each owner (address) and the diamons possessed
    mapping (address => Diamond[]) public owenership;

    // uint public value;
    address public mediator;

    enum State { Created, Locked, Inactive }
    State public state;

    // Set the Certification Authority as the owner of the contract
    Diamond() public {
        mediator = msg.sender;
    }

    modifier onlyMediator() {
      require(
          msg.sender == mediator,
          "Only mediator can call this."
      );
    }

    // modifier onlyBuyer() {
    //     require(
    //         msg.sender == buyer,
    //         "Only buyer can call this."
    //     );
    //     _;
    // }

    // modifier onlySeller() {
    //     require(
    //         msg.sender == seller,
    //         "Only seller can call this."
    //     );
    //     _;
    // }

    // modifier inState(State _state) {
    //     require(
    //         state == _state,
    //         "Invalid state."
    //     );
    //     _;
    // }

    event Aborted();
    event ItemReceived();

    // Add diamond to the registry binding it to the address of the owner issuer.
    // Only the mediator is allowed to perform the action.
    // An unique ID is computed from the physical features of the diamond
    // Params:
    // - owner(address): address of the diamond owner issuing the add request
    // - color(string): color of diamon
    function addDiamond(address owner, string color, string type) public {

      onlyMediator
      public
      // check if diamond is already present
      // create the ID of diamond: ID = hash(color,type)
      // add the address to the owners list
      // add the diamond to the diamonds list
      // add in the register hashmap the address (if not exist) and bind the newly diamon

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


    // /// Abort the DiamondRegistry and reclaim the ether.
    // /// Can only be called by the seller before
    // /// the contract is locked.
    // function abort()
    //     public
    //     onlySeller
    //     inState(State.Created)
    // {
    //     emit Aborted();
    //     state = State.Inactive;
    //     seller.transfer(address(this).balance);
    // }

    // /// Confirm the DiamondRegistry as buyer.
    // /// Transaction has to include `2 * value` ether.
    // /// The ether will be locked until confirmReceived
    // /// is called.
    // function confirmDiamondRegistry()
    //     public
    //     inState(State.Created)
    //     condition(msg.value == (2 * value))
    //     payable
    // {
    //     emit DiamondRegistryConfirmed();
    //     buyer = msg.sender;
    //     state = State.Locked;
    // }

    // /// Confirm that you (the buyer) received the item.
    // /// This will release the locked ether.
    // function confirmReceived()
    //     public
    //     onlyBuyer
    //     inState(State.Locked)
    // {
    //     emit ItemReceived();
    //     // It is important to change the state first because
    //     // otherwise, the contracts called using `send` below
    //     // can call in again here.
    //     state = State.Inactive;
    //
    //     // NOTE: This actually allows both the buyer and the seller to
    //     // block the refund - the withdraw pattern should be used.
    //
    //     buyer.transfer(value);
    //     seller.transfer(address(this).balance);
    // }
}
