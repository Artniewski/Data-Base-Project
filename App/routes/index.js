const express = require('express');
const router = express.Router();

if (typeof localStorage === "undefined" || localStorage === null) {
    const LocalStorage = require('node-localstorage').LocalStorage;
    localStorage = new LocalStorage('./scratch');
}

router.use(function (req, res, next) {
    //localStorage.setItem("accountType", "admin")
    next();
})

/* GET home page. */
router.get('/', function (req, res, next) {
    let type = localStorage.getItem("accountType")
    switch (type) {
        case "admin":
            localStorage.setItem("accountType", "user")
            res.render('index', {title: 'admin'});
            break;
        case "user":
            localStorage.clear();
            res.render('index', {title: 'user'})
            break;
        case "manager":
            res.render('index', {title: 'manager'})
            break;

    }
    res.render('index', {title: localStorage.getItem("counter")});
});

module.exports = router;
