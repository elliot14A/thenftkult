//SPDX-License-Identifier: MIT

pragma solidity ^0.8.x;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";


contract FragmentsVault is ERC20Upgradeable, ERC721HolderUpgradeable {
    using Address for address;
    
    constructor() {}

    /// @notice the ERC721 token address of the vault's token
    address public token;

    /// @notice the ERC721 token ID of the vault's token 
    uint256 public id;
    
    /// @notice address of the curator
    address payable public curator;

    /// @notice curator's fee
    uint256 public fee;

    function initialize(
        address _curator,
        address _token,
        uint256 _id,
        uint256 _supply,
        uint256 _listPrice,
        uint256 _fee,
        string memory _name,
        string memory _symbol

    ) external initializer {
        // initialize inherited contracts
        __ERC20_init(_name, _symbol);
        __ERC721Holder_init();

        // set storage variables
        token = _token;
        id = _id;
        curator = payable(_curator);
        fee = _fee;

    }
}