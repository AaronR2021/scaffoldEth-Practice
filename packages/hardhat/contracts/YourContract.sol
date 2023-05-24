pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract YourContract {
  //multisig wallet
  //TODO:
    /*
      - enter number of people you want in this wallet to pass
      - enter number of yes's 
      - min amount to enter into the pool
      _____________checks_________________
      - has entered the amount in the pool
      ____________________________________
      - request to spend from the pool (contract to your account[mapping])
      - read from the requestArray
      - number of requestsTotal
      - action on a given requestArray 
      _____________________________________
      - withdraw what you have with you
    
    */
   struct FriendList{
    address _addr;
    uint accepted;
    uint rejected;
    string text;
    bool approved;
   }
   FriendList[] public statePerRequest;


//------------------------------------
   address public owner;
   uint256 public maxFriendsAccept;
   address[] public friends;
   uint public maxAccept;
   uint public poolAmount;
   uint256 public count;
   mapping(address=>bool) public presentInGroupList;
   mapping(address=>mapping(uint=>bool)) voted;


   constructor(){  
      owner=msg.sender;
      friends.push(msg.sender);
      presentInGroupList[msg.sender]=true;

   }

  modifier onlyOwner(){
        require(msg.sender==owner,'only owner has access');
        _;
   }
  modifier maxFriend(uint256 _num){
        require(_num<friends.length,'the number should be less than the total number of participants');
        _;
   }

  modifier partOfGroup(){
        require(presentInGroupList[msg.sender],"You are not part of the group");
        _;
   }

  modifier NotpartOfGroup(address _addr){
        require(!presentInGroupList[_addr],"You are already part of the group");
        _;
   }


  modifier votePerAddress(uint _count){
      require(voted[msg.sender][_count]==false,'you have aready voted');
        _;
   }

  modifier approvedTx(uint _count){
    FriendList storage vote = statePerRequest[_count];
    require(vote.approved==true,'not yet accepted by all members');
        _;
   }
  modifier trx(uint _count) {
    FriendList storage vote = statePerRequest[_count];
    if(vote.accepted>=maxFriendsAccept){
      vote.approved=true;
    }
    _;
  }

    //!add the addresses you want to be a part of multisig
   function addFriend(address _friend) public onlyOwner NotpartOfGroup(_friend){
    friends.push(_friend);
    presentInGroupList[_friend]=true;

   }

    //!add max count of addresses that have to accept to pass. 
   function maxFriendCount(uint256 _count) public onlyOwner maxFriend(_count){
    maxFriendsAccept=_count;
   }

   //!participant sends a request
   function setRequest(string memory _text) public partOfGroup{
    statePerRequest.push(
      FriendList({
        _addr:msg.sender,
        accepted:0,
        rejected:0,
        text:_text,
        approved:false
       })
    );
    //owner approved
    voted[msg.sender][count]=true;
    FriendList storage vote = statePerRequest[count];
    vote.accepted+=1;
    count+=1;

   }

  //!approve vote
  function voteApprove(uint _count)public partOfGroup votePerAddress(_count) trx(_count) {
    voted[msg.sender][_count]=true;
    FriendList storage vote = statePerRequest[_count];
    vote.accepted+=1;
  }

  //!reject vote
  function voteReject(uint _count)public partOfGroup votePerAddress(_count) trx(_count) {
    voted[msg.sender][_count]=true;
    FriendList storage vote = statePerRequest[_count];
    vote.rejected+=1;
  }

  //!return a value only if struct is approved
  function printText(uint _count) public view approvedTx(_count) returns(string memory) {
    FriendList memory vote = statePerRequest[_count];
    return vote.text;
  }
}
