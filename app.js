var React = require('react');
var ReactDOM = require('react-dom');
var Application = require("./src/Application.react");

require("./public/css/app.less");

ReactDOM.render(
	<Application />, document.getElementById('react-app')
);
