terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ai_rg" {
  name     = "ai-services-rg"
  location = var.region
  tags = {
    environment = "survey_analyzer"
  }
}