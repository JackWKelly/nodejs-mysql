const services = require('./services');

var exports = module.exports = {};

exports.listOrders = function(req, res) {
    let test = services.readOrders();
    res.send(test);//won't work not async
}
