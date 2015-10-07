class sortinghat::deps {
    package {
        [
            'python-jinja2',
            'python-dateutil',
        ]:
            ensure  => installed,
    }
}

class sortinghat {
    include tools::conf
    include sortinghat::deps

    $repo_path = "${tools::conf::path}/Sortinghat"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    file {
        $repo_path:
            ensure => 'directory',
    }

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/sortinghat.git',
            revision => 'master',
    }

    exec {
        'install sortinghat':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'],Package['python-mysqldb'],Package['python-sqlalchemy'],Package['python-jinja2'],Package['python-dateutil'],Vcsrepo[$repo_path] ],
    }
}
