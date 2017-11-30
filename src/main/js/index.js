/**
 * Created by om on 10/03/17.
 */
import React from 'react';
import ReactDOM from 'react-dom';
import { PostFeed } from './PostFeed'
import App from './leaderboard'


console.log("index rendering");


let root = document.getElementById('root');
ReactDOM.render(
    <div id="notifications">
        {<PostFeed/>}
    </div>, root);

ReactDOM.render(
  <App />,
  document.getElementById('leaderboard')
);