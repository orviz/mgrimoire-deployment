class cmetrics::deps {
    class {
        "cmetrics::deps::tools":
    }

    class {
        "cmetrics::deps::autoconf":
            require => Class["cmetrics::deps::tools"],
    }
    class {
        "cmetrics::deps::automake":
            require => [Class["cmetrics::deps::tools"],
                        Class["cmetrics::deps::autoconf"]]
    }
}

class cmetrics::deps::tools {
    package {
        [
            "make",
            "gcc",
            "m4",
            "flex",
        ]:
                ensure  => installed,
    }
}

class cmetrics::deps::autoconf {
    exec {
        "download autoconf":
            command => "wget http://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.62.tar.gz -O /tmp/autoconf-2.62.tar.gz",
            path    => $path,
    }

    exec {
        "extract autoconf":
            cwd     => "/tmp",
            command => "tar xvfz /tmp/autoconf-2.62.tar.gz",
            path    => $path,
    }

    exec {
        "deploy autoconf":
            cwd     => "/tmp/autoconf-2.62",
            command => "/tmp/autoconf-2.62/configure && make && make install",
            path    => $path,
    }
}

class cmetrics::deps::automake {
    exec {
        "download automake":
            command => "wget http://ftp.gnu.org/pub/gnu/automake/automake-1.11.tar.gz -O /tmp/automake-1.11.tar.gz",
            path    => $path,
    }

    exec {
        "extract automake":
            cwd     => "/tmp",
            command => "tar xvfz automake-1.11.tar.gz",
            path    => $path,
    }

    exec {
        "deploy automake":
            cwd     => "/tmp/automake-1.11",
            command => "/tmp/automake-1.11/configure && make && make install",
            path    => $path,
    }
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
            command => "${repo_path}/autogen.sh && make && make install",
            path    => $path,
            require => [Vcsrepo[$repo_path],
                        Class["cmetrics::deps::autoconf"],
                        Class["cmetrics::deps::automake"]],
    }
}
