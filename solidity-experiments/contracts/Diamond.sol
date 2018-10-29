pragma solidity ^0.4.22;
//pragma experimental ABIEncoderV2;

contract Diamond {

    struct DiamondProperties {
        uint size;
        //TODO rest of the properties
    }

    enum DiamondType { Synthetic, Natural }

    bytes32 id;
    string origin;
    DiamondType d_type;
    DiamondProperties properties;

    //TODO increase number of properties
    //Type 1 = Synthetic, Type 2 = Natural
    constructor(uint _size, uint _type, string _origin) public {
        require(_type == 1 || _type == 2, "Type must be 1(Synthetic) or 2(Natural)");
        if(_type == 1) {
            d_type = DiamondType.Synthetic;
        } else if (_type == 2) {
            d_type = DiamondType.Natural;
        }
        origin = _origin;
        properties.size = _size;
        id = sha256(abi.encodePacked(_size, _type));
    }

    function equals(Diamond d) external view returns (bool) {
        return keccak256(encodeDiamond(this)) == keccak256(encodeDiamond(d));
    }

    function encodeDiamond(Diamond d) private view returns (bytes) {
        return abi.encodePacked(
            d.getId(),
            d.getOrigin(),
            d.getType(),
            d.getSize()
        );
    }

    function getId() public view returns (bytes32) {
        return id;
    }

    function getOrigin() public view returns (string) {
        return origin;
    }

    function getType() public view returns (DiamondType) {
        return d_type;
    }

    function getSize() public view returns (uint) {
        return properties.size;
    }
    
}

contract DiamondTracker {
    mapping(bytes32 => address) owners;
    Diamond[] diamonds;

    function add(Diamond diamond, address owner) public returns (bool) {
        
    }
}