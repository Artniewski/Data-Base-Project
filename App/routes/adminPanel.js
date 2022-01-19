const express = require('express');
const {LocalStorage} = require("node-localstorage");
const router = express.Router();
const {adminPool} = require('../connection')
const bcrypt = require("bcrypt");
if (typeof localStorage === "undefined" || localStorage === null) {
    const LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./info');
}


function isLoggedInAdmin(req, res, next) {
    if (localStorage.getItem("isLoggedIn")
        && localStorage.getItem("accountType") === "manager") {
        next();
    } else {
        res.redirect('/login');
    }
}

/* GET users listing. */
router.get('/', isLoggedInAdmin, function (req, res, next) {
    res.render('index');
});

router.post('/brands', isLoggedInAdmin, ((req, res) => {
    adminPool.query(
        //TODO
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('index');
        }
    );
}))

router.post('/cars', isLoggedInAdmin, ((req, res) => {
    adminPool.query(
        //TODO
        'SELECT * FROM `Customer`',
        function (err, results, fields) {
            res.render('orders', {results});
        }
    );
}))

router.post('/cars-to-stores', isLoggedInAdmin, (req, res) => {

    res.redirect('/worker-panel/');
})

router.get('/cancel-order', isLoggedInAdmin, (req, res) => {
//tak jak u workera

})

router.post('/cancel-order', isLoggedInAdmin, (req, res) => {

})

module.exports = router;