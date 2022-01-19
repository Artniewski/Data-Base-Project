const express = require('express');
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
    res.render('index', {title: localStorage.getItem("counter")});
});
router.get('/login', ((req, res) => {
    localStorage.clear();
    res.render('login')
}))

router.post('/login', (req, res) => {
    let {login, password} = req.body;
    let queryResult = [{login: "art", password: "123", type: "admin"}]

    if (queryResult[0].login === login && queryResult[0].password === password) {
        localStorage.setItem("isLoggedIn", "true");
        localStorage.setItem("accountType", queryResult[0].type)
        res.redirect('/');
    } else {
        res.redirect('/login')
    }

})

module.exports = router;
