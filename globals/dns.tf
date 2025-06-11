resource "azurerm_dns_zone" "main" {
  name                = "agentic.solutions.local"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
  }
}

resource "azurerm_dns_a_record" "impact" {
  name                = "impact"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = ["10.0.1.100"]  # Placeholder IP

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Tenant      = "impact-realty"
  }
}

resource "azurerm_dns_a_record" "yummy" {
  name                = "yummy"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = ["10.0.1.101"]  # Placeholder IP

  tags = {
    Environment = "Production"
    Project     = "Agentic-Solutions"
    Tenant      = "yummy-image-media"
  }
} 