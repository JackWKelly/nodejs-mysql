const services = require('./services');

var exports = module.exports = {};

exports.listOrders = function(req, res) {
    services.readOrders()
        .then(function(data){
            res.send(data);
        })
}
