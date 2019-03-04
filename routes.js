const express = require('express');
const router = express.Router();
const controller = require('./controller');

router.get('/listorders', controller.listOrders);

router.get('/totalCost/:id', controller.totalCost);

module.exports = router;