const express = require('express');
const app = express();
const mysql = require('mysql');

//load custom dependencies
const routes = require('./routes');

//set api routes
app.use('/api/order', routes);

//catch non valid routes
app.get('*', function(req,res){
    res.status(404);
    res.send('Not found!');
});

app.listen(port = 3000, function (){
    console.log(`Listening on port ${port}!`);
});