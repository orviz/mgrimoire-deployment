class mariadb::conf {
    $mariadb_conf = hiera_hash("mariadb")
    $root_password = $mariadb_conf["password"]
    $db_user = $mariadb_conf["database"]["name"]
    $db_password = $mariadb_conf["database"]["password"]
}

class mariadb {
    include mariadb::server
    include mariadb::create_db
}

class mariadb::server {
    include mariadb::conf
    notify { "***** $mariadb::conf::root_password *****": }

    #$override_options = {
    #    'client' => {
    #        'user' => 'root',
    #        'host' => 'localhost',
    #        'password' => $mariadb::conf::root_password,
    #    }
    #}

    #class {
    #    '::mysql::server':
    #        root_password    => $mariadb::conf::root_password,
    #        package_name     => 'mariadb-server',
    #        override_options => $override_options,
    #}

    #class {
    #    '::mysql::client':
    #        package_name     => 'mariadb-client',
    #}
}

class mariadb::create_db {
    include mariadb::conf

    mysql::db {
        'testdb':
            user     => $mariadb::conf::db_user,
            password => $mariadb::conf::db_password,
            grant    => 'ALL',
    }
}
