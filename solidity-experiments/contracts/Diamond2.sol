pragma solidity ^0.4.22;

contract DiamondTracker2 {

    struct Diamond {
        bytes32 id;
        string origin;
        DiamondType d_type;
        DiamondProperties properties;
        address diamondOwner;
    }

    //Can't declare as constant. Constant non-value types not yet supported
    Diamond NULL_DIAMOND = Diamond({
        id: "0x00",
        origin: "",
        d_type: DiamondType.Synthetic,
        properties: DiamondProperties(0),
        diamondOwner: 0x00
    });

    struct DiamondProperties {
        uint size;
    }

    enum ExchangeState { Pending, Approved, Rejected, Finished} //TODO Review the states needed
    struct DiamondExchange {
        bytes32 diamond_id;
        address buyer;
        address diamondOwner;
        uint value; //In ether
        ExchangeState state;
    }

    enum DiamondType { Synthetic, Natural }
    address[] public certificate_authorities;
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

    function sellDiamond(bytes32 ID, address newOwner) external {
        Diamond memory sellingDiamond;
        sellingDiamond.id = ID;
        require(isOwner(msg.sender, sellingDiamond), "You are not the owner of the specified diamond");

        Diamond[] storage ownedDiamonds = owners[msg.sender];
        for(uint i = 0; i < ownedDiamonds.length; i++) {
            if(owners[msg.sender][i].id == sellingDiamond.id){
                delete owners[msg.sender][i];
            }
        }

        for(uint j = 0; j < diamondsList.length; j++) {
            if (diamondsList[j].id == sellingDiamond.id){
                owners[newOwner].push(diamondsList[j]);
                diamondsList[j].diamondOwner = newOwner;
            }
        }
        emit diamondSold();
    }


    function buy(bytes32 diamond_id) external payable {

        bytes32 id;
        string memory origin;
        DiamondType d_type;
        uint size;
        address diamondOwner;
        (id, origin, d_type, size, diamondOwner) = this.getDiamondById(diamond_id);
        Diamond memory sellingDiamond = Diamond({
            id: id,
            origin: origin,
            d_type: d_type,
            properties: DiamondProperties(size),
            diamondOwner: diamondOwner
        });

        require(!equals(sellingDiamond, NULL_DIAMOND), "Must request to buy an existing diamond");
        require(!(sellingDiamond.diamondOwner == msg.sender), "Sender already owns this diamond");



        DiamondExchange memory exchange; //This memory exchange will be converted to storage once pushed into the array
        exchange.diamond_id = sellingDiamond.id;
        exchange.buyer = msg.sender;
        exchange.diamondOwner = sellingDiamond.diamondOwner;
        exchange.value = msg.value;
        exchange.state = ExchangeState.Pending;

        exchanges.push(exchange);

        emit diamondBuyingRequest();
        //TODO Logic of the function

    }

    function buyingRequestsPending() external payable {
        address _diamondOwner = msg.sender;
        for(uint i = 0; i < exchanges.length; i++) {
            if(exchanges[i].diamondOwner == _diamondOwner){
                if(exchanges[i].state == ExchangeState.Pending) {
                    this.sellDiamond(exchanges[i].diamond_id, exchanges[i].buyer);
                    exchanges[i].state = ExchangeState.Approved;
                    for (uint j = ++i; j < exchanges.length; j++) {
                        if(exchanges[i].diamondOwner == _diamondOwner && exchanges[i].state == ExchangeState.Pending) {
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
    //         if(exchanges[i].diamondOwner == _seller && exchanges[i].state == ExchangeState.Pending){
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
                NULL_DIAMOND.diamondOwner
            );
        } else {
            return (
                diamondsList[index].id,
                diamondsList[index].origin,
                diamondsList[index].d_type,
                diamondsList[index].properties.size,
                diamondsList[index].diamondOwner
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
                  diamondsList[i].diamondOwner
                );
            }
        }
        return (NULL_DIAMOND.id, NULL_DIAMOND.origin, NULL_DIAMOND.d_type, NULL_DIAMOND.properties.size, NULL_DIAMOND.diamondOwner);
    }

    function getNumberOfDiamonds() external view returns (uint) {
        return diamondsList.length;
    }

    function equals(Diamond d1, Diamond d2) internal pure returns (bool) {
        return keccak256(encodeDiamond(d1)) == keccak256(encodeDiamond(d2));
    }

    function addDiamond(Diamond d, address owner) private returns (bool) {
        //TODO: Check if diamond already exists
        for(uint i = 0; i < diamondsList.length; i++) {
            if(equals(d, diamondsList[i]))
              return false;
        }
      // NOTE: we expect that if diamond is already in diamondsList then it has a owner
        d.diamondOwner = owner;
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

