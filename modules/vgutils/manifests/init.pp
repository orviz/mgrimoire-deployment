class vgutils {
    vgutils::cran::package{"RMySQL": ensure => present}
    vgutils::cran::package{"RColorBrewer": ensure => present}
    vgutils::cran::package{"ggplot2": ensure => present}
    vgutils::cran::package{"rgl": ensure => present}
    vgutils::cran::package{"optparse": ensure => present}
    vgutils::cran::package{"ISOweek": ensure => present}
    vgutils::cran::package{"zoo": ensure => present}

    vgutils::cran::package_from_source{"http://cran.rstudio.com/src/contrib/Archive/rjson/rjson_0.2.13.tar.gz": ensure => present}
}


# https://github.com/ashish1099/puppet-r
define vgutils::cran::package (
    $repo = 'http://cran.rstudio.com',
    $dependencies = "TRUE",
    $ensure = 'present' ) {

        #Exec { require => Class['r'] }
        exec { "updating_r_packages_$name" : command => "/usr/bin/R -q -e \"update.packages(repos='$repo', checkBuilt=TRUE, ask=FALSE)\"", refreshonly => true }
        case $ensure {
            present : { exec { "install_r_package_$name" :
                command => "/usr/bin/R -q -e \"install.packages('$name', repos='$repo', dependencies = $dependencies)\"",
                unless => "/usr/bin/R -q -e '\"$name\" %in% installed.packages()' | grep 'TRUE'",
                notify => Exec["updating_r_packages_$name"] } }
            absent : { exec { "uninstalling_r_package_$name" :
                command => "/usr/bin/R -q -e \"remove.packages('$name')\"",
                unless => "/usr/bin/R -q -e '\"$name\" %in% installed.packages()' | grep 'FALSE'",
                notify => Exec["updating_r_packages_$name"] } }
            default : { err ( "Something has failed, Please check" ) }
        }
}

define vgutils::cran::package_from_source (
    $repo = 'http://cran.rstudio.com',
    $dependencies = "TRUE",
    $ensure = 'present' ) {

        #Exec { require => Class['r'] }
        exec { "updating_r_packages_$name" : command => "/usr/bin/R -q -e \"update.packages(repos='$repo', checkBuilt=TRUE, ask=FALSE)\"", refreshonly => true }
        case $ensure {
            present : { exec { "install_r_package_$name" :
                command => "/usr/bin/R -q -e \"install.packages('$name', repos='$repo', dependencies = $dependencies, type='source')\"",
                unless => "/usr/bin/R -q -e '\"$name\" %in% installed.packages()' | grep 'TRUE'",
                notify => Exec["updating_r_packages_$name"] } }
            absent : { exec { "uninstalling_r_package_$name" :
                command => "/usr/bin/R -q -e \"remove.packages('$name')\"",
                unless => "/usr/bin/R -q -e '\"$name\" %in% installed.packages()' | grep 'FALSE'",
                notify => Exec["updating_r_packages_$name"] } }
            default : { err ( "Something has failed, Please check" ) }
        }
}
