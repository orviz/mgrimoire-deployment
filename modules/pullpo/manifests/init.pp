class pullpo::deps {
    package {
        ["github3.py"]:
            ensure   => installed,
            provider => pip,
            require  => Package["python-pip"],
    }
}

class pullpo {
    include tools::conf
    include pullpo::deps

    $repo_path = "${tools::conf::path}/Pullpo"
    #$github3_py_path = "${tools::conf::path}/github3.py"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/Pullpo.git',
            revision => 'master',
    }

    #vcsrepo {
    #    $github3_py_path:
    #        ensure   => present,
    #        provider => git,
    #        source   => 'https://github.com/github3py/github3.py',
    #        revision => 'master',
    #}

    #exec {
    #    'install github3.py':
    #        cwd     => $github3_py_path,
    #        command => 'python setup.py install',
    #        path    => $path,
    #        require => [ Package['python-setuptools'], Vcsrepo[$repository_handler_path] ],
    #}

    exec {
        'install pullpo':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['github3.py'], Vcsrepo[$repo_path] ],
    }

}
