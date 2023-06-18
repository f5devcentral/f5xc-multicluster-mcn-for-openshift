
resource "volterra_origin_pool" backend_pool {
  name                   = format("%s-backend-pool", var.web_app_name)
  namespace              = var.volterra_namespace
  description            = format("Origin pool for backend services for %s", var.app_domain[0])
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      #vk8s_networks   = true
      service_name    = format("backend.%s",var.volterra_namespace)
      site_locator {
        site {
          name      = var.ocp_sites[1]
          namespace = "system"
        }
      }
      outside_network = true
    }
  }

  healthcheck {
    namespace = var.volterra_namespace
    name = volterra_healthcheck.healthcheck-backend.name
  }

  port               = 80
  endpoint_selection = "LOCAL_PREFERRED"
}


# HTTP Load Balancer for backend
resource "volterra_http_loadbalancer" backend-lb {
  name                            = format("%s-backend-lb", var.web_app_name)
  namespace                       = var.volterra_namespace
  description                     = format("HTTPS loadbalancer for backend")
  domains                         = [var.app_domain[1]]
  #labels = {
  #  "ves.io/app_type" = var.volterra_namespace
  #}
  http {
    dns_volterra_managed = false
    port = 80
  }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.backend_pool.name
      namespace = var.volterra_namespace
    }
    weight = 1
    priority = 1
  }
  advertise_custom {
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name = var.ocp_sites[0]
        }
      } 
    }
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name = var.ocp_sites[2]
        }
      } 
    }
  }
 add_location = true
}

# Health Check
resource "volterra_healthcheck" "healthcheck-backend" {
  name    = "healthcheck-http-backend"
  namespace   = var.volterra_namespace

  http_health_check {
    use_origin_server_name = true
    path                   = "/files/status"
    use_http2              = false
  }

  healthy_threshold   = "3"
  interval            = "15"
  timeout             = "3"
  unhealthy_threshold = "1"
}


# API GW Backend
# HTTP Load Balancer for backend
resource "volterra_http_loadbalancer" apigw-backend-lb {
  name                            = format("%s-backend-lb", "apigw")
  namespace                       = var.volterra_namespace
  description                     = format("HTTPS loadbalancer for API GW to backend")
  domains                         = [var.apigw_domain[2]]
  #labels = {
  #  "ves.io/app_type" = var.volterra_namespace
  #}
  http {
    dns_volterra_managed = false
    port = 80
  }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.backend_pool.name
      namespace = var.volterra_namespace
    }
    weight = 1
    priority = 1
  }
  advertise_custom {
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name = var.ocp_sites[0]
        }
      } 
    }
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          namespace = "system"
          name = var.ocp_sites[2]
        }
      } 
    }
  }

  enable_api_discovery {
    enable_learn_from_redirect_traffic = true
  }

  app_firewall {
    name = volterra_app_firewall.arcadia_app_fw.name
  }

  add_location = true

  api_definitions {
    api_definitions {
      name       = format("%s-apidef", "backend")
      namespace  = var.volterra_namespace
    }  
  }
}