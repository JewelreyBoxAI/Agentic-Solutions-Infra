# Impact Realty Tenant Configuration
env_name     = "impact-env"
app_name     = "impact-realty-app"
acr_name     = "impactrealtycr"
kv_name      = "impact-realty-kv"
cosmos_name  = "impact-realty-cosmos"
law_name     = "impact-realty-law"
agent_count  = 2
dapr_enabled = true

# Note: ACR credentials should be provided via environment variables or Azure Key Vault
# acr_username = "your-acr-username"
# acr_password = "your-acr-password"

tags = {
  Environment = "Production"
  Project     = "Agentic-Solutions"
  Tenant      = "impact-realty"
  Owner       = "Impact Realty Team"
} 