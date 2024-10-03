// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {Ecommerce} from "./BukShop.sol";
import {IERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract BukShopFactory {
    
    address payable public owner;
    Ecommerce[] public ecomerceContract;
    IERC20 BorderlessToken;
    event EcomerceCreated(address indexed tokenContract ,address indexed owner);

    constructor(address _BorderlessToken) {
        owner = payable(msg.sender);
        BorderlessToken = IERC20(_BorderlessToken);
    }

    function createBukShop(address _borderlessToken) public payable returns (address) {
        Ecommerce new_BukShop = new Ecommerce(_borderlessToken);
        ecomerceContract.push(new_BukShop);
        emit EcomerceCreated(address(new_BukShop), msg.sender);
        return address(new_BukShop);
    }

    fallback() external payable { }
    receive() external payable { }
}