import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import { getMeetups, getMeals, setError } from '../actions/meetups';

class MeetupListing extends Component {
  static propTypes = {
    Layout: PropTypes.func.isRequired,
    meetups: PropTypes.shape({
      loading: PropTypes.bool.isRequired,
      error: PropTypes.string,
      meetups: PropTypes.arrayOf(PropTypes.shape()).isRequired,
    }).isRequired,
    match: PropTypes.shape({
      params: PropTypes.shape({}),
    }),
    getMeetups: PropTypes.func.isRequired,
    getMeals: PropTypes.func.isRequired,
    setError: PropTypes.func.isRequired,
  }

  static defaultProps = {
    match: null,
  }

  componentDidMount = () => this.fetchMeetups();

  /**
    * Fetch Data from API, saving to Redux
    */
  fetchMeetups = () => {
    return this.props.getMeetups()
      .then(() => this.props.getMeals())
      .catch((err) => {
        console.log(`Error: ${err}`);
        return this.props.setError(err);
      });
  }

  render = () => {
    const { Layout, meetups, match } = this.props;
    const id = (match && match.params && match.params.id) ? match.params.id : null;

    return (
      <Layout
        meetupId={id}
        error={meetups.error}
        loading={meetups.loading}
        meetups={meetups.meetups}
        reFetch={() => this.fetchMeetups()}
      />
    );
  }
}

const mapStateToProps = state => ({
  meetups: state.meetups || {},
});

const mapDispatchToProps = {
  getMeetups,
  getMeals,
  setError,
};

export default connect(mapStateToProps, mapDispatchToProps)(MeetupListing);
