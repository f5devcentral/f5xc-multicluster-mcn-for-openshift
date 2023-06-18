resource "volterra_origin_pool" money_transfer_pool {
  name                   = format("%s-money-transfer-pool", var.web_app_name)
  namespace              = var.volterra_namespace
  description            = format("Origin pool for money-transfer services for %s", var.app_domain[0])
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      service_name    = format("money-transfer.%s",var.volterra_namespace)
      site_locator {
        site {
          name      = var.ocp_sites[2]
          namespace = "system"
        }
      }
      outside_network = true
    }
  }
    healthcheck {
    namespace = var.volterra_namespace
    name = volterra_healthcheck.healthcheck-money-transfer.name
  }
  port               = 80
  endpoint_selection = "LOCAL_PREFERRED"
}

# HTTP Load Balancer for money-transfer.cloud
resource "volterra_http_loadbalancer" money-transfer-lb {
  name                            = format("%s-money-transfer-lb", var.web_app_name)
  namespace                       = var.volterra_namespace
  description                     = format("HTTPS loadbalancer for money transfer microservices")
  domains                         = [var.app_domain[3]]
  #labels = {
  #  "ves.io/app_type" = var.volterra_namespace
  #}
  http {
    dns_volterra_managed = false
    port = 80
  }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.money_transfer_pool.name
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
  }
 add_location = true
}

# Health Check
resource "volterra_healthcheck" "healthcheck-money-transfer" {
  name    = "healthcheck-http-money-transfer"
  namespace   = var.volterra_namespace

  http_health_check {
    use_origin_server_name = true
    path                   = "/money-transfer/status"
    use_http2              = false
  }

  healthy_threshold   = "3"
  interval            = "15"
  timeout             = "3"
  unhealthy_threshold = "1"
}


# API GW
# HTTP Load Balancer for money-transfer.cloud
resource "volterra_http_loadbalancer" apigw-mt-lb {
  name                            = format("%s-money-transfer-lb", "apigw")
  namespace                       = var.volterra_namespace
  description                     = format("HTTPS loadbalancer for APIGW for money transfer microservices")
  domains                         = [var.apigw_domain[0]]
  #labels = {
  #  "ves.io/app_type" = var.volterra_namespace
  #}
  http {
    dns_volterra_managed = false
    port = 80
  }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.money_transfer_pool.name
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
      name       = format("%s-apidef", "money-transfer")
      namespace  = var.volterra_namespace
    }  
  }

}