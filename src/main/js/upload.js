/**
 * Created by om on 10/03/17.
 */
import React from 'react';
import ReactDOM from 'react-dom';
import { PostFeed } from './PostFeed'
import App from './leaderboard'
import Dropzone from 'react-dropzone';


function encodeAndUpload(file) {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function () {
        fetch('http://localhost:8080/document?imageName=' + file.name,{
            method: 'POST',
            headers: {
                "Content-Type": "application/json"
            },
            body: reader.result
        }).then(res =>{
            if(res.ok){
                alert("success!");
            }
            else{
                alert("fail!")
            }
        });
    };
    reader.onerror = function (error) {
        console.log('Error: ', error);
    };
}

var DropzoneDemo = React.createClass({
    onDrop: function (files) {
        console.log('Received files: ', files);
        encodeAndUpload(files[0])
    },
    render: function () {
        return (
            <div>
                <Dropzone onDrop={this.onDrop}>
                    <div>Try dropping a file here, or click to select file to upload.</div>
                </Dropzone>
            </div>
        );
    },


});

ReactDOM.render(
    <div>
        {<DropzoneDemo />}
    </div>,
    document.getElementById('DROPZONEHERE')
);
