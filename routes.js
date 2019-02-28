const express = require('express');
const router = express.Router();
const controller = require('./controller');

router.get('/listorders', controller.listOrders);

module.exports = router;