//SPDX-License-Identifier: MIT

pragma solidity ^0.8.x;

contract Proxy {
    // address of logic contract
    address public immutable logic;

    constructor(
        address _logic,
        bytes memory _initializationCalldata
    ) {
        logic = _logic;
        (bool _ok, bytes memory returnData) = _logic.delegatecall(_initializationCalldata);
        require(_ok, string(returnData));
    }

    fallback() external payable {
        address _impl = logic;

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()

            switch result 
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }

    receive() external payable {}
}
