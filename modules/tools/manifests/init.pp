class tools::conf {
    $tools_data = hiera_hash("tools")
    $path = $tools_data["path"]
}

class tools {
    include tools::conf

    package {
        ["git",
         "python-pip"]:
            ensure => installed,
    }

    file {
        $tools::conf::path:
            ensure => directory,
    }
}
