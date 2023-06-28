// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract nUSD is ERC20 {
    address public owner;
    AggregatorV3Interface internal priceFeed;

    constructor(address _priceFeed) ERC20("nUSD", "nUSD") {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function deposit(uint256 _amount) external payable {
        uint256 ethAmount = _amount;
        require(ethAmount > 0, "ETH amount should be greater than 0");

        // Get the ETH to USD exchange rate from the Chainlink Oracle
        (, int256 price, , , ) = priceFeed.latestRoundData();

        uint256 nUSDAmount = (ethAmount * uint256(price)) / 2;
        _mint(msg.sender, nUSDAmount);
    }

    function redeem(uint256 nUSDAmount) external {
        require(nUSDAmount > 0, "nUSD amount should be greater than 0");
        require(balanceOf(msg.sender) >= nUSDAmount, "Insufficient nUSD balance");

        // Get the ETH to USD exchange rate from the Chainlink Oracle
        (, int256 price, , , ) = priceFeed.latestRoundData();

        uint256 ethAmount = (nUSDAmount * 2) / uint256(price);
        require(address(this).balance >= ethAmount, "Insufficient ETH balance");

        _burn(msg.sender, nUSDAmount);
        payable(msg.sender).transfer(ethAmount);
    }

    function totalSupply() public view virtual override returns (uint256) {
        return super.totalSupply();
    }
}
