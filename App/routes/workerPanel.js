const express = require('express');
const {LocalStorage} = require("node-localstorage");
const router = express.Router();
const {workerPool, appPool} = require('../connection')
const bcrypt = require("bcrypt");
if (typeof localStorage === "undefined" || localStorage === null) {
    const LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./info');
}


function isLoggedIn(req, res, next) {
    if (localStorage.getItem("isLoggedIn")) {
        next();
    } else {
        res.redirect('/login');
    }
}

/* GET users listing. */
router.get('/', isLoggedIn, function (req, res, next) {
    res.render('worker');
});

router.get('/clients', isLoggedIn, ((req, res) => {
    workerPool.query(
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('clients', {results});
        }
    );
}))

router.get('/orders', isLoggedIn, ((req, res) => {
    workerPool.query(
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('orders', {results});
        }
    );
}))

router.post('/orders', isLoggedIn, (req, res) => {
    //dane z req.body
    res.redirect('/worker-panel/');
})

router.get('/cars', isLoggedIn, (req, res) => {

})

module.exports = router;