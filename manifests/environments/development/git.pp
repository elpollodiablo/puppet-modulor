class modulor::environments::development::git {
  package {["git"]:
    ensure => latest,
  }
}