#!/bin/sh

# Assign filename to the $CONTRACT environment variable
CONTRACT=MeetupBase_Simple.sol

# Copy the $CONTRACT from the ../contracts/ subdirectory into the ../test/ subdirectory
cp ../contracts/$CONTRACT .

# Compile the Solidity file and save the ABI and bytecode into MeetupBase.js
echo "var meetupBaseOutput=`solc --optimize --pretty-json --combined-json abi,bin,interface $CONTRACT`;" > MeetupBase.js

# geth --datadir ./testchain attach << EOF | grep "RESULT: " | sed "s/RESULT: //"
geth --datadir ./testchain attach << EOF

// Load the generated ABI and bytecode
loadScript("MeetupBase.js");

// Load accounts with eth
loadScript("functions.js");


unlockAccounts("");


// Display some information
// console.log("RESULT: " + JSON.stringify(meetupBaseOutput));

// Extract the contract ABI
var meetupBaseAbi = JSON.parse(meetupBaseOutput.contracts["$CONTRACT:MeetupBase"].abi);

// Extract the contract bytecode
var meetupBaseBin = "0x" + meetupBaseOutput.contracts["$CONTRACT:MeetupBase"].bin;

// Display both values
console.log("RESULT: meetupBaseAbi=" + JSON.stringify(meetupBaseAbi));
console.log("RESULT: meetupBaseBin=" + JSON.stringify(meetupBaseBin));


// -----------------------------------------------------------------------------
var deployMeetupBaseMessage = "Deploy MeetupBase";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + deployMeetupBaseMessage + " ---");
var meetupBaseContract = web3.eth.contract(meetupBaseAbi);
console.log("RESULT: " + JSON.stringify(meetupBaseContract));

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
var registerUserMessage = "Register users";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + registerUserMessage + " ---");
console.log("RESULT: users(0)=" + meetupBase.getUser(0));
console.log("RESULT: users(1)=" + meetupBase.getUser(1));

console.log("RESULT: users(0)=" + meetupBase.users(0));
console.log("RESULT: users(1)=" + meetupBase.users(1));

meetupBase.createUser(web3.fromAscii("A"), {from: eth.accounts[0], gas:700000});
meetupBase.createUser(web3.fromAscii("B"), {from: eth.accounts[1], gas:700000});
//meetupBase.createUser("B", {from: eth.accounts[1], gas:4000000});
//meetupBase.createUser("C", {from: eth.accounts[2], gas:4000000});
//meetupBase.createUser("D", {from: eth.accounts[3], gas:4000000});
//meetupBase.createUser("E", {from: eth.accounts[4], gas:4000000});

console.log("RESULT: users(0)=" + meetupBase.getUser(0));
console.log("RESULT: users(1)=" + meetupBase.getUser(1));

console.log("RESULT: users(0)=" + meetupBase.users(0));
console.log("RESULT: users(1)=" + meetupBase.users(1));



// -----------------------------------------------------------------------------
var checkMeetupMessage = "Check meetups";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + checkMeetupMessage + " ---");
console.log("RESULT: meetups.length=" + meetupBase.getMeetupCount())


















// Display the values of var1 and var2
//console.log("RESULT: var1=" + meetupBase.var1());
//console.log("RESULT: var2=" + meetupBase.var2());
//console.log("RESULT: ");

// -----------------------------------------------------------------------------
var modifyVarssMessage = "Modifying Vars";
// -----------------------------------------------------------------------------
//console.log("RESULT: --- " + modifyVarssMessage + " ---");
//var modifyVars1Tx = MeetupBase.setVar1("Hello, World!4567890123456789012345", {from: eth.accounts[0], gas: 100000});
//var modifyVars2Tx = MeetupBase.setVar2(456, {from: eth.accounts[0], gas: 100000});
//while (txpool.status.pending > 0) {
//}

// Display the transaction status
//console.log("RESULT: modifyVars1Tx=" + JSON.stringify(eth.getTransaction(modifyVars1Tx)));
//console.log("RESULT: modifyVars1TxReceipt=" + JSON.stringify(eth.getTransactionReceipt(modifyVars1Tx)));
//console.log("RESULT: modifyVars2Tx=" + JSON.stringify(eth.getTransaction(modifyVars2Tx)));
//console.log("RESULT: modifyVars2TxReceipt=" + JSON.stringify(eth.getTransactionReceipt(modifyVars2Tx)));

// Display the new values of var1 and var2
//console.log("RESULT: var1=" + MeetupBase.var1());
//console.log("RESULT: var2=" + MeetupBase.var2());
//console.log("RESULT: ");


//printBalances();
//eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(1234, "ether")})

EOF