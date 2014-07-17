define ruby_build::install($definition, $mirror = undef) {
	include ruby_build::base

	if !defined(Noop["ruby_build/definition/installed:${definition}"]) {
		noop { "ruby_build/definition/installed:${definition}": }
	}

	# This is a lot of effort just to work out which set of packages to
	# install
	if $definition =~ /^jruby/ {
		$pkg_flavour = "jruby"
	} else {
		$pkg_flavour = "vanilla"
	}

	case $operatingsystem {
		"Debian": {
			$os = "debian"
		}
		"RedHat","CentOS": {
			$os = "redhat"
		}
		default: {
			fail("ruby_build::install has not been taught how to install packages for ${operatingsystem}.  Please file a patch.")
		}
	}

	class { "ruby_build::packages::${os}_${pkg_flavour}": }

	# Let people use a local mirror for their tarball downloads if they so
	# choose.  Just remember that the files in this mirror need to be named
	# for the md5sum of the file, not the filename itself.
	if $mirror {
		$exec_env = ["RUBY_BUILD_MIRROR_URL=$mirror"]
	} else {
		$exec_env = []
	}

	# If multiple places ask for the same ruby-build definition, we'll
	# end up with multiple exec resources, but only one of them should
	# ever actually fire because of the `creates` parameter.  We hope.
	exec { "ruby_build-${definition}-for-${name}":
		command => "/usr/local/sbin/ruby-build-wrapper ${definition}",
		creates => "/usr/local/lib/rubies/${definition}",
		require => [ Noop["ruby_build/packages/installed"],
		             File["/usr/local/sbin/ruby-build-wrapper"]
		           ],
		before  => Noop["ruby_build/definition/installed:${definition}"],
		environment => $exec_env,
		# These builds can take a while, and I don't care how long they
		# take
		timeout => 0,
	}
}
