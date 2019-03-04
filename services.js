const mysql = require('mysql');
const sqlCon = mysql.createConnection({
    host: "localhost",
    user: "nodejs",
    password: "NodeJSPassword2019",
    database: "ordernormdb"
});

var exports = module.exports = {};

exports.connectTest = function(){
        console.log("SQL connected");
        return("SQL connected");
    
}

exports.readOrders = function(){
        return new Promise(function(resolve, reject){
                sqlCon.query("SELECT * FROM orders;", function (err, result, fields) {
                if (err) reject(err);
                const objectifyRawPacket = row => ({...row}); //some magic suggested by stackoverflow
                let resultJson = result.map(objectifyRawPacket);
                console.log(resultJson);
                resolve(resultJson);
            })
        })
}

exports.getTotalCost = function(orderNumber){
    return new Promise(function(resolve, reject){
            sqlCon.query(`
            #find the cost of a given order
            SELECT SUM(unitCost) AS total
            FROM
            (SELECT item.itemCost * itemOrder.itemQuantity AS unitCost
            FROM  
                itemOrder
                    INNER JOIN
                item ON itemOrder.itemName = item.itemName
            WHERE
                itemOrder.orderNumber = ${orderNumber}
            ) as findCost;`
                , function (err, result, fields) {
                if (err) reject(err);

                const objectifyRawPacket = row => ({...row}); //some magic suggested by stackoverflow
                let resultJson = result.map(objectifyRawPacket);
                resolve(resultJson);
                }
            )
    })
}