variable "api_url" {
    type = string
    default = "https://<your-tenant-id>.console.ves.volterra.io/api"

}

variable "api_cert" {
    type = string
    default = "./certificate.cert"
}

variable "api_key" {
  type = string
  default = "./private_key.key"
}

variable "web_app_name" {
  type        = string
  default     = "arcadia-dev"
  description = "Web App Name. Also used as a prefix in names of related resources."
}

variable "volterra_namespace_exists" {
  type        = string
  description = "Flag to create or use existing volterra namespace"
  default     = true
}

variable "volterra_namespace" {
  type        = string
  default     = "arcadia-dev"
  description = "F5XC app namespace where the object will be created. This cannot be system or shared ns."
}

variable "app_domain" {
  default      = ["arcadia-dev.edgecnf.com","backend.xcmesh.global","refer-friends.xcmesh.global","money-transfer.xcmesh.global"]
  description = "FQDN for the app."
}

variable "apigw_domain" {
  #type        = string
  default      = ["apigw-mt.xcmesh.global","apigw-rf.xcmesh.global","apigw-be.xcmesh.global"]
  description = "FQDN for the api-gw."
}

variable "ocp_sites" {
  default      = ["foobz-ves-ocp-au","foobz-ves-ocp-sg","foobz-ves-ocp-hk"]
  description = "OCP site where each microservices deployed."
}

variable "origin_server_sni" {
  type        = string
  description = "Origin server's SNI value"
  default     = ""
}

variable "enable_hsts" {
  type        = bool
  description = "Flag to enable hsts for HTTPS loadbalancer"
  default     = true
}

variable "enable_redirect" {
  type        = bool
  description = "Flag to enable http redirect to HTTPS loadbalancer"
  default     = true
}