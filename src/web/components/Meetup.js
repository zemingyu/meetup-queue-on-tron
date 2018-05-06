import React from 'react';
import PropTypes from 'prop-types';
import {
  Row,
  Col,
  Card,
  CardText,
  CardBody,
  CardHeader,
  ListGroup,
  ListGroupItem,
} from 'reactstrap';
import { Link } from 'react-router-dom';
import ErrorMessages from '../../constants/errors';
import Loading from './Loading';
import Error from './Error';

const MeetupView = ({
  error,
  loading,
  meetups,
  meetupId,
}) => {
  // Loading
  if (loading) return <Loading />;

  // Error
  if (error) return <Error content={error} />;

  // Get this Meetup from all meetups
  let meetup = null;
  if (meetupId && meetups) {
    meetup = meetups.find(item => parseInt(item.id, 10) === parseInt(meetupId, 10));
  }

  // Meetup not found
  if (!meetup) return <Error content={ErrorMessages.meetup404} />;

  // Build Ingredients listing
  const ingredients = meetup.ingredients.map(item => (
    <ListGroupItem key={`${item}`}>{item}</ListGroupItem>
  ));

  // Build Method listing
  const method = meetup.method.map(item => (
    <ListGroupItem key={`${item}`}>{item}</ListGroupItem>
  ));

  return (
    <div>
      <Row>
        <Col sm="12">
          <h1>{meetup.title}</h1>
          <p>by {meetup.author}</p>
        </Col>
      </Row>
      <Row>
        <Col lg="4" className="meetup-view-card">
          <Card>
            <CardHeader>About this Meetup</CardHeader>
            <CardBody>
              <CardText>{meetup.body}</CardText>
            </CardBody>
          </Card>
        </Col>
        <Col lg="4" className="meetup-view-card">
          <Card>
            <CardHeader>Hosts</CardHeader>
            <ListGroup className="list-group-flush">
              {ingredients}
            </ListGroup>
          </Card>
        </Col>
        <Col lg="4" className="meetup-view-card">
          <Card>
            <CardHeader>Attenders</CardHeader>
            <ListGroup className="list-group-flush">
              {method}
            </ListGroup>
          </Card>
        </Col>
      </Row>
      <Row className="pb-3">
        <Col sm="12">
          <Link className="btn btn-secondary" to="/meetups"><i className="icon-arrow-left" /> Back</Link>
        </Col>
      </Row>
    </div>
  );
};

MeetupView.propTypes = {
  error: PropTypes.string,
  loading: PropTypes.bool.isRequired,
  meetupId: PropTypes.string.isRequired,
  meetups: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

MeetupView.defaultProps = {
  error: null,
};

export default MeetupView;
