
# App Firewall
resource "volterra_app_firewall" arcadia_app_fw {
  name        = format("%s-app-fw-policy", var.web_app_name)
  namespace   = var.volterra_namespace
  description = format("App firewall for %s", var.web_app_name)
  allow_all_response_codes = true
  default_anonymization = true
  use_default_blocking_page = false
  default_bot_setting = false
  default_detection_settings = false
  use_loadbalancer_setting = true

  blocking = true

  blocking_page {
    response_code = "OK"
    blocking_page = "string:///PCFET0NUWVBFIGh0bWw+CjxodG1sIGNsYXNzPSIiIGxhbmc9ImVuIj4KPGhlYWQ+CjxzdHlsZT4KaW1nIHsKICBkaXNwbGF5OiBibG9jazsKICBtYXJnaW4tbGVmdDogYXV0bzsKICBtYXJnaW4tcmlnaHQ6IGF1dG87Cn0KPC9zdHlsZT4KPGJvZHk+CjxkaXYgc3R5bGU9IndpZHRoOjgwMHB4OyBtYXJnaW46MCBhdXRvOyI+CiAgPHAyIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlciI7PiA8aW1nIHNyYz0iaHR0cHM6Ly9nb29kLnZlcy5mb29iei5jb20uYXUvZjUucG5nIiBhbHQ9ImY1IiB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgY2xhc3M9ImNlbnRlciI+IDwvcDI+CiAgPGgxIHN0eWxlPSJ0ZXh0LWFsaWduOmNlbnRlcjsgY29sb3I6Ymx1ZTtmb250LXNpemU6MzBweDtmb250LWZhbWlseTphcmlhbDsiPgogICAgVGhhbmsgeW91IGZvciB5b3VyIHBhdGllbmNlIGFuZCB1bmRlcnN0YW5kaW5nLgogIDwvaDE+CiAgPHAgc3R5bGU9InRleHQtYWxpZ246Y2VudGVyOyBjb2xvcjpibGFjaztmb250LXNpemU6MjBweDtmb250LWZhbWlseTphcmlhbDsiPgogICAgVW5mb3J0dW5hdGVseSwgd2UgYXJlIHVuYWJsZSB0byBzZXJ2ZSB5b3UgcmlnaHQgbm93LiBQbGVhc2UgY29tZXMgYmFjayBsYXRlci4gWW91ciBzdXBwb3J0IElEIGlzICJ7e3JlcXVlc3RfaWR9fSIgd2hlbiB5b3UgY29udGFjdCB1cy4gPGEgaHJlZj0iamF2YXNjcmlwdDpoaXN0b3J5LmJhY2soKSI+W0dvIEJhY2tdPC9hPgogIDwvcD4KPGRpdj4gIAo8L2JvZHk+CjwvaHRtbD4="
  }
  detection_settings {
    signature_selection_setting {
      default_attack_type_settings = true
      high_medium_accuracy_signatures = true
    }
    enable_threat_campaigns = true
    default_violation_settings = true
    enable_suppression = true
  }

  bot_protection_setting {
    malicious_bot_action = "BLOCK"
    suspicious_bot_action = "REPORT"
    good_bot_action = "REPORT"
  }

}

