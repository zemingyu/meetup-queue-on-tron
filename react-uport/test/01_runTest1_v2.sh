#!/bin/sh

# Assign filename to the $CONTRACT environment variable
CONTRACT=Workshop.sol

# Copy the $CONTRACT from the ../contracts/ subdirectory into the ../test/ subdirectory
cp ../contracts/$CONTRACT .

# Compile the Solidity file and save the ABI and bytecode into Workshop.js
echo "var workshopOutput=`solc --optimize --pretty-json --combined-json abi,bin,interface $CONTRACT`;" > Workshop.js

#geth --datadir ./testchain attach << EOF | grep "RESULT: " | sed "s/RESULT: //"
geth --datadir ./testchain attach << EOF

// Load the generated ABI and bytecode
loadScript("Workshop.js");

// Display some information
console.log("RESULT: " + JSON.stringify(workshopOutput));

# Extract the contract ABI
var workshopAbi = JSON.parse(workshopOutput.contracts["$CONTRACT:Workshop"].abi);

# Extract the contract bytecode
var workshopBin = "0x" + workshopOutput.contracts["$CONTRACT:Workshop"].bin;

# Display both values
console.log("RESULT: workshopAbi=" + JSON.stringify(workshopAbi));
console.log("RESULT: workshopBin=" + JSON.stringify(workshopBin));


// -----------------------------------------------------------------------------
var deployWorkshopMessage = "Deploy Workshop";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + deployWorkshopMessage + " ---");
var workshopContract = web3.eth.contract(workshopAbi);
console.log("RESULT: " + JSON.stringify(workshopContract));

var workshopTx = null;
var workshopAddress = null;
var workshop = workshopContract.new({from: eth.accounts[0], data: workshopBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        workshopTx = contract.transactionHash;
      } else {
        workshopAddress = contract.address;
        console.log("DATA: workshopAddress=" + workshopAddress);
      }
    }
  }
);

// Wait until there are no pending transactions in the txpool
while (txpool.status.pending > 0) {
}

// Display the values of var1 and var2
console.log("RESULT: var1=" + workshop.var1());
console.log("RESULT: var2=" + workshop.var2());
console.log("RESULT: ");


EOF