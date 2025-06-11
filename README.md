# Agentic Solutions Infrastructure

This repository contains the Terraform infrastructure as code (IaC) for the Agentic Solutions platform, providing multi-tenant Azure Container Apps environments with supporting services.

## Project Overview

The infrastructure supports multiple tenants with isolated resources while sharing common global infrastructure components:

- **Container Apps**: Serverless containerized applications with Dapr integration
- **Cosmos DB**: Serverless NoSQL database for each tenant
- **Key Vault**: Secure secrets management per tenant
- **Log Analytics**: Centralized logging and monitoring
- **Virtual Network**: Shared networking infrastructure
- **DNS**: Custom domain management

## Architecture

```
AIsrc/Agentic-Solutions-Infra/
├── modules/                    # Reusable Terraform modules
│   ├── container-app/         # Azure Container Apps with Dapr
│   ├── keyvault/             # Azure Key Vault
│   ├── cosmosdb/             # Azure Cosmos DB (Serverless)
│   ├── log-analytics/        # Log Analytics workspace
│   └── hipaa-security/       # HIPAA compliance security controls
├── globals/                   # Shared global infrastructure
│   ├── backend.tf            # Terraform state configuration
│   ├── network.tf            # VNet, subnets, NSG
│   └── dns.tf                # DNS zones and records
├── tenants/                  # Tenant-specific deployments
│   ├── impact-realty/        # Impact Realty tenant
│   ├── yummy-image-media/    # Yummy Image Media tenant
│   ├── infra-rick/           # Infrastructure maintenance tenant (powered by DualCoreAgent)
│   ├── dualcore-agent/       # Core AI agent platform tenant
│   └── hipaa-healthcare/     # HIPAA-compliant healthcare tenant
├── pipelines/                # CI/CD workflows
│   └── deploy-infra.yml      # GitHub Actions deployment
└── README.md                 # This file
```

## Prerequisites

### Azure Setup

1. **Azure Subscription**: Active Azure subscription with sufficient permissions
2. **Service Principal**: Create service principal for Terraform authentication
3. **Storage Account**: Azure Storage Account for Terraform state (must be created manually)

### Required Azure Resources (Manual Setup)

Before running Terraform, create these resources manually:

```bash
# Create resource group for Terraform state
az group create --name "AgenticInfra-rg" --location "East US"

# Create storage account for Terraform state
az storage account create \
  --name "agenticsolsstg" \
  --resource-group "AgenticInfra-rg" \
  --location "East US" \
  --sku "Standard_LRS"

# Create storage container
az storage container create \
  --name "tfstate" \
  --account-name "agenticsolsstg"
```

### Service Principal Credentials

Create a service principal and configure the following GitHub secrets:

```bash
# Create service principal
az ad sp create-for-rbac --name "terraform-agentic-solutions" \
  --role="Contributor" \
  --scopes="/subscriptions/{subscription-id}"
```

Configure these GitHub repository secrets:
- `AZURE_CLIENT_ID`: Service principal application ID
- `AZURE_CLIENT_SECRET`: Service principal password
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID
- `AZURE_TENANT_ID`: Azure tenant ID
- `ACR_USERNAME`: Azure Container Registry username
- `ACR_PASSWORD`: Azure Container Registry password

## Deployment

### 1. Deploy Global Infrastructure

Deploy shared infrastructure first:

1. Navigate to **Actions** tab in GitHub
2. Select **Deploy Infrastructure** workflow
3. Click **Run workflow**
4. Select:
   - **Tenant**: `globals`
   - **Action**: `plan` (review first), then `apply`

### 2. Deploy Tenant Infrastructure

Deploy tenant-specific resources:

1. Run the workflow again with:
   - **Tenant**: `impact-realty`, `yummy-image-media`, `infra-rick`, `dualcore-agent`, or `hipaa-healthcare`
   - **Action**: `plan` (review first), then `apply`

### Local Development

For local development and testing:

```bash
# Set environment variables
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
export TF_VAR_acr_username="your-acr-username"
export TF_VAR_acr_password="your-acr-password"

# Deploy globals
cd globals/
terraform init
terraform plan
terraform apply

# Deploy tenant
cd ../tenants/impact-realty/
terraform init
terraform plan
terraform apply
```

## Tenant Configuration

### Adding New Tenants

1. Create new directory under `tenants/`
2. Copy structure from existing tenant
3. Update variables and naming conventions
4. Add DNS record in `globals/dns.tf`
5. Update GitHub Actions workflow if needed

### Tenant Naming Conventions

- **Environment Name**: `{tenant}-env`
- **App Name**: `{tenant}-app`
- **Key Vault**: `{tenant}-kv`
- **Cosmos DB**: `{tenant}-cosmos`
- **Log Analytics**: `{tenant}-law`
- **ACR**: `{tenant}cr` (no hyphens, lowercase)

## Resource Management

### Global vs Tenant Resources

**Global Resources** (managed in `globals/`):
- Resource Group: `AgenticInfra-rg`
- Virtual Network: `agentic-vnet`
- Subnets: `subnet-infra`, `subnet-agents`
- Network Security Group
- DNS Zone: `agentic.solutions.local`

**Tenant Resources** (managed in `tenants/{tenant}/`):
- Container App Environment
- Container Apps
- Key Vault
- Cosmos DB Account
- Log Analytics Workspace
- Application Insights (if Dapr enabled)

### State Management

- **Global State**: `globals.tfstate`
- **Tenant State**: `{tenant}.tfstate`

Each deployment maintains separate state files in Azure Storage.

## Security Considerations

1. **Key Vault**: All secrets stored in tenant-specific Key Vaults
2. **Network Security**: NSG rules restrict traffic to necessary ports
3. **Container Registry**: Credentials managed via GitHub secrets
4. **RBAC**: Service principal has Contributor access scope
5. **State Security**: Terraform state stored in secured Azure Storage

## Monitoring and Logging

- **Log Analytics**: Centralized logging for Container Apps
- **Application Insights**: Performance monitoring (when Dapr enabled)
- **Container App Logs**: Available through Azure portal and CLI
- **Dapr Observability**: Integrated with Application Insights

## Troubleshooting

### Common Issues

1. **State Lock**: If Terraform state is locked, wait or manually release
2. **Naming Conflicts**: Ensure resource names are globally unique
3. **Permissions**: Verify service principal has sufficient permissions
4. **ACR Access**: Confirm Container Registry credentials are correct

### Debugging Commands

```bash
# Check Terraform state
terraform state list
terraform state show <resource>

# Validate configuration
terraform validate
terraform fmt -check

# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

## Contributing

1. **Global Changes**: Modify files in `globals/` directory
2. **Module Changes**: Update modules in `modules/` directory
3. **Tenant Changes**: Modify specific tenant configurations
4. **Testing**: Always run `terraform plan` before `apply`
5. **Documentation**: Update README when adding new features

## HIPAA Compliance

This infrastructure includes comprehensive HIPAA compliance features for healthcare tenants:

### HIPAA-Ready Features
- **Customer-managed encryption** with Azure Key Vault
- **Network microsegmentation** with private endpoints
- **Comprehensive audit logging** for all access and changes
- **Data retention policies** meeting 6+ year requirements
- **Backup and recovery** with geo-redundant storage
- **Real-time security monitoring** and alerting
- **Access controls** with least privilege principles

### HIPAA Deployment
```bash
# Deploy HIPAA-compliant healthcare tenant
cd tenants/hipaa-healthcare/
terraform init
terraform plan -var="security_contact_email=security@your-org.com"
terraform apply
```

For detailed HIPAA compliance information, see [HIPAA-COMPLIANCE.md](./HIPAA-COMPLIANCE.md).

## Support

For issues and questions:
1. Check existing GitHub Issues
2. Create new issue with detailed description
3. Include Terraform output and error messages
4. Specify affected tenant and resources

### HIPAA Support
For HIPAA compliance questions:
- Review [HIPAA-COMPLIANCE.md](./HIPAA-COMPLIANCE.md)
- Contact: compliance@agentic.solutions
- Security incidents: security@agentic.solutions 