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
        && localStorage.getItem("type") !== "worker") {
        next();
    } else {
        res.redirect('/login');
    }
}

/* GET users listing. */
router.get('/', isLoggedInManager, function (req, res, next) {
    const type = localStorage.getItem("type")
    res.render('manager');
});

router.post('/brands', isLoggedInManager, ((req, res) => {
    const {name, country} = req.body;
    let dummy = 0;
    managerPool.query(
        'call add_brand(?, ?, @a);', [name, country],
        function (err, results, fields) {
            console.log(err)
            res.redirect('/manager-panel')
        }
    );
}))
router.get('/brands/new', isLoggedInManager, (((req, res) => {
    res.render('brandForm');
})))

router.get('/cars/new', isLoggedInManager, (((req, res) => {
    res.render('carsForm');
})))

router.post('/cars', isLoggedInManager, ((req, res) => {
    const {brand_name, brand_country, car_name, car_price, car_max_speed} = req.body;
    managerPool.query(
        //TODO
        'call add_car_model(?, ?, ?, ?, ?, @a, @b);',
        [brand_name, brand_country, car_name, car_price, car_max_speed],
        function (err, results, fields) {
            res.redirect('/manager-panel');
        }
    );
}))

router.get('/car-to-stores/new', isLoggedInManager, (((req, res) => {
    res.render('ctsForm');
})))

router.post('/cars-to-stores', isLoggedInManager, (req, res) => {
    const {brand_name, brand_country, car_name, car_price, car_max_speed, store_ID, qty, car_color} = req.body;
    managerPool.query('call add_car_to_store (?, ?, ?, ?, ?, ?, ?, ?);',
        [brand_name, brand_country, car_name, car_price, car_max_speed, store_ID, qty, car_color],
        function (err, results, fields) {
            res.redirect('/manager-panel');
        }
    )
})

router.get('/cancel-order', isLoggedInManager, (req, res) => {
    managerPool.query('select o.ID, c.name, c.lastname, c.phone_number, b.name as brand, m.name as model, m.price, color,userID as By, date, status ' +
        'from orders as o ' +
        'join customer as c on c.ID = o.customerID ' +
        'join models as m on m.ID = modelID ' +
        'join brands as b on b.ID = m.brandID;', function (err, results, fields) {
        console.log(err);
        res.render('managerCancelList',{results})
    })
})

router.post('/cancel-order', isLoggedInManager, (req, res) => {
    const {ID} = req.body;
managerPool.query('update orders\n' +
    'set status = \'cancelled\'\n' +
    'where ID = ?',[ID])
})

module.exports = router;