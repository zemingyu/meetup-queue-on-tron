pragma solidity ^0.4.23;


// Based on https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
contract MeetupAccessControl {

  // The addresses of the accounts (or contracts) that can execute actions within each roles.
  address public organiserAddress;
  address public assistantAddress_1;
  address public assistantAddress_2;
  bool paused = false;

  /// Access modifier for organiser-only functionality
  modifier onlyOrganiser() {
      require(msg.sender == organiserAddress);
      _;
  }

  /// Access modifier for organiser-only functionality
  modifier onlyAssistant() {
      require(
        msg.sender == organiserAddress ||
        msg.sender == assistantAddress_1 ||
        msg.sender == assistantAddress_2
      );
      _;
  }

  /// @dev Assigns a new address to act as the assistant. Only available to the current CEO.
  /// @param _newAssistant The address of the new assistant
  function setAssistant_1(address _newAssistant) public onlyAssistant {
      require(_newAssistant != address(0));

      assistantAddress_1 = _newAssistant;
  }

  /// @dev Assigns a new address to act as the assistant. Only available to the current CEO.
  /// @param _newAssistant The address of the new assistant
  function setAssistant_2(address _newAssistant) public onlyAssistant {
      require(_newAssistant != address(0));

      assistantAddress_2 = _newAssistant;
  }


  /// @dev Assigns a new address to act as the organiser. Only available to the current organiser.
  /// @param _newOrganiser The address of the new organiser
  function setOrganiser(address _newOrganiser) public onlyOrganiser {
      require(_newOrganiser != address(0));

      organiserAddress = _newOrganiser;
  }

  /// @dev Modifier to allow actions only when the contract IS NOT paused
  modifier whenNotPaused() {
      require(!paused);
      _;
  }

  /// @dev Modifier to allow actions only when the contract IS paused
  modifier whenPaused {
      require(paused);
      _;
  }

  /// @dev Called by any "assistant" role to pause the contract. Used only when
  ///  a bug or exploit is detected and we need to limit damage.
  function pause() public onlyAssistant whenNotPaused {
      paused = true;
  }

  /// @dev Unpauses the smart contract. Can only be called by the CEO, since
  ///  one reason we may pause the contract is when CFO or COO accounts are
  ///  compromised.
  function unpause() public onlyOrganiser whenPaused {
      // can't unpause if contract was upgraded
      paused = false;
  }


  // Safe maths
  function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
  function sub(uint a, uint b) internal pure returns (uint c) {
      require(b <= a);
      c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
      c = a * b;
      require(a == 0 || c / a == b);
  }
  function div(uint a, uint b) internal pure returns (uint c) {
      require(b > 0);
      c = a / b;
}

}


contract MeetupBase is MeetupAccessControl {
    /*** EVENTS ***/

    // @dev The Creation event is fired whenever a new meetup event comes into existence. 
    //      These meetup events are created by event organiser or assistants 
    event MeeupEventCreated(uint _startTime, uint _maxCapacity, uint _remainingCapacity, string _topic);
    event UserCreated(uint _userId, address _address,  bytes32 _userName, uint userCreateTime);
    event MeetupEventUpdated(uint _startTime, uint _maxCapacity, uint _remainingCapacity, string _topic, uint _waitingListLength);


    // /*** DATA TYPES ***/

    struct Meetup {
        // The timestamp from the block when the meetup event is created.
        uint createTime;

        // The timestamp from the block when the meetup event is scheduled to start.
        uint startTime;

        // Capacity of the meeting.
        uint maxCapacity;

        // Remaining capacity of the meetup event
        uint remainingCapacity;

        // Topic of the meeting.
        string topic;

        // Address of the presenters.
        address[] presenters;

        // Addresses of users who are registered for the event.
        // Only the top maxCapacity people will be able to attend.
        // The rest will be on the waiting list.
        address[] registrationList;

        // Addresses of users who are on the waiting list
        // Later, when some registered user cancel their spot,
        // the top N users on this list will be registered 
        // The ranking is based on a bidding process
        address[] waitingList;

        // bytes32[] registeredUserNames;
    }

    struct User {
        bool exists;
        uint index;
        bytes32 name;
        uint userCreateTime;
        // address userAddress;
        // bytes32 userName;
        // uint userPoints;
        // bool hasDeregistered;            
    }

    /*** STORAGE ***/

    /// @dev An array containing the Meetup struct for all Meetups in existence. 
    Meetup[] public meetups;

    // User[] public users;
    mapping(address => User) userEntries;
    address[] public userIndex;

    /// @dev A mapping from user address to points
    // mapping (address => uint) public addressToPoints;

    // Here we store the names. Make it public to automatically generate an
    // accessor function named 'users' that takes a fixed-length string as argument.
    // mapping (bytes32 => address) public userToAddress;
    // mapping (address => bytes32) public addressToUser;

    // /// @dev An array containing food options
    // bytes32[] public foodOptions;
    // // Mapping from food name to number of votes
    // mapping (bytes32 => uint) public foodToVotes;




    // Initialise contract with the owner taking all three roles
    // These can later be transferred to the right person
    constructor () public {
        organiserAddress = msg.sender;
        assistantAddress_1 = msg.sender;
        assistantAddress_2 = msg.sender;
        // foodOptions = [bytes32("nothing"), "pizza", "sushi", "salad", "burito", "subway"];
    }

   
    function createUser(address _address, bytes32 _userName) public onlyAssistant {
        require(!userEntries[_address].exists);
        userIndex.push(_address);

        User memory _user = User({
          exists: true,
          index: userIndex.length - 1,
          name: _userName,
          userCreateTime: uint(now)
        });

        userEntries[_address] = _user;

        emit UserCreated(userIndex.length - 1, _address, _userName, uint(now));        
    }

    // function deregisterUser(uint _id) public returns (bool) {
    //     require(users[_id].userAddress == msg.sender);        
    //     users[_id].hasDeregistered = true;
    // }

    function getUserData(address _address) public view returns (bool _exists, uint _index, bytes32 _name, uint userCreateTime) {
        User memory user = userEntries[_address];
        return (user.exists, user.index, user.name, user.userCreateTime);
    }
    /// @notice Returns all the relevant information about a specific user.    
    // function getUser(uint _id)
    //     public
    //     view
    //     returns (
    //     uint userCreateTime,
    //     address userAddress,
    //     bytes32 userName,
    //     // uint userPoints,
    //     bool hasDeregistered
    // ) {
    //     User storage user = users[_id];
        
    //     userCreateTime = user.userCreateTime;
    //     userAddress = user.userAddress;
    //     userName = user.userName;
    //     // userPoints = user.userPoints;
    //     hasDeregistered = user.hasDeregistered;        
    // }

    // Register the provided name with the caller address.
    // Also, we don't want them to register "" as their name.
    // function registerUser(bytes32 name) public {
    //     // require(
    //     //     msg.sender == userToAddress[name] ||
    //     //     msg.sender == organiserAddress ||
    //     //     msg.sender == assistantAddress_1 ||
    //     //     msg.sender == assistantAddress_2
    //     // );
        
    //     if(userToAddress[name] == 0 && name != ""){
    //         addressToUser[msg.sender] = name;
    //         userToAddress[name] = msg.sender;            
    //         // addressToPoints[msg.sender] = 100;
    //     }
    // }

    // // Deregister the provided name with the caller address.
    // // Only user him/herself or assistants can deregister a user
    // function deregisterUser(bytes32 name) public onlyAssistant {        
    //     // require(
    //     //     msg.sender == users[name] ||
    //     //     msg.sender == organiserAddress ||
    //     //     msg.sender == assistantAddress_1 ||
    //     //     msg.sender == assistantAddress_2
    //     // );
    //     if(userToAddress[name] != 0 && name != ""){
    //         addressToUser[msg.sender] = "";
    //         userToAddress[name] = 0x0;
    //     }
    // }

  //   function addFoodOption(bytes32 _food) public onlyAssistant {
  //       require(_food != '');

  //       // Can't add the same food twice
  //       for (uint i = 0; i < foodOptions.length; i++) {
  //           if (foodOptions[i] == _food) {
  //               revert();
  //           }
  //       }

  //       foodOptions.push(_food);
  //   }

  //   function removeFoodOption(bytes32 _food) public onlyAssistant {
  //       require(_food != '' && _food != 'nothing');

  //       // Has to be in the food option list to be removed
  //       bool isListedFood = false;
  //       for (uint i = 0; i < foodOptions.length; i++) {
  //           if (foodOptions[i] == _food) {
  //               isListedFood = true;

  //               // can't remove the food option if there's only one option left!
  //               if (foodOptions.length > 1) {
  //                   // shift the last entry to the deleted entry
  //                   foodOptions[i] = foodOptions[foodOptions.length-1];                    

  //                   // delete the last entry
  //                   delete(foodOptions[foodOptions.length-1]);                    

  //                   // update length
  //                   foodOptions.length--;                    
  //               }                
  //           }
  //       }      
  //       require(isListedFood);
  //   }

  //   /// @dev Computes the winning food option taking all
  //   /// previous votes into account.
  //   function getWinningFood() public view
  //           returns (bytes32 winningFood_)
  //   {
  //       uint winningVoteCount = 0;
  //       for (uint p = 0; p < foodOptions.length; p++) {
  //           if (foodOptions[p] != "nothing" &&
  //               foodToVotes[foodOptions[p]] > winningVoteCount) {
  //               winningVoteCount = foodToVotes[foodOptions[p]];
  //               winningFood_ = foodOptions[p];
  //           }
  //       }
  //   }

  //   /// @dev Clear food votes in preparation for the next round of voting    
  //   function clearFoodVotes() public onlyAssistant             
  //   {        
  //       for (uint p = 0; p < foodOptions.length; p++) {
  //           foodToVotes[foodOptions[p]] = 0;            
  //       }
  //   }

    // @param _timeUntilMeetup Time until the scheduled meeting start time
    // @param _maxCapacity Maximum capacity of the meeting.
    // @param _presenters Addresses of presenters.
    // @param _food food voted by the creator
    function createMeetup (            
        uint _startTime,        
        uint _maxCapacity,
        string _topic,
        address[] _presenters
        // bytes32 _food
    )
        public
        onlyAssistant
        returns (uint)
    {
        // // Check if the food option is valid
        // bool isValidFood = false;
        // require(_food != '');
        // for (uint j = 0; j < foodOptions.length; j++) {
        //     if (foodOptions[j] == _food) {
        //         isValidFood = true;
        //     }
        // }
        // require(isValidFood);

        // foodToVotes[_food] += 1;


        // Can't create a meetup in the past
        require(uint(_startTime) > uint(now));

        // Must have at least 1 extra spot
        require(_maxCapacity > _presenters.length);

        // uint[] memory _registrationList = _presenters;
        address[] memory _registrationList = new address[](_maxCapacity);
        address[] memory _waitingList = new address[](0);
        // (_maxCapacity);
        // bytes32[] memory _registeredUserNames = new bytes32[](_presenters.length);
        // bytes32[] memory _registeredUserNames = new bytes32[](_maxCapacity);

        // Map address to names
        // for (uint i = 0; i < _presenters.length; i++) {
        //     // _registeredUserNames[i] = addressToUser[_presenters[i]];
        //     _registeredUserNames[i] = users[_presenters[i]].userName;
        // }        

        // Poulate the initial registration list with presenters
        for (uint i = 0; i < _presenters.length; i++) {            
            _registrationList[i] = _presenters[i];
        }
        
        uint _remainingCapacity = sub(_maxCapacity, _presenters.length);

        Meetup memory _meetup = Meetup({            
            createTime: uint(now),
            startTime: uint(_startTime),
            maxCapacity: _maxCapacity,
            topic: _topic,
            presenters: _presenters,
            registrationList: _registrationList,
            remainingCapacity: _remainingCapacity,
            waitingList: _waitingList
            // registeredUserNames: _registeredUserNames            
        });

        uint newMeetupId = meetups.push(_meetup) - 1 ;

        // emit the meetup event creation event
        emit MeeupEventCreated(_startTime, _maxCapacity, _remainingCapacity, _topic);

        return newMeetupId;
    }


//   function getPresenters(uint i) public view returns (uint[]){
//     return meetups[i].presenters;
//   }

    // function getRegistrationList(uint i) public view returns (uint[]){
    //     return meetups[i].registrationList;
    // }

    // function getRegisteredUserNames(uint i) public view returns (bytes32[]){
    //     return meetups[i].registeredUserNames;
    // }

    // function getFoodOptionCount() public view returns (uint) {
    //     return foodOptions.length;
    // }

    function getMeetup(uint _id)
        public
        view
        returns (
        uint meetupCreateTime,
        uint meetupStartTime, 
        uint meetupMaxCapacity,
        uint remainingCapacity,
        string meetupTopic,
        address[] meetupPresenters,
        address[] meetupRegistrationList,
        address[] meetupWaitingList
        // bytes32[] meetupPresenterNames
        // bytes32[] meetupRegisteredNames,
    ) {
        Meetup storage meetup = meetups[_id];

        meetupCreateTime = meetup.createTime;
        meetupStartTime = meetup.startTime;
        meetupMaxCapacity = meetup.maxCapacity;        
        meetupTopic = meetup.topic;
        meetupPresenters = meetup.presenters;
        meetupRegistrationList = meetup.registrationList;
        remainingCapacity = meetup.remainingCapacity;
        meetupWaitingList = meetup.waitingList;


        // for (uint i = 0; i < meetupPresenters.length; i++) {            
        //     meetupPresenterNames[i] = users[meetupPresenters[i]].userName;
        // }        
    }

    // function getUserId() internal view returns (uint) {
    //   bool isValidUser = false;
    //   uint userId;
    //   for (uint i = 0; i < users.length; i++) {
    //     if (users[i].userAddress == msg.sender && 
    //       users[i].hasDeregistered == false) {
    //       isValidUser = true;
    //       userId = i;
    //     }
    //   }  
    //   require(isValidUser);

    //   return userId;
    // }

    // function joinNextMeetup(bytes32 _food)
    function registerForMeetup(uint _meetupId)
        public                
        // returns (bool)
    {
        require(userEntries[msg.sender].exists);
        
        // Check if the food option is valid
        // bool isValidFood = false;
        // require(_food != '');
        // for (uint j = 0; j < foodOptions.length; j++) {
        //     if (foodOptions[j] == _food) {
        //         isValidFood = true;
        //     }
        // }
        // require(isValidFood);

        // foodToVotes[_food] += 1;

        // uint _meetupId = meetups.length - 1;
        Meetup storage _meetup = meetups[_meetupId];

        // Can't join a meetup that has already started.
        require(now < _meetup.startTime);

        uint occupiedCapacity = sub(_meetup.maxCapacity, _meetup.remainingCapacity);

        // Can't join twice
        for (uint i = 0; i < occupiedCapacity; i++) {
            if (_meetup.registrationList[i] == msg.sender) {
                revert();
            }
        }

        for (i = 0; i < _meetup.waitingList.length; i++) {
            if (_meetup.waitingList[i] == msg.sender) {
                revert();
            }
        }      

        // Check if there is any capacity remaining
        if (_meetup.remainingCapacity > 0) {
          // Register user for the meetup event 
          _meetup.registrationList[occupiedCapacity] = msg.sender;

          // Reduce the capacity by 1
          _meetup.remainingCapacity = sub(_meetup.remainingCapacity, 1);

        } else {

          // If there is no capacity remaining, join the waiting list
          _meetup.waitingList.push(msg.sender);

        }


        // Broadcast the updated event data
        emit MeetupEventUpdated(_meetup.startTime, _meetup.maxCapacity, 
          _meetup.remainingCapacity, _meetup.topic, _meetup.waitingList.length);

        // deduct deposit
        // addressToPoints[msg.sender] = addressToPoints[msg.sender] - 50;

    }

    // function leaveNextMeetup ()
    //     public           
    //     // returns (bool)
    // {
    //     // Can't leave a meetup that has already started.
    //     require(now < _meetup.startTime);        

    //     // Have to be a registered user
    //     // require(addressToUser[msg.sender] > 0);        
    //     uint _userId = getUserId();

    //     uint _meetupId = meetups.length - 1;
    //     Meetup storage _meetup = meetups[_meetupId];

    //     // Have to be registered to leave
    //     bool hasJoined = false;
    //     for (uint i = 0; i < _meetup.registrationList.length; i++) {
    //         if (_meetup.registrationList[i] == _userId) {
    //             hasJoined = true;

    //             // can't leave the meetup if there's only one person!
    //             if (_meetup.registrationList.length > 1) {
    //                 // shift the last entry to the deleted entry
    //                 _meetup.registrationList[i] = _meetup.registrationList[_meetup.registrationList.length-1];
    //                 _meetup.registeredUserNames[i] = _meetup.registeredUserNames[_meetup.registrationList.length-1];

    //                 // delete the last entry
    //                 delete(_meetup.registrationList[_meetup.registrationList.length-1]);
    //                 delete(_meetup.registeredUserNames[_meetup.registrationList.length-1]);

    //                 // update length
    //                 _meetup.registrationList.length--;
    //                 _meetup.registeredUserNames.length--;
    //             }                
    //         }
    //     }      
    //     require(hasJoined);
    // }

    function getMeetupCount () public view returns (uint) {
      return meetups.length;
    }
  
    function getUserCount () public view returns (uint) {
      return userIndex.length;
    }

    function checkIn (address _address, uint _meetupId) public view returns (bool) {
      require(userEntries[_address].exists);

      bool canAttend = false;

      Meetup memory _meetup = meetups[_meetupId];

      uint occupiedCapacity = sub(_meetup.maxCapacity, _meetup.remainingCapacity);

      for (uint i = 0; i < occupiedCapacity; i++) {
          if (_meetup.registrationList[i] == _address) {
              canAttend = true;
          }
      }

      return canAttend;
    }
}
