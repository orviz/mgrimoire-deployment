class mlstats::deps {
    package {
        [
            "python-sqlalchemy",
        ]:
             ensure  => installed,
    }
}

class mlstats {
    include tools::conf
    include mlstats::deps

    $repo_path = "${tools::conf::path}/MailingListStats"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/MailingListStats.git',
            #revision => '3a308fd9a6337ceca0056d6c459c87f4c12e4a55',
            revision => 'master',
    }

    exec {
        'install mlstats':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'], Vcsrepo[$repo_path] ],
    }
}
