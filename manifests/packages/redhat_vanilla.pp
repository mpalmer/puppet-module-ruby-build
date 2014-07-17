class ruby_build::packages::redhat_vanilla {
	if to_i($::operatingsystemrelease) < 5 {
		fail("We don't support RHEL/CentOS older than 5.0")
	}
	
	$opts = { ensure => present,
	          before => Noop["ruby_build/packages/installed"]
	        }
	
	ensure_packages(["autoconf",
	                 "automake",
	                 "bison",
	                 "gawk",
	                 "gcc",
	                 "gcc-c++",
	                 "gdbm-devel",
	                 "git",
	                 "libffi-devel",
	                 "libtool",
	                 "libxml2-devel",
	                 "libxslt-devel",
	                 "libyaml-devel",
	                 "make",
	                 "ncurses-devel",
	                 "openssl-devel",
	                 "patch",
	                 "readline-devel",
	                 "sqlite-devel",
	                 "subversion",
	                 "tar",
	                 "zlib-devel"
	                ],
	                $opts)
}
	                
