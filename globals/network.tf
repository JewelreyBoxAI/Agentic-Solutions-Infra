terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "AgenticInfra-rg"
  location = "East US"

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "agentic-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
  }
}

resource "azurerm_subnet" "infra" {
  name                 = "subnet-infra"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "agents" {
  name                 = "subnet-agents"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# HIPAA Enhancement: Private endpoints subnet
resource "azurerm_subnet" "private_endpoints" {
  name                 = "subnet-private-endpoints"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
  
  # Enable private endpoint network policies
  private_endpoint_network_policies_enabled = false
}

# HIPAA Enhancement: Database subnet for Cosmos DB
resource "azurerm_subnet" "database" {
  name                 = "subnet-database"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]
  
  # Enable service endpoints for Cosmos DB
  service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_network_security_group" "main" {
  name                = "agentic-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowDaprHTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3500"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowDaprGRPC"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50001"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  # HIPAA Enhancement: Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HIPAA Enhancement: Block internet outbound except necessary
  security_rule {
    name                       = "AllowAzureServicesOutbound"
    priority                   = 1005
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "AzureCloud"
  }

  security_rule {
    name                       = "DenyInternetOutbound"
    priority                   = 4001
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
  }
}

resource "azurerm_subnet_network_security_group_association" "infra" {
  subnet_id                 = azurerm_subnet.infra.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "agents" {
  subnet_id                 = azurerm_subnet.agents.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# HIPAA Enhancement: Network Watcher for audit logging
resource "azurerm_network_watcher" "main" {
  name                = "agentic-network-watcher"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Purpose     = "HIPAA-Compliance"
  }
}

# HIPAA Enhancement: Action group for security alerts
resource "azurerm_monitor_action_group" "hipaa_security" {
  name                = "agentic-hipaa-security-alerts"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "hipaa-sec"

  email_receiver {
    name          = "security-team"
    email_address = "security@agentic.solutions"
  }

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Purpose     = "HIPAA-SecurityAlerts"
  }
} 