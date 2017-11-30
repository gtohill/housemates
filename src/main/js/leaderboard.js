import React from 'react';

var value = 0

export default class App extends React.Component {
  constructor(props) {
    super();

    this.state = {
      boardList: []
    }

    this.getParams = this.getParams.bind(this);
  }

  getScore(){
        var CLIENT_ID = '731832964818-uecs4clv5qsfubet2rbbr1co235pbost.apps.googleusercontent.com';
        var SCOPES = ["https://www.googleapis.com/auth/calendar"];

        gapi.client.calendar.events.list({
            'calendarId': 'primary',
            'showDeleted': false,
            'singleEvents': true,
            'orderBy': 'startTime'
        }).then((response) => {
          let events = response.result.items;
            for(let i = 0; i < events.length; i++) {
                
                if(events[i].summary === 'RoomMateTask'){

                    for (let j = 0; j < events[i].attendees.length; j++) {
                        if(j.responseStatus === "accepted"){
                          value = value + 1;
                         }

                    }
                  }
                }

        });

  }

  getParams() {
  
      let url_parameter = {};


      const currLocation = window.location.href,
          parArr = currLocation.split("?")[1].split("%0A++");
      for (let i = 0; i < parArr.length; i++) {
          const parr = parArr[i].split("+%3D+");
          url_parameter[parr[0]] = parr[1];
      }

      fetch('http://localhost:8080/Person/addTaskScore?subId=' + url_parameter.subId + '&taskScore=' + value,
            {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json"
                },
            }).then();

      let results = [];
      fetch("http://localhost:8080/PersonHouse/getHouseMembers?subId="+url_parameter.subId)
          .then(response => {
              if (response.ok) {
                      console.log("check3");
                      console.log(value);
                  response.json().then(json => {
                      for (let i = 0; i < json.length; i++) {
                        console.log(json[i]);
                        results.push({"username": json[i].firstName+" "+json[i].lastName, "TaskScore": value, "FinanceScore": json[i].financeScore, "Stars": 0, "image": "http://www.kombitz.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png"});
                        console.log(json[i].financeScore);

                      }
                      this.setState({boardList:results})
                  });
              }
          })

    console.log(results);
  }    

  componentDidMount() {

    setTimeout(this.getScore, 2000);

    setTimeout(this.getParams, 2500)

  }

  render() {
    return ( 
      <Leaderboard boardList={this.state.boardList}/>)
  }
}

class Leaderboard extends React.Component {  
  constructor(props) {
    super();
  }
  render() { 

   let results = this.buildRows();

    return (
      <div className="board"> 
        <table  className="table-fill"> 
          <tbody>
            <tr>
              <th>Picture</th>
              <th>Username</th>
              <th>Task Score</th>
              <th>Finance Score</th>
              <th>Stars</th>
            </tr> 
            {results['boardList']}
          </tbody>
        </table> 
    </div>
    )
  }
  
  buildRows() {
    let result = { 
      boardList: []
    };

    result.boardList = this.props.boardList.map((data, index) => {
      return (
        <LeaderboardRow index={index+1} username={data.username} TaskScore={data.TaskScore}
        Stars={data.Stars} Click={data.Click} FinanceScore={data.FinanceScore} image={data.image} key={index}/>
      );
    });

    return result;
  }
}

class LeaderboardRow extends React.Component {

  constructor(props) {
    super(props);
    
  }

  onPress(){

    //window.location = 'http://localhost:8080/house/leaderboard';
  }


  render() {
    return(
      <tr onClick={() => this.onPress()} >
        <td className="picture"><img  src={this.props.image} height="50" width="50" alt=''/> </td> 
        <td className="uName">{this.props.username}</td>
        <td className="Score">{this.props.TaskScore}</td> 
        <td className="Finance">{this.props.FinanceScore}</td> 
        <td className="Stars">{this.props.Stars}</td> 
      </tr>
    )
  }
}

