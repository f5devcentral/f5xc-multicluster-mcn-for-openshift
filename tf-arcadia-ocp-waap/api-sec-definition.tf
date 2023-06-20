# API Definition for API Protection
resource "volterra_api_definition" "trading-apidef" {
  name      = format("%s-apidef", "trading")
  namespace = var.volterra_namespace

  swagger_specs = ["https://<your-tenant-id>.console.ves.volterra.io/api/object_store/namespaces/arcadia-dev/stored_objects/swagger/trading-api-oas3/v1-22-12-16"]
}

resource "volterra_api_definition" "money-transfer-apidef" {
  name      = format("%s-apidef", "money-transfer")
  namespace = var.volterra_namespace

  swagger_specs = ["https://<your-tenant-id>.console.ves.volterra.io/api/object_store/namespaces/arcadia-dev/stored_objects/swagger/money-transfer-api-oas3/v1-22-12-16"]
}

resource "volterra_api_definition" "backend-apidef" {
  name      = format("%s-apidef", "backend")
  namespace = var.volterra_namespace

  swagger_specs = ["https://<your-tenant-id>.console.ves.volterra.io/api/object_store/namespaces/arcadia-dev/stored_objects/swagger/backend-api-oas3/v1-22-12-16"]
}