class modulor::environments::development::python {
  include modulor::environments::development::build
  include modulor::environments::development::git
  package { ["python-virtualenv", "python-dev"]:
    ensure => latest,
  }
}