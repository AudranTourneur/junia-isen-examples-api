run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "create_app" {
  command = apply

  variables {
    resource_group_name = "app-for-test-${run.setup_tests.app_name}"
  }
  
}
