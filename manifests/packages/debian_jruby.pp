class ruby_build::packages::debian_jruby {
	if to_i($::operatingsystemrelease) < 6 {
		fail("ruby_build does not support Debian releases earlier than Squeeze (6.0)")
	}

	if to_i($::operatingsystemrelease) < 7 {
		$jre_package = "openjdk-6-jre-headless"
	} else {
		$jre_package = "openjdk-7-jre-headless"
	}

	$opts = { ensure => present,
	          before => Noop["ruby_build/packages/installed"]
	        }

	ensure_packages($jre_package, $opts)
}
