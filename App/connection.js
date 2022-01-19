const mysql = require('mysql2');

const appPool = mysql.createConnection({
        host: '127.0.0.1',
        user: 'app',
        database: 'speedygad',
        password: 'app',
        port: 3306
    }
);

module.exports = appPool;