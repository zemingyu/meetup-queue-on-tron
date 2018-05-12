module.exports = {
	// See <http://truffleframework.com/docs/advanced/configuration>
	// to customize your Truffle configuration!
  // contracts_build_directory: "../src/contracts/json",
	networks: {
		development: {
			host: "localhost",
			port: 7545,
			network_id: "*" // Match any network id
		},
		docker_dev: { //localhost:8545
			host: "testrpc",
			port: 8545,
			network_id: "*"
		}
	}

};
