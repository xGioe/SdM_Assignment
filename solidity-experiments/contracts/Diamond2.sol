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
    // mapping(bytes32 => address) owners;
    //the mapping between each owner (address) and the diamons possessed
    mapping (address => Diamond[]) public owners;

    Diamond[] diamondsList;

    constructor(address[] _certificate_authorities) public {
        certificate_authorities = _certificate_authorities;
    }

    //TODO increase number of properties
    //Type 1 = Synthetic, Type 2 = Natural
    function register(address _owner, uint _type, string _origin, uint _size) external returns (bytes32) {
        require(isAllowed(msg.sender), "You are not allowed to call register()");
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

        if(!addDiamond(d, _owner))
            revert("Diamond already exists");

        return d.id;
    }

    // Returns the list of registered diamonds
    // function getDiamondsList() external view returns (Diamond[]){
    //   return diamondsList;
    // }

    function getDiamondByIndex(uint index) external view returns (bytes32, string, DiamondType, uint) {
        return (
            diamondsList[index].id,
            diamondsList[index].origin,
            diamondsList[index].d_type,
            diamondsList[index].properties.size
        );
    }

    function getDiamondById(bytes32 id) external view returns (bytes32, string, DiamondType, uint) {
      for(uint i = 0; i < diamondsList.length; i++) {
          if(diamondsList[i].id == id)
          return (
              diamondsList[i].id,
              diamondsList[i].origin,
              diamondsList[i].d_type,
              diamondsList[i].properties.size
          );
      }
    }

    function getNumberOfDiamonds() external view returns (uint) {
        return diamondsList.length;
    }

    function equals(Diamond d1, Diamond d2) internal pure returns (bool) {
        return keccak256(encodeDiamond(d1)) == keccak256(encodeDiamond(d2));
    }

    function addDiamond(Diamond d, address owner) private returns (bool) {
        //TODO I think this can be optimised
        for(uint i = 0; i < diamondsList.length; i++) {
            if(equals(d, diamondsList[i]))
                return false;
        }

        // NOTE: we expect that if diamond is already in diamondsList then it has a owner
        // might be a security issue of non-owenership
        diamondsList.push(d);
        // owners[d.id] = owner;

        owners[owner].push(d);
        return true;
    }

    function isAllowed(address user) private view returns (bool) {
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
