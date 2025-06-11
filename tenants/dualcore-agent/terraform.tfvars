# DualCore Agent Tenant Configuration
tenant_name  = "dualcore-agent"
env_name     = "dualcore-agent-env"
app_name     = "dualcore-agent-app"
acr_name     = "dualcoreagentcr"
kv_name      = "dualcore-agent-kv"
postgresql_server_name = "dualcore-agent-pg"
database_name          = "dualcore_agents"
law_name     = "dualcore-agent-law"
agent_count  = 3
dapr_enabled = true

# Enhanced security controls (enabled by default for AI operations)
enable_enhanced_security = true

# AI Model Configuration
openai_model    = "gpt-4"
anthropic_model = "claude-3-sonnet-20240229"
max_tokens      = 4096
temperature     = 0.7
request_timeout = 30

# Note: API keys should be provided via environment variables or Azure Key Vault
# openai_api_key = "your-openai-api-key"
# anthropic_api_key = "your-anthropic-api-key"

# Note: PostgreSQL credentials should be provided via environment variables or Azure Key Vault
# postgresql_admin_username = "pgadmin"
# postgresql_admin_password = "your-secure-password"

# Note: ACR credentials should be provided via environment variables or Azure Key Vault
# acr_username = "your-acr-username"
# acr_password = "your-acr-password"

# Admin IP addresses for Key Vault access (replace with actual admin IPs)
# admin_ip_addresses = ["203.0.113.0/24"]

tags = {
  Environment = "Production"
  Project     = "Agentic-Solutions"
  Tenant      = "dualcore-agent"
  Owner       = "AI Operations Team"
  Purpose     = "Dual-Core AI Agent Platform"
  Component   = "Core Agent Infrastructure"
} 