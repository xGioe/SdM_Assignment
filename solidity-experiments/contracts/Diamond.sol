pragma solidity ^0.4.22;
//pragma experimental ABIEncoderV2;

contract DiamondTracker {

    struct Diamond {
        bytes32 id;
        string origin;
        DiamondType d_type;
        DiamondProperties properties;
    }

    struct DiamondProperties {
        uint size;
        //TODO rest of the properties
    }

    enum DiamondType { Synthetic, Natural }

    address[] certificate_authorities;
    mapping(bytes32 => address) owners;
    Diamond[] diamonds;

    //TODO increase number of properties
    //Type 1 = Synthetic, Type 2 = Natural
    function register(address _owner, uint _type, string _origin, uint _size) public returns (bytes32) {
        //TODO Verify if the caller is a certificate authority
        require(_type == 1 || _type == 2, "Type must be 1(Synthetic) or 2(Natural)");

        Diamond memory d;
        if(_type == 1) {
            d.d_type = DiamondType.Synthetic;
        } else if (_type == 2) {
            d.d_type = DiamondType.Natural;
        }
        d.origin = _origin;
        d.properties.size = _size;
        d.id = sha256(abi.encodePacked(_size, _type));

        diamonds.push(d);
        owners[d.id] = _owner;
    }

    function equals(Diamond d1, Diamond d2) internal pure returns (bool) {
        return keccak256(encodeDiamond(d1)) == keccak256(encodeDiamond(d2));
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