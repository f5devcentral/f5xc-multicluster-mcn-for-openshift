## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.9, != 0.13.0 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | >=0.0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | >=0.0.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [volterra_api_definition.backend-apidef](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/api_definition) | resource |
| [volterra_api_definition.money-transfer-apidef](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/api_definition) | resource |
| [volterra_api_definition.trading-apidef](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/api_definition) | resource |
| [volterra_app_firewall.arcadia_app_fw](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/app_firewall) | resource |
| [volterra_healthcheck.healthcheck-backend](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/healthcheck) | resource |
| [volterra_healthcheck.healthcheck-frontend](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/healthcheck) | resource |
| [volterra_healthcheck.healthcheck-money-transfer](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/healthcheck) | resource |
| [volterra_healthcheck.healthcheck-refer-friends](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/healthcheck) | resource |
| [volterra_http_loadbalancer.apigw-backend-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.apigw-mt-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.apigw-refer-friends-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.backend-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.frontend-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.money-transfer-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_http_loadbalancer.refer-friends-lb](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/http_loadbalancer) | resource |
| [volterra_origin_pool.backend_pool](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |
| [volterra_origin_pool.frontend_pool](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |
| [volterra_origin_pool.money_transfer_pool](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |
| [volterra_origin_pool.refer_friends_pool](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_cert"></a> [api\_cert](#input\_api\_cert) | n/a | `string` | `"./certificate.cert"` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | n/a | `string` | `"./private_key.key"` | no |
| <a name="input_api_url"></a> [api\_url](#input\_api\_url) | n/a | `string` | `"https://f5-apac-sp.console.ves.volterra.io/api"` | no |
| <a name="input_apigw_domain"></a> [apigw\_domain](#input\_apigw\_domain) | FQDN for the api-gw. | `list` | <pre>[<br>  "apigw-mt.xcmesh.global",<br>  "apigw-rf.xcmesh.global",<br>  "apigw-be.xcmesh.global"<br>]</pre> | no |
| <a name="input_app_domain"></a> [app\_domain](#input\_app\_domain) | FQDN for the app. | `list` | <pre>[<br>  "arcadia-dev.edgecnf.com",<br>  "backend.xcmesh.global",<br>  "refer-friends.xcmesh.global",<br>  "money-transfer.xcmesh.global"<br>]</pre> | no |
| <a name="input_enable_hsts"></a> [enable\_hsts](#input\_enable\_hsts) | Flag to enable hsts for HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_enable_redirect"></a> [enable\_redirect](#input\_enable\_redirect) | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_ocp_sites"></a> [ocp\_sites](#input\_ocp\_sites) | OCP site where each microservices deployed. | `list` | <pre>[<br>  "foobz-ves-ocp-au",<br>  "foobz-ves-ocp-sg",<br>  "foobz-ves-ocp-hk"<br>]</pre> | no |
| <a name="input_origin_server_sni"></a> [origin\_server\_sni](#input\_origin\_server\_sni) | Origin server's SNI value | `string` | `""` | no |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | F5XC app namespace where the object will be created. This cannot be system or shared ns. | `string` | `"arcadia-dev"` | no |
| <a name="input_volterra_namespace_exists"></a> [volterra\_namespace\_exists](#input\_volterra\_namespace\_exists) | Flag to create or use existing volterra namespace | `string` | `true` | no |
| <a name="input_web_app_name"></a> [web\_app\_name](#input\_web\_app\_name) | Web App Name. Also used as a prefix in names of related resources. | `string` | `"arcadia-dev"` | no |

## Outputs

No outputs.
