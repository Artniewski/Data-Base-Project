const express = require('express');
const {LocalStorage} = require("node-localstorage");
const router = express.Router();
const {managerPool} = require('../connection')
const bcrypt = require("bcrypt");
if (typeof localStorage === "undefined" || localStorage === null) {
    const LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./info');
}


function isLoggedInManager(req, res, next) {
    if (localStorage.getItem("isLoggedIn")
        && localStorage.getItem("accountType") === "manager") {
        next();
    } else {
        res.redirect('/login');
    }
}

/* GET users listing. */
router.get('/', isLoggedInManager, function (req, res, next) {
    res.render('index');
});

router.post('/brands', isLoggedInManager, ((req, res) => {
    managerPool.query(
        //TODO
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('index');
        }
    );
}))

router.post('/cars', isLoggedInManager, ((req, res) => {
    managerPool.query(
        //TODO
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('orders', {results});
        }
    );
}))

router.post('/cars-to-stores', isLoggedInManager, (req, res) => {

    res.redirect('/worker-panel/');
})

router.get('/cancel-order', isLoggedInManager, (req, res) => {
//tak jak u workera

})

router.post('/cancel-order', isLoggedInManager, (req, res) => {

})

module.exports = router;