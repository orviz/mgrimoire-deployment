class cmetrics::deps {
}

class cmetrics {
    include tools::conf
    include cmetrics::deps

    $repo_path = "${tools::conf::path}/CMetrics"
    $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin']

    file {
        $repo_path:
            ensure => 'directory',
    }

    vcsrepo {
        $repo_path:
            ensure   => present,
            provider => git,
            source   => 'https://github.com/MetricsGrimoire/CMetrics.git',
            revision => 'master',
    }

    exec {
        'install CMetrics':
            cwd     => $repo_path,
            command => 'python setup.py install',
            path    => $path,
            require => [ Package['python-setuptools'], Vcsrepo[$repo_path] ],
    }
}
