class sibyl::deps {
    package {
        [
            'python-sqlalchemy',
            'python-requests',
            'python-beautifulsoup',
        ]:
                ensure  => installed,
    }
}

class sibyl {
    include tools::conf
    include sibyl::deps

    $repo_path = ${tools::conf}/Sibyl
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/Sibyl.git',
            revision => 'master',
    }

    exec {
        'install sibyl':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'],Vcsrepo[$repo_path] ],
    }
}
