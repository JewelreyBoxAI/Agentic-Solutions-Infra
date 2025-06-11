resource "azurerm_container_app_environment" "main" {
  name                       = var.env_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dapr_application_insights_connection_string = var.dapr_enabled ? azurerm_application_insights.main[0].connection_string : null

  tags = var.tags
}

resource "azurerm_application_insights" "main" {
  count               = var.dapr_enabled ? 1 : 0
  name                = "${var.env_name}-appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = var.tags
}

resource "azurerm_container_app" "main" {
  name                         = var.app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.app_name
      image  = "${var.acr_name}.azurecr.io/${var.image_name}:${var.image_tag}"
      cpu    = var.cpu
      memory = var.memory

      env {
        name  = "POSTGRESQL_SERVER"
        value = var.postgresql_server_name
      }

      env {
        name        = "POSTGRESQL_CONNECTION_STRING"
        secret_name = "postgresql-connection-string"
      }

      env {
        name  = "VECTOR_DATABASE_NAME"
        value = var.vector_database_name
      }

      env {
        name        = "KEYVAULT_URL"
        value       = var.keyvault_url
      }
    }
  }

  secret {
    name  = "postgresql-connection-string"
    value = var.postgresql_connection_string
  }

  dynamic "dapr" {
    for_each = var.dapr_enabled ? [1] : []
    content {
      app_id       = var.app_name
      app_protocol = "http"
      app_port     = var.app_port
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = var.app_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  registry {
    server   = "${var.acr_name}.azurecr.io"
    username = var.acr_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.acr_password
  }

  tags = var.tags
} 