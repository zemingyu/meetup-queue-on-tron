#!/bin/sh

# Assign filename to the $CONTRACT environment variable
CONTRACT=MeetupBase_Simple.sol

# Copy the $CONTRACT from the ../contracts/ subdirectory into the ../test/ subdirectory
cp ../contracts/$CONTRACT .

# Compile the Solidity file and save the ABI and bytecode into MeetupBase.js
echo "var meetupBaseOutput=`solc --optimize --pretty-json --combined-json abi,bin,interface $CONTRACT`;" > MeetupBase.js

geth --datadir ./testchain attach << EOF | grep -a "RESULT: " | sed "s/RESULT: //" | tee test1output.txt
//geth --datadir ./testchain attach << EOF

// Load the generated ABI and bytecode
loadScript("MeetupBase.js");

// Load accounts with eth
loadScript("functions.js");


unlockAccounts("");


// Display some information
//console.log("RESULT: " + JSON.stringify(meetupBaseOutput));

// Extract the contract ABI
var meetupBaseAbi = JSON.parse(meetupBaseOutput.contracts["$CONTRACT:MeetupBase"].abi);

// Extract the contract bytecode
var meetupBaseBin = "0x" + meetupBaseOutput.contracts["$CONTRACT:MeetupBase"].bin;

// Display both values
//console.log("RESULT: meetupBaseAbi=" + JSON.stringify(meetupBaseAbi));
//console.log("RESULT: meetupBaseBin=" + JSON.stringify(meetupBaseBin));


// -----------------------------------------------------------------------------
var deployMeetupBaseMessage = "Deploy MeetupBase";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + deployMeetupBaseMessage + " ---");
var meetupBaseContract = web3.eth.contract(meetupBaseAbi);
//console.log("RESULT: " + JSON.stringify(meetupBaseContract));

var meetupBaseTx = null;
var meetupBaseAddress = null;
var meetupBase = meetupBaseContract.new({from: eth.accounts[0], data: meetupBaseBin, gas: 4000000},
  function(e, contract) {
    console.log(e);
    if (!e) {
      if (!contract.address) {
        meetupBaseTx = contract.transactionHash;
      } else {
        meetupBaseAddress = contract.address;
        console.log("DATA: meetupBaseAddress=" + meetupBaseAddress);
      }
    }
  }
);

// Wait until there are no pending transactions in the txpool
while (txpool.status.pending > 0) {
}

// console.log("RESULT: meetupBase=" + JSON.stringify(meetupBase));
// console.log("RESULT: meetupBase=" + JSON.stringify(eth.getTransaction(meetupBaseTx)));

//console.log("RESULT: balance: " + web3.fromWei(eth.getBalance(eth.accounts[0]), "ether") + " ETH");
//console.log("RESULT: balance: " + web3.fromWei(eth.getBalance(eth.accounts[1]), "ether") + " ETH");


// -----------------------------------------------------------------------------
var registerUserMessage = "Create users";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + registerUserMessage + " ---");
console.log("RESULT: Before creating users: users.length=" + meetupBase.getUserCount());

meetupBase.createUser(web3.fromAscii("Organiser"), {from: eth.accounts[0], gas:700000});
while (txpool.status.pending > 0) {
}
meetupBase.createUser(web3.fromAscii("Assistant"), {from: eth.accounts[1], gas:700000});
while (txpool.status.pending > 0) {
}
meetupBase.createUser(web3.fromAscii("Member1"), {from: eth.accounts[2], gas:700000});
while (txpool.status.pending > 0) {
}
meetupBase.createUser(web3.fromAscii("Member2"), {from: eth.accounts[3], gas:700000});
while (txpool.status.pending > 0) {
}
meetupBase.createUser(web3.fromAscii("Member3"), {from: eth.accounts[4], gas:700000});
while (txpool.status.pending > 0) {
}

console.log("RESULT: After creating users: users.length=" + meetupBase.getUserCount());


for (i = 0; i < 5; i++) {   
  console.log("RESULT: " + i + " | Name: "+web3.toAscii(meetupBase.users(i)[2])+
            " | Creation Time: " + timestampToStr(meetupBase.users(i)[0])  +
            " | Address: " + meetupBase.users(i)[1]);
}


// -----------------------------------------------------------------------------
var testDatesMessage = "Test dates";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + testDatesMessage + " ---");

date = 1525696722;
timestampToStr(date);
dateTimeStr = "Wed, 01 Aug 2018 18:00:00 AEST";
strToTimestamp(dateTimeStr);


// -----------------------------------------------------------------------------
var checkMeetupMessage = "Create meetups";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + checkMeetupMessage + " ---");
console.log("RESULT: Before creating meetups: meetups.length=" + meetupBase.getMeetupCount());

meetupBase.createMeetup(strToTimestamp(dateTimeStr), 100, "Smart contract 101", [3, 4], {from: eth.accounts[0], gas: 4000000});

while (txpool.status.pending > 0) {
}

console.log("RESULT: After creating meetups: meetups.length=" + meetupBase.getMeetupCount());

var i = 0;
console.log("RESULT: Meetup #" + (i+1) + 
          " | Creation Time: " + timestampToStr(meetupBase.getMeetup(i)[0])  +
          " | Start Time: " + timestampToStr(meetupBase.getMeetup(i)[1])  +
          " | Max Capacity: " + meetupBase.getMeetup(i)[2] + 
          " | Topic: " + meetupBase.getMeetup(i)[3] + 
          " | Presenter IDs: " + meetupBase.getMeetup(i)[4] +
          " | Registered User IDs: " + meetupBase.getMeetup(i)[5]);


//printBalances();
//eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(1234, "ether")})


EOF


