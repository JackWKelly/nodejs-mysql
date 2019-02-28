const mysql = require('mysql');
const sqlCon = mysql.createConnection({
    host: "localhost",
    user: "nodejs",
    password: "NodeJSPassword2019",
    database: "ordernormdb"
});

var exports = module.exports = {};

exports.connectTest = function(){
    sqlCon.connect(function(err){
        if (err) {
            throw err;
        }
        console.log("SQL connected");
        return("SQL connected");
    })
}

exports.readOrders = function(){
    sqlCon.connect(function(err){
        if (err) {
            throw err;
        }
        console.log("SQL connected");
        sqlCon.query("SELECT * FROM orders;", function (err, result, fields) {
            if (err) throw err;
            const objectifyRawPacket = row => ({...row}); //some magic suggested by stackoverflow
            let resultJson = result.map(objectifyRawPacket);
            console.log(resultJson);
            return resultJson;
        })
    })
}