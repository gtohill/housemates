/**
 * Created by om on 10/03/17.
 */

import React from 'react';
import  SubmitPost  from './SubmitPost';

var Post = React.createClass({
    getInitialState(){
        return{

        }
    },
    render(){
        return(
            <div id="post">
                <div className="centred">{this.props.title + " " + this.props.date}</div>
                {"From:  "+this.props.sender}<br/>
                {this.props.text}

            </div>
        );
    }

});


export class PostFeed extends React.Component{

    constructor(){
        super();
        this.state = {
            postList : []
        };



        this.fetchPosts = this.fetchPosts.bind(this);
    }

    fetchPosts(subId){
        console.log("getting update to backend");
        fetch('http://localhost:8080/Post/getPosts?subId=' + subId )
            .then(response => {
                if(response.ok){
                    response.json().then(json => {
                        let results = [];
                        for (let i = 0; i < json.length; i++) {
                            results.push(<div><Post sender={json[i].senderName} title={json[i].title}
                                                    date={json[i].date} text={json[i].text}/></div>);
                        }
                        this.setState({postList : results});
                    })
                }
                else {
                    // If response is NOT OKAY (e.g. 404), clear the statuses.
                    this.setState({postList: []});
                }
            });
    }

    componentDidMount() {
        let subId = this.getParams().subId;
        this.fetchPosts(subId);
        //this.listOneEvent();
        //alert(isLoaded);
    }

    componentWillReceiveProps(nextProps){
        let subId = this.getParams().subId;
        this.fetchPosts(subId);
    }

    getParams() {
    // http://localhost:8080/house/myHouse?persons=Session+Content%3A%0A++subId+%3D+102369340031760804603%0A++firstName+%3D+down%0A++lastName+%3D+load%0A++houseName+%3D+jb+hg%0A++houseId+%3D+2%0A++org.grails.FLASH_SCOPE+%3D+org.grails.web.servlet.GrailsFlashScope%401467ea6f%0A++email+%3D+stupidemail9898%40gmail.com%0A
    let url_parameter = {};

    const currLocation = window.location.href,
        parArr = currLocation.split("?")[1].split("%0A++");
    for (let i = 0; i < parArr.length; i++) {
        const parr = parArr[i].split("+%3D+");
        url_parameter[parr[0]] = parr[1];
    }
    return url_parameter;
}

    render() {

        return(
            <div>
                <h2 >Notifications</h2>
                <div id="postFeed">
                    {this.state.postList}
                </div>
                {<SubmitPost subId={this.getParams().subId} update={this.fetchPosts}
                             firstName={this.getParams().firstName}/>}

            </div>
        );
    }



}