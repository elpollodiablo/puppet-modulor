class modulor::environments::default {
  package {["less", "zsh", "vim-scripts", "vim-nox", "screen"]:
    ensure => installed
  }
}
