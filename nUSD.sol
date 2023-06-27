
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract nUSD is ERC20{

    address public owner;
    uint256 public exchangeRate;

    mapping (address => uint256) public balances;

    constructor() ERC20("nUSD","nUSD")
    {
        owner = msg.sender;
        exchangeRate = 2; //  Intial Exchange Rate Of 1 ETH = 2nUSD
    }

    function deposit() external payable {
        uint256 nUSDAmount = (msg.value * exchangeRate)/2;
        balances[msg.sender] = nUSDAmount;
        _mint(msg.sender, nUSDAmount);
    }

      function updateExchangeRate(uint256 newRate) external {
        require(msg.sender == owner, "Only the owner can update the exchange rate");
        exchangeRate = newRate;
    }

     function redeem(uint256 nUSDAmount) external {
        require(balanceOf(msg.sender) >= nUSDAmount, "Insufficient nUSD balance");

        uint256 ethAmount = (nUSDAmount * 2) / exchangeRate;
        _burn(msg.sender, nUSDAmount);
        payable(msg.sender).transfer(ethAmount);
    }

}
