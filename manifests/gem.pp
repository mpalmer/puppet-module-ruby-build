# Install a gem into a specific Ruby build.
#
# Attributes:
#
#  * `definition` (string; required)
#
#     The build definition of Ruby you wish to install the gem into.  Must
#     match up with a version of Ruby you've previously installed.
#
#  * `gem` (string; required)
#
#     The name of the gem to install.
#
#  * `version` (string; optional; default `undef`)
#
#     If set to something other than `undef`, it will be passed to the
#     `gem install` command's `-v` option.  This can be a generic version
#     specification, such as `~> 2.0`.
#
#  * `source` (string; optional; default `undef`)
#
#     Specify a custom source for gems.  Will be passed to the `gem install`
#     command's `--source` option.
#
#  * `docs` (boolean; optional; default `false`)
#
#     Docs often take a long time to build, and on server machines they're
#     so very, very rarely useful.  But, if you want them, you can set `docs
#     => true`.
#
define ruby_build::gem(
		$definition,
		$gem,
		$version = undef,
		$source  = undef,
		$docs    = false
) {
	include chruby::install

	if $version {
		$version_opt = shellquote('-v', $version)
	}

	if $source {
		$source_opt  = shellquote('--source', $source)
	}

	if !$docs {
		$docs_opt    = "--no-rdoc --no-ri"
	}

	$quoted_gem = shellquote($gem)

	exec { "Install ${gem} into ruby_build ${definition} for ${name}":
		command     => "/usr/local/bin/chruby-exec $definition -- gem install $quoted_gem $version_opt $source_opt $docs_opt",
		unless      => "/usr/bin/test $(/bin/bash -l -c 'chruby $definition && gem list --installed $quoted_gem $version_opt' 2>/dev/null) = true",
		require     => Noop["ruby_build/definition/installed:${definition}"],
		environment => "SHELL=/bin/bash",
	}
}
