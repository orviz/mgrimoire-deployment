class cvsanaly::deps {
    package {
        [
            "python-setuptools",
            "python-mysqldb",
        ]:
            ensure => installed,
    }
}

class cvsanaly {
    include tools::conf
    include cvsanaly::deps

    $repo_path = "${tools::conf::path}/CVSAnalY"
    $repository_handler_path = "${tools::conf::path}/RepositoryHandler"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/CVSAnalY.git',
            revision => 'master',
    }

    vcsrepo {
        $repository_handler_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/RepositoryHandler.git',
            revision => 'master',
    }

    exec {
        'install repositoryhandler':
            cwd     => $repository_handler_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'], Vcsrepo[$repository_handler_path] ],
    }

    exec {
        'install cvsanaly':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'],Vcsrepo[$repo_path] ],
    }
}
