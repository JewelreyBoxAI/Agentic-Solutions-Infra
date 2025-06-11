# Yummy Image Media Tenant Configuration
env_name     = "yummy-env"
app_name     = "yummy-image-media-app"
acr_name     = "yummyimagemediacr"
kv_name      = "yummy-image-media-kv"
cosmos_name  = "yummy-image-media-cosmos"
law_name     = "yummy-image-media-law"
agent_count  = 3
dapr_enabled = true

# Note: ACR credentials should be provided via environment variables or Azure Key Vault
# acr_username = "your-acr-username"
# acr_password = "your-acr-password"

tags = {
  Environment = "Production"
  Project     = "Agentic-Solutions"
  Tenant      = "yummy-image-media"
  Owner       = "Yummy Image Media Team"
} 