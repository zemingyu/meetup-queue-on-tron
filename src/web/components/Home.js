import React, {Component} from 'react';
import { Row, Col, Jumbotron } from 'reactstrap';
import web3 from "../web3";
import meetupContract from "../../contracts/meetup";
import PropTypes from "prop-types";
import {Link, withRouter} from "react-router-dom";

class Home extends Component {
  static propTypes = {
    address: PropTypes.string,
    balance: PropTypes.number
  }

  constructor(props) {
    super(props);

    this.state = { address: null, balance: 0 };
  }

  async componentDidMount() {

    try {
      //console.log(meetupContract.options.address);
      const balance = await web3.eth.getBalance(meetupContract.options.address);
      this.setState({address: meetupContract.options.address, balance: balance});

      //console.log("balance:" + balance);
      // const balance = simpleStorage.methods.get.call();
      //const organiserAddress = await meetupContract.methods.organiserAddress().call();
      //console.log("organiserAddress:" + organiserAddress);
      //const totalSupply = await meetupContract.methods.totalSupply().call();
      //console.log('totalSupply: ' + totalSupply);

    }catch(e){
      console.log(e)
    }

  }

  render() {

  return (
    <div>
    <Row>
    <Col xs="12">
      <h5>Account Details: </h5>
    <p className="lead">This contract address is {this.state.address}<br/>Balance is {this.state.balance}</p>
    </Col>
    </Row>
      <Row>
        <Jumbotron className="bg-primary text-white">
          <h1>Find a Meetup</h1>
          <p className="lead">For when you're looking to build 'the next big thing', dummy .</p>
          <p>dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy .</p>
        </Jumbotron>
      </Row>
      <Row className="pt-5">
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-map" /> All meetups</h3>
          <p>React Router is used to handle all web-side routing.</p>
          <p>
            <Link to="/meetups" className="btn btn-primary">
              All Meetups
            </Link>
          </p>
        </Col>
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-fire" /> My meetups</h3>
          <p>Firebase is all ready to go with examples on how to read/write data to/from Firebase.</p>
          <p>
          <Link to="/meetups" className="btn btn-primary">
            My Meetups
          </Link>
          </p>
        </Col>
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-organization" /> I'm going</h3>
          <p>State management the 'clean way' via Redux is setup with examples - woohoo!</p>
          <p>
            <Link to="/meetups" className="btn btn-primary">
              Going Meetups
            </Link>
          </p>
        </Col>
      </Row>
      <Row className="pt-md-5 pb-5">
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-layers" /> My Meetups & suggestions</h3>
          <p>Persist the data stored in Redux for faster load times without needing to hit the server each page load.</p>
          <p>
            <Link to="/meetups" className="btn btn-primary">
                My Meetups & suggestions
            </Link>
          </p>
        </Col>
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-drop" /> Attended Meetups</h3>
          <p>Webpack, SCSS, Bootstrap and ReactStrap - ready at your fingertips.</p>
          <p>
            <Link to="/meetups" className="btn btn-primary">
                Attended Meetups
            </Link>
          </p>
        </Col>
        <Col xs="12" md="4" className="pt-3 pt-md-0">
          <h3><i className="icon-user-following" />Local Meetups</h3>
          <p>Most apps need user authentication. This one comes ready to go with Firebase Auth - but you can easily change that within the `/actions/member.js`</p>
          <p>
            <Link to="/meetups" className="btn btn-primary">
                Local Meetups
            </Link>
          </p>
        </Col>
      </Row>
    </div>
  );
  }

}

export default withRouter(Home);
