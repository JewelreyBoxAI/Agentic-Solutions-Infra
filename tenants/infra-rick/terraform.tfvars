# Infra-Rick Tenant Configuration
tenant_name  = "infra-rick"
env_name     = "infra-rick-env"
app_name     = "infra-rick-app"
acr_name     = "infrarickcr"
kv_name      = "infra-rick-kv"
postgresql_server_name = "infra-rick-pg"
database_name          = "infrastructure_monitoring"
law_name     = "infra-rick-law"
agent_count  = 2
dapr_enabled = true

# Enhanced security controls (set to true for production)
enable_enhanced_security = false

# Note: ACR credentials should be provided via environment variables or Azure Key Vault
# acr_username = "your-acr-username"
# acr_password = "your-acr-password"

# Note: PostgreSQL credentials should be provided via environment variables or Azure Key Vault
# postgresql_admin_username = "pgadmin"
# postgresql_admin_password = "your-secure-password"

# Admin IP addresses for Key Vault access (replace with actual admin IPs)
# admin_ip_addresses = ["203.0.113.0/24"]

tags = {
  Environment = "Production"
  Project     = "Agentic-Solutions"
  Tenant      = "infra-rick"
  Owner       = "Rick Infrastructure Team"
  Department  = "Infrastructure"
} 