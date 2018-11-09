pragma solidity ^0.4.22;

contract DiamondTracker2 {

    struct Diamond {
        bytes32 id;
        string origin;
        DiamondType d_type;
        DiamondProperties properties;
        address owner;
        //TODO Parameters Giovanni asked for
    }

    //Can't declare as constant. Constant non-value types not yet supported
    Diamond NULL_DIAMOND = Diamond({
        id: "0x00",
        origin: "",
        d_type: DiamondType.Synthetic,
        properties: DiamondProperties(0),
        owner: 0x00
    });

    struct DiamondProperties {
        uint size;
    }

    enum ExchangeState { Pending, Approved, Rejected, Finished} //TODO Review the states needed
    struct DiamondExchange {
        bytes32 diamond_id;
        address buyer;
        address owner;
        uint value; //In ether
        ExchangeState state;
    }

    enum DiamondType { Synthetic, Natural }
    address[] public certificate_authorities; //TODO Should this be public??
    // mapping(bytes32 => address) owners;
    //the mapping between each owner (address) and the diamons possessed
    mapping (address => Diamond[]) public owners;
    Diamond[] diamondsList;
    DiamondExchange[] exchanges;

    event diamondSold();
    event diamondBuyingRequest();

    constructor(address[] _certificate_authorities) public {
        certificate_authorities = _certificate_authorities;
    }

    function register(address _owner, uint _type, string _origin, uint _size) external returns (bytes32) {
        require(isCA(msg.sender), "You are not allowed to call register()");
        require(_type == 0 || _type == 1, "Type must be 0(Synthetic) or 1(Natural)"); //Type 0 = Synthetic, Type 1 = Natural

        Diamond memory d;
        if(_type == 0) {
            d.d_type = DiamondType.Synthetic;
        } else if (_type == 1) {
            d.d_type = DiamondType.Natural;
        }
        d.origin = _origin;
        d.properties.size = _size;

        d.id = sha256(abi.encodePacked(_size, _type, _origin)); //creation of the unique ID

        if(!addDiamond(d, _owner))
            revert("Diamond already exists");



        return d.id;
    }

    function sell(bytes32 ID, address newOwner) external {
        sell(ID, msg.sender, newOwner);
    }

    function sell(bytes32 ID, address oldOwner, address newOwner) private {
        //TODO Check if pending requests
        Diamond memory sellingDiamond;
        sellingDiamond.id = ID;
        require(isOwner(oldOwner, sellingDiamond), "You are not the owner of the specified diamond");

        Diamond[] storage ownedDiamonds = owners[oldOwner];
        for(uint i = 0; i < ownedDiamonds.length; i++) {
            if(owners[oldOwner][i].id == sellingDiamond.id){
                delete owners[oldOwner][i];
            }
        }

        for(uint j = 0; j < diamondsList.length; j++) {
            if (diamondsList[j].id == sellingDiamond.id){
                owners[newOwner].push(diamondsList[j]);
                diamondsList[j].owner = newOwner;
            }
        }
        emit diamondSold();
    }


    function buy(bytes32 diamond_id) external payable {

        bytes32 id;
        string memory origin;
        DiamondType d_type;
        uint size;
        address owner;
        (id, origin, d_type, size, owner) = this.getDiamondById(diamond_id);
        Diamond memory sellingDiamond = Diamond({
            id: id,
            origin: origin,
            d_type: d_type,
            properties: DiamondProperties(size),
            owner: owner
        });

        require(!equals(sellingDiamond, NULL_DIAMOND), "Must request to buy an existing diamond");
        require(!(sellingDiamond.owner == msg.sender), "Sender already owns this diamond");



        DiamondExchange memory exchange; //This memory exchange will be converted to storage once pushed into the array
        exchange.diamond_id = sellingDiamond.id;
        exchange.buyer = msg.sender;
        exchange.owner = sellingDiamond.owner;
        exchange.value = msg.value;
        exchange.state = ExchangeState.Pending;

        exchanges.push(exchange);

        emit diamondBuyingRequest();
    }

    function buyingRequestsPending() external payable {
        address _owner = msg.sender;
        for(uint i = 0; i < exchanges.length; i++) {
            if(exchanges[i].owner == _owner){
                if(exchanges[i].state == ExchangeState.Pending) {
                    sell(exchanges[i].diamond_id, _owner, exchanges[i].buyer);
                    exchanges[i].state = ExchangeState.Approved;
                    for (uint j = ++i; j < exchanges.length; j++) {
                        if(exchanges[i].owner == _owner && exchanges[i].state == ExchangeState.Pending) {
                            exchanges[i].state == ExchangeState.Finished;
                        }
                    }
                    break;
                    //delete exchanges[i];
                }
            }
        }
    }
    //
    // function getPendingBuyingRequest() external view returns (bytes32, address, uint) {
    //     address _seller = msg.sender;
    //     for(uint i = 0; i < exchanges.length; i++) {
    //         if(exchanges[i].owner == _seller && exchanges[i].state == ExchangeState.Pending){
    //           return(
    //             exchanges[i].diamond_id,
    //             exchanges[i].buyer,
    //             exchanges[i].value
    //           );
    //         }
    //     }
    // }

    function getDiamondByIndex(uint index) external view returns (bytes32, string, DiamondType, uint, address) {
        if(index >= diamondsList.length) { //Assuming no diamonds are deleted from the system
            return (
                NULL_DIAMOND.id,
                NULL_DIAMOND.origin,
                NULL_DIAMOND.d_type,
                NULL_DIAMOND.properties.size,
                NULL_DIAMOND.owner
            );
        } else {
            return (
                diamondsList[index].id,
                diamondsList[index].origin,
                diamondsList[index].d_type,
                diamondsList[index].properties.size,
                diamondsList[index].owner
            );
        }
    }

    function getDiamondById(bytes32 id) external view returns (bytes32, string, DiamondType, uint, address) {
        for(uint i = 0; i < diamondsList.length; i++) {
            if(diamondsList[i].id == id){
                return (
                  diamondsList[i].id,
                  diamondsList[i].origin,
                  diamondsList[i].d_type,
                  diamondsList[i].properties.size,
                  diamondsList[i].owner
                );
            }
        }
        return (NULL_DIAMOND.id, NULL_DIAMOND.origin, NULL_DIAMOND.d_type, NULL_DIAMOND.properties.size, NULL_DIAMOND.owner);
    }

    function getNumberOfDiamonds() external view returns (uint) {
        return diamondsList.length;
    }

/*
    function getNumberOfPendingRequests(address owner) external view returns (uint) {
        uint pendingRequests = 0;
        for(uint i = 0; i < exchanges.length; i++) {
            if(exchanges[i].owner)
        }
    }
*/
    function equals(Diamond d1, Diamond d2) internal pure returns (bool) {
        return keccak256(encodeDiamond(d1)) == keccak256(encodeDiamond(d2));
    }

    function addDiamond(Diamond d, address owner) private returns (bool) {
        for(uint i = 0; i < diamondsList.length; i++) {
            if(equals(d, diamondsList[i]))
              return false;
        }
      // NOTE: we expect that if diamond is already in diamondsList then it has a owner
        d.owner = owner;
        diamondsList.push(d);
        owners[owner].push(d);
        return true;
    }



    function isOwner(address user, Diamond sellingDiamond) private view returns (bool) {
        Diamond[] storage ownedDiamonds = owners[user];
        for(uint i = 0; i < ownedDiamonds.length; i++) {
            if(ownedDiamonds[i].id == sellingDiamond.id){
                return true;
            }
        }
        return false;
    }

    function isCA(address user) private view returns (bool) {
        for(uint i = 0; i < certificate_authorities.length; i++) {
            if(certificate_authorities[i] == user)
              return true;
        }
        return false;
    }

    function encodeDiamond(Diamond d) private pure returns (bytes) {
        return abi.encodePacked(
          d.id,
          d.origin,
          d.d_type,
          d.properties.size
        );
    }
}

