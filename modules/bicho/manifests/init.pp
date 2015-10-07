class bicho::deps {
}

class bicho {
    include tools::conf
    include bicho::deps

    $repo_path = "${tools::conf::path}/Bicho"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    file {
        $repo_path:
            ensure => 'directory',
    }

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/Bicho.git',
            revision => 'master',
    }

    exec {
        'install bicho':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'], Vcsrepo[$repo_path] ],
    }
}
