const express = require('express');
const {LocalStorage} = require("node-localstorage");
const router = express.Router();
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
router.get('/',isLoggedIn, function (req, res, next) {
    res.render('worker');
});

module.exports = router;