#!/bin/sh

# Assign filename to the $CONTRACT environment variable
CONTRACT=MeetupBase_Simple.sol

# Copy the $CONTRACT from the ../contracts/ subdirectory into the ../test/ subdirectory
cp ../contracts/$CONTRACT .

# Compile the Solidity file and save the ABI and bytecode into MeetupBase.js
echo "var MeetupBaseOutput=`solc --optimize --pretty-json --combined-json abi,bin,interface $CONTRACT`;" > MeetupBase.js

# geth --datadir ./testchain attach << EOF | grep "RESULT: " | sed "s/RESULT: //"
geth --datadir ./testchain attach << EOF

// Load the generated ABI and bytecode
loadScript("MeetupBase.js");

// Load accounts with eth
loadScript("functions.js");


unlockAccounts("");


// Display some information
// console.log("RESULT: " + JSON.stringify(MeetupBaseOutput));

// Extract the contract ABI
var MeetupBaseAbi = JSON.parse(MeetupBaseOutput.contracts["$CONTRACT:MeetupBase"].abi);

// Extract the contract bytecode
var MeetupBaseBin = "0x" + MeetupBaseOutput.contracts["$CONTRACT:MeetupBase"].bin;

// Display both values
// console.log("RESULT: MeetupBaseAbi=" + JSON.stringify(MeetupBaseAbi));
// console.log("RESULT: MeetupBaseBin=" + JSON.stringify(MeetupBaseBin));


// -----------------------------------------------------------------------------
var deployMeetupBaseMessage = "Deploy MeetupBase";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + deployMeetupBaseMessage + " ---");
var MeetupBaseContract = web3.eth.contract(MeetupBaseAbi);
console.log("RESULT: " + JSON.stringify(MeetupBaseContract));

var MeetupBaseTx = null;
var MeetupBaseAddress = null;
var MeetupBase = MeetupBaseContract.new({from: eth.accounts[0], data: MeetupBaseBin, gas: 4000000},
  function(e, contract) {
    console.log(e);
    if (!e) {
      if (!contract.address) {
        MeetupBaseTx = contract.transactionHash;
      } else {
        MeetupBaseAddress = contract.address;
        console.log("DATA: MeetupBaseAddress=" + MeetupBaseAddress);
      }
    }
  }
);

// Wait until there are no pending transactions in the txpool
while (txpool.status.pending > 0) {
}

console.log("RESULT: balance: " + web3.fromWei(eth.getBalance(eth.accounts[0]), "ether") + " ETH");
console.log("RESULT: balance: " + web3.fromWei(eth.getBalance(eth.accounts[1]), "ether") + " ETH");

// -----------------------------------------------------------------------------
var registerUserMessage = "Register users";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + registerUserMessage + " ---");
console.log("RESULT: users(0)=" + MeetupBase.users(0));


// -----------------------------------------------------------------------------
var checkMeetupMessage = "Check meetups";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + checkMeetupMessage + " ---");
console.log("RESULT: meetups.length=" + MeetupBase.getMeetupCount())


















// Display the values of var1 and var2
//console.log("RESULT: var1=" + MeetupBase.var1());
//console.log("RESULT: var2=" + MeetupBase.var2());
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


printBalances();
eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(1234, "ether")})
printBalances();
eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[2], value: web3.toWei(1234, "ether")})
printBalances();

EOF