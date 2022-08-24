// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// gas...
error NotOwner();

contract FundMe {
  using PriceConverter for uint256;
  // constant can reduce gas limit(~10%)
  uint256 public constant MINIMUM_USD = 50 * 1e18;

  AggregatorV3Interface public priceFeed;

  address[] public funders;
  mapping(address => uint256) public addressToAmountFunded;
  // immutable can reduce gas limit(~10%)
  address public immutable owner;

  constructor(address priceFeedAddress) {
    owner = msg.sender;
    priceFeed = AggregatorV3Interface(priceFeedAddress);
  }

  function fund() public payable {
    // msg.value is first parameter of library
    require(
      msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
      "Didn't send enough!"
    );
    funders.push(msg.sender);
    addressToAmountFunded[msg.sender] = msg.value;
  }

  function withdraw() public onlyOwner {
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      addressToAmountFunded[funder] = 0;
    }
    // reset the array
    funders = new address[](0);

    // actually withdraw the funds
    // transfer
    // 2300 gas capped
    //payable(msg.sender).transfer(address(this).balance);
    // send
    //bool sendSuccess = payable(msg.sender).send(address(this).balance);
    //require(sendSuccess, "Send failed");
    // call - low level code, returnData...gas efficiency
    // has no capped gas
    // recommended way!
    (bool callSuccess, ) = payable(msg.sender).call{
      value: address(this).balance
    }("");
    require(callSuccess, "Call failed");
  }

  modifier onlyOwner() {
    // message is not gas efficiency
    // require(msg.sender == i_owner, "Sender is not owner!");
    if (msg.sender != owner) {
      revert NotOwner();
    }
    _;
  }

  receive() external payable {
    // automatically route to fund function
    fund();
  }

  fallback() external payable {
    fund();
  }
}
