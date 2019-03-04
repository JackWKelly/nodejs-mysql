const services = require('./services');

var exports = module.exports = {};

exports.listOrders = function(req, res) {
    services.readOrders()
        .then(function(data){
            res.send(data);
        })
}

exports.totalCost = function(req, res) {
    let orderNumber = req.params.id;
    services.getTotalCost(orderNumber)
        .then(function(data){
            res.send(data);
        })
}
