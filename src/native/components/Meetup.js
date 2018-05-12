import React from 'react';
import PropTypes from 'prop-types';
import { Image } from 'react-native';
import { Container, Content, Card, CardItem, Body, H3, List, ListItem, Text } from 'native-base';
import ErrorMessages from '../../constants/errors';
import Error from './Error';
import Spacer from './Spacer';

const MeetupView = ({
  error,
  meetups,
  meetupId,
}) => {
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
    <ListItem key={item} rightIcon={{ style: { opacity: 0 } }}>
      <Text>{item}</Text>
    </ListItem>
  ));

  // Build Method listing
  const method = meetup.method.map(item => (
    <ListItem key={item} rightIcon={{ style: { opacity: 0 } }}>
      <Text>{item}</Text>
    </ListItem>
  ));

  return (
    <Container>
      <Content padder>
        <Image source={{ uri: meetup.image }} style={{ height: 100, width: null, flex: 1 }} />

        <Spacer size={25} />
        <H3>{meetup.title}</H3>
        <Text>by {meetup.author}</Text>
        <Spacer size={15} />

        <Card>
          <CardItem header bordered>
            <Text>About this Meetup</Text>
          </CardItem>
          <CardItem>
            <Body>
              <Text>{meetup.body}</Text>
            </Body>
          </CardItem>
        </Card>

        <Card>
          <CardItem header bordered>
            <Text>Attenders</Text>
          </CardItem>
          <CardItem>
            <Content>
              <List>
                {ingredients}
              </List>
            </Content>
          </CardItem>
        </Card>

        <Card>
          <CardItem header bordered>
            <Text>Method</Text>
          </CardItem>
          <CardItem>
            <List>
              {method}
            </List>
          </CardItem>
        </Card>

        <Spacer size={20} />
      </Content>
    </Container>
  );
};

MeetupView.propTypes = {
  error: PropTypes.string,
  meetupId: PropTypes.string.isRequired,
  meetups: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

MeetupView.defaultProps = {
  error: null,
};

export default MeetupView;
