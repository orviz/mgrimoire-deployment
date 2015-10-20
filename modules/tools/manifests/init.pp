class tools::conf {
    $tools_data = hiera_hash("tools")
    $path = $tools_data["path"]
}

class tools::essential {
    package {
        ["git",
         "python-pip"]:
            ensure => installed,
    }
}

class tools::r {
    package {
        ["r-base",
         "python-rpy2"]:
            ensure => installed,
    }
}

class tools {
    include tools::conf
    include tools::essential
    include tools::r

    file {
        $tools::conf::path:
            ensure => directory,
    }
}
