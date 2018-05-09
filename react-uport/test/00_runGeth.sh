#!/bin/sh

# Remove old blockchain data
rm -f ./testchain/geth/chaindata/*

geth --dev --dev.period 1 --datadir ./testchain console