import React from 'react';
import PropTypes from 'prop-types';
import {
  Row,
  Col,
  Card,
  CardImg,
  CardText,
  CardBody,
  CardTitle,
} from 'reactstrap';
import { Link } from 'react-router-dom';
import Error from './Error';

const MeetupListing = ({ error, loading, meetups }) => {
  // Error
  if (error) return <Error content={error} />;

  // Build Cards for Listing
  const cards = meetups.map(item => (
    <Card key={`${item.id}`}>
      <Link to={`/meetup/${item.id}`}>
        <CardImg top src={item.image} alt={item.title} />
      </Link>
      <CardBody>
        <CardTitle>{item.title}</CardTitle>
        <CardText>{item.body}</CardText>
        <Link className="btn btn-primary" to={`/meetup/${item.id}`}>View Details <i className="icon-arrow-right" /></Link>
      </CardBody>
    </Card>
  ));

  // Show Listing
  return (
    <div>
      <Row>
        <Col sm="12">
          <h1>Meetups</h1>
          <p>The following meetups is recommended for you.</p>
        </Col>
      </Row>
      <Row className={loading ? 'content-loading' : ''}>
        <Col sm="12" className="card-columns">
          {cards}
        </Col>
      </Row>
    </div>
  );
};

MeetupListing.propTypes = {
  error: PropTypes.string,
  loading: PropTypes.bool.isRequired,
  meetups: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

MeetupListing.defaultProps = {
  error: null,
};

export default MeetupListing;
