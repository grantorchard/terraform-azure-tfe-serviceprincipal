provider "azurerm" {
  features {}
}

data azurerm_subscription "primary" {}


resource azuread_application "this" {
  name                       = "tfe-go-${random_string.this.result}"
  identifier_uris            = []
  reply_urls                 = []
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
  type                       = "webapp/api"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
        id   = "5b567255-7703-4780-807c-7be8301ae99b"
        type = "Role"
    }
  }
  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
        id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
        type = "Scope"
            }
    resource_access {
        id   = "6234d376-f627-4f0f-90e0-dff25c5211a3"
        type = "Scope"
            }
    resource_access {
        id   = "c582532d-9d9e-43bd-a97c-2667a28ce295"
        type = "Scope"
            }
    resource_access {
        id   = "1cda74f2-2616-4834-b122-5cb1b07f8a59"
        type = "Role"
            }
        }
}

resource random_string "this" {
  length  = 8
  special = false
  upper   = false
}

resource random_password "this" {
  length  = 32
  special = true
}

resource azuread_service_principal "this" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
}

resource azuread_application_password "this" {
  application_object_id = azuread_application.this.id
  value                = random_password.this.result
  end_date              = timeadd(timestamp(), "8766h")
  lifecycle {
    ignore_changes = [end_date]
  }
}

resource azurerm_role_assignment "this" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.this.id
}

resource azurerm_role_assignment "temp" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id       = azuread_service_principal.this.id
}