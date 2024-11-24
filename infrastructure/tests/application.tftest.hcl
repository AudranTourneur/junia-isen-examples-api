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

run "application_is_running" {
  command = plan

  module {
    source = "./tests/http"
  }

  variables {
    url = "https://${run.create_app.url}"
  }

  assert {
    condition     = data.http.endpoint.status_code == 200
    error_message = "Application / endpoint is not answering correctly (status code: ${data.http.endpoint.status_code})"
  }
}
