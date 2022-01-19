const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt')
const mysql = require('mysql2');
if (typeof localStorage === "undefined" || localStorage === null) {
    const LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./info');
}
const appPool = require('../connection')

function isLoggedIn(req, res, next) {
    if (localStorage.getItem("isLoggedIn")) {
        next();
    } else {
        res.redirect('/login');
    }
}

/* GET home page. */
router.get('/', isLoggedIn, function (req, res, next) {
    let type = localStorage.getItem("accountType")
    res.render('index', {title: type})
    // switch (type) {
    //     case "admin":
    //         res.render('index', {title: 'admin'});
    //         break;
    //     case "user":
    //         res.render('index', {title: 'user'})
    //         break;
    //     case "manager":
    //         res.render('index', {title: 'manager'})
    //         break;
    //
    //}
});

router.get('/login', ((req, res) => {
    localStorage.clear();
    res.render('login')
}))

router.post('/login', (req, res) => {
    let {login, password} = req.body;
    appPool.query(
        'SELECT password,type FROM `Users` WHERE `login` = ?',
        [login],
        function (err, results, fields) {
            if (bcrypt.compare(password, results[0].password)) {
                localStorage.setItem("isLoggedIn", "true");
                localStorage.setItem("accountType", results[0].type)
                res.redirect('/');

            } else {
                res.redirect('/login')
            }

            // If you execute same statement again, it will be picked from a LRU cache
            // which will save query preparation time and give better performance
        }
    );
    // if (queryResult[0].login === login && queryResult[0].password === password) {
    //     res.redirect('/');
    // } else {
    //     res.redirect('/login')
    // }

})

module.exports = router;
