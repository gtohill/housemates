import React from 'react';

export default class popup extends React.Component {
  constructor(props) {
    super();

    this.state = {
      TaskList: [],
      FinanceList: [],
      StarList: []
    }
  }

  fetch_points() {
    var Tasks = [
      {"Name":"Take out the trash","Score":"-5%","date":"March 18/2017"},
      {"Name":"Do dishes","Score":"-5%","date":"March 18/2017"},
      {"Name":"Walk dog","Score":"-5%","date":"March 18/2017"}
    ];

    var Finances = [
      {"Name":"Pay Rent","Score":"-20%","date":"March 18/2017"},
      {"Name":"Internet","Score":"-5%","date":"March 18/2017"},
      {"Name":"Electric Bill","Score":"-3%","date":"March 18/2017"}
    ];

    var Stars = [
      {"Name":"Making Dinner","Score":"1*"},
      {"Name":"Cleaning ______ Room","Score":"1*"},
      {"Name":"Driving _______ to mall ","Score":"1*"},
      {"Name":"Helping _______ with homework","Score":"1*"},
    ];

    this.setState({TaskList: Tasks});
    this.setState({FinanceList: Finances});
    this.setState({StarList: Stars});
  }

  componentDidMount() {
    this.fetch_points();
  }

  render() {
    return ( 
      <Leaderboard TaskList={this.state.TaskList} FinanceList={this.state.FinanceList} StarList={this.state.StarList} />)
  }
}

class Leaderboard extends React.Component {  
  constructor(props) {
    super();
  }
  render() { 

   let results = this.buildTasks();

    return (
      <div className="board"> 
        <table  className="table-fill"> 
          <tbody>
            <tr>
              <td>Vaughan Robertson</td>
            </tr> 
            <tr>
              <td>Tasks</td>
            </tr> 
            {results['TaskList']}
            <tr>
              <td>Finances</td>
            </tr> 
            {results['FinanceList']}
            <tr>
              <td>Bonus Stars</td>
            </tr> 
            {results['StarList']}
          </tbody>
        </table> 
    </div>
    )
  }
  
  buildTasks() {
    let result = { 
      TaskList: [],
      FinacneList:[],
      StarList:[]
    };

    result.TaskList = this.props.TaskList.map((data, index) => {
      return (
        <LeaderboardRow index={index+1} Name={data.Name} Score={data.Score} date={data.date} key={index}/>
      );
    });

    result.FinanceList = this.props.FinanceList.map((data, index) => {
      return (
        <LeaderboardRow index={index+1} Name={data.Name} Score={data.Score} date={data.date} key={index}/>
      );
    });

    result.StarList = this.props.StarList.map((data, index) => {
      return (
        <LeaderboardRow index={index+1} Name={data.Name} Score={data.Score} date={data.date} key={index}/>
      );
    });

    return result;
  }
}

class LeaderboardRow extends React.Component {

  render() {
    return(
      <tr onClick={() => this.onPress(this.state.visible,this.props.username)} >
       <td className="uName">{this.props.date}</td>
        <td></td> 
        <td className="uName">{this.props.Name}</td>
        <td></td> 
        <td className="Score">{this.props.Score}</td> 
      </tr>
    )
  }
}
