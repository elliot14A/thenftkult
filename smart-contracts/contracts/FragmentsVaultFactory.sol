//SPDX-License-Identifier: MIT

pragma solidity ^0.8.x;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./FragmentsVault.sol";
import "./Proxy.sol";

contract FragmentsVaultFactory is Ownable, ReentrancyGuard {
    /// @notice the number of ERC721 vaults
    uint256 public vaultCount;

    /// @notice the mapping vault number to vault contract
    mapping(uint256 => address) public vaults;

    /// @notice the FragmentsVault logic contract
    address public immutable logic;

    event Mint(address indexed token, uint256 id, uint256 price, address vault, uint256 vault256);

    constructor() {
        logic = address(new FragmentsVault());
    }

    function mint(
        string memory _name, 
        string memory _symbol,
        address _token,
        uint256 _id,
        uint256 _listPrice,
        uint256 _supply,
        uint256 _fee
    ) external nonReentrant returns(uint256)
     {
         bytes memory _initializationCalldata = abi.encodeWithSignature(
             "initialize(address,address,uint256,uint256,uint256,uint256,string,string)", 
            msg.sender,
          _token,
          _id,
          _supply,
          _listPrice,
          _fee,
          _name,
          _symbol);

          address vault = address(new Proxy(logic, _initializationCalldata));

          emit Mint(_token, _id, _listPrice, vault, vaultCount);

          IERC721(_token).safeTransferFrom(msg.sender, vault, _id);

          vaults[vaultCount] = vault;
          vaultCount++;

          return vaultCount - 1;
    }
}