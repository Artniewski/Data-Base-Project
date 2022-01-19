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
        'SELECT * FROM `Customers`',
        function (err, results, fields) {
            res.render('workerDisplayList', {results});
        }
    );
}))


router.get('/orders/new', isLoggedIn, (((req, res) => {
    res.render('orderForm');
})))

router.get('/orders', isLoggedIn, ((req, res) => {
    workerPool.query(
        'select o.ID, c.name, c.lastname, c.phone_number,' +
        ' c.email, b.name, m.name, m.price, m.max_speed, ' +
        'o.userID, o.color, DATE_FORMAT(o.date,\'%d/%m/%Y\') as orderDate, o.status\n' +
        'from orders as o\n' +
        'join customers as c on c.ID = o.customerID\n' +
        'join models as m on m.ID = modelID\n' +
        'join brands as b on b.ID = m.brandID',
        function (err, results, fields) {
            //res.json(results);
            res.render('workerDisplayList', {results});
        }
    );
}))

router.post('/orders', isLoggedIn, (req, res) => {
    const {
        customer_name,
        customer_lastname,
        customer_phone,
        customer_email,
        modelID,
        storeID,
        userID,
        car_color,
        date
    } = req.body;
    workerPool.query(
        'call add_order(?, ?, ?, ?, ?, ?, ?, ?)',
        [customer_name, customer_lastname, customer_phone, customer_email, modelID, storeID, userID, car_color, date]
        , function (err, result, fields) {
            //res.json(result);
            res.redirect('/worker-panel');
        }
    )
})

router.get('/cars', isLoggedIn, (req, res) => {
    workerPool.query(
        'select cis.storeID, s.city, b.name as brand, m.name, cis.quantity, cis.color\n' +
        'from cars_in_stores as cis\n' +
        'join stores as s on s.ID = cis.storeID\n' +
        'join models as m on m.ID = cis.modelID\n' +
        'join brands as b on b.ID = m.brandID'
        , function (err, results, fields) {
            //res.json(results);
            res.render('workerDisplayList', {results});
        }
    )
})

module.exports = router;