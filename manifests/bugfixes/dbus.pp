class modulor::bugfixes::dbus {
	package {'dbus':
		ensure => latest,
	} -> service {'dbus':
		ensure => running,
	}
	file {"/lib/systemd/system/dbus.service":
		source => "puppet:///modules/modulor/dbus.service",
		notify => Service["dbus"],
	}
}
