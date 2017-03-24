class modulor::environments::development::build {
  include modulor::environments::development::git
  package { ["build-essential"]:
    ensure => latest,
  }
}