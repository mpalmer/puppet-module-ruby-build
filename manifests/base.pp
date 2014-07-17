class ruby_build::base {
	file {
		"/usr/local/bin/ruby-build":
			ensure  => file,
			source  => "puppet:///modules/ruby_build/usr/local/bin/ruby-build",
			links   => follow,
			mode    => 0555,
			owner   => "root",
			group   => "root";
		"/usr/local/sbin/ruby-build-wrapper":
			ensure  => file,
			source  => "puppet:///modules/ruby_build/usr/local/sbin/ruby-build-wrapper",
			mode    => 0555,
			owner   => "root",
			group   => "root",
			require => [ File["/usr/local/bin/ruby-build"],
			             File["/usr/local/share/ruby-build"],
			             File["/usr/local/lib/rubies"] ];
		"/usr/local/lib/rubies":
			ensure  => directory,
			mode    => 0755,
			owner   => "root",
			group   => "root";
		"/usr/local/share/ruby-build":
			ensure  => directory,
			source  => "puppet:///modules/ruby_build/usr/local/share/ruby-build",
			links   => follow,
			mode    => 0555,
			owner   => "root",
			group   => "root",
			recurse => true;
	}

	# This is the barrier that ensures that all the packages needed to build
	# are available *before* we try to actually build anything.
	noop { "ruby_build/packages/installed": }
}
