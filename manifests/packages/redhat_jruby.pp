class ruby_build::packages::redhat_jruby {
	if to_i($::operatingsystemrelease) < 5 {
		fail("ruby_build does not support RHEL/CentOS older than 5.0")
	}
	
	$opts = { ensure => present,
	          before => Noop["ruby_build/packages/installed"]
	        }

	ensure_packages("java-1.7.0-openjdk", $opts)
}
