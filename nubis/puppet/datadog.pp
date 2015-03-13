class { 'datadog_agent':
    api_key => "%%DATADOG_API_KEY%%",
}

include 'datadog_agent::integrations::process'
