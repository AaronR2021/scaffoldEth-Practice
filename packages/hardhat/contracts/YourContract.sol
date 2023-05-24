pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract YourContract {

  //address how much have they sent
  address public owner;
  mapping(address=>uint256) public contrabution;
  uint public count ;

  constructor() {
      owner = msg.sender;
  }

  //get balance
  function getBalance() public view returns(uint256) {
    return address(this).balance;
  }
  //withdraw
  function withdraw() public {
    require(msg.sender==owner,"you are not the owenr");
    payable(owner).transfer(address(this).balance);
  }
  //can recieve
  receive() external payable {
    require(msg.value<0,"Please do not send money directly to the contract");
  }

  function donate() public payable{
    count+=1;
    contrabution[msg.sender]=msg.value;
  }
}
