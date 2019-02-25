const express = require('express');
const router = express.Router();
const controller = require('./controller');

router.get('/read', controller.readOrder);

module.exports = router;