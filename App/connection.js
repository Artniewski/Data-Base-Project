const mysql = require('mysql2');

const appPool = mysql.createConnection({
        host: '127.0.0.1',
        user: 'app',
        database: 'speedygad',
        password: 'app',
        port: 3306
    }
);

const workerPool = mysql.createConnection({
        host: '127.0.0.1',
        user: 'worker',
        database: 'speedygad',
        password: 'worker',
        port: 3306
    }
);

const managerPool = mysql.createConnection({
        host: '127.0.0.1',
        user: 'manager',
        database: 'speedygad',
        password: 'manager',
        port: 3306
    }
);

const adminPool = mysql.createConnection({
        host: '127.0.0.1',
        user: 'admin',
        database: 'speedygad',
        password: 'admin',
        port: 3306
    }
);

module.exports = {appPool, workerPool, managerPool, adminPool};