import web3 from './web3obj';
import React, { Component } from 'react';
import { Header, Table } from 'semantic-ui-react'


class Sys extends Component {
	constructor(props) {
		super(props);
		this.state = {data: false};
	}


	componentDidMount() {
		var t = {
			isConnected: (web3.isConnected()? 'Yes':'No'),
			isMetaMask: (web3.currentProvider.isMetaMask? 'Yes':'No')
		}

		this.setState({data: t});
	}

  render() {
		if (this.state.data) {
			return (
	 <Table>
    <Table.Header>
      <Table.Row>
        <Table.HeaderCell>Status</Table.HeaderCell>
        <Table.HeaderCell>Y/N</Table.HeaderCell>
      </Table.Row>
    </Table.Header>

    <Table.Body>
      <Table.Row >
        <Table.Cell >isConnected</Table.Cell>
        <Table.Cell >{this.state.data.isConnected}</Table.Cell>
      </Table.Row>
      <Table.Row >
        <Table.Cell >isMetaMask</Table.Cell>
        <Table.Cell >{this.state.data.isMetaMask}</Table.Cell>
      </Table.Row>

    </Table.Body>
  </Table>

			)
		}

		return (
			<Header as='h3' textAlign='center'>
			Loading ....
			</Header>
		);

  }

}

export default Sys;


