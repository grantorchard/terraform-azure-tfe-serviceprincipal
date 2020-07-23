output ARM_SUBSCRIPTION_ID {
  value = split("/", data.azurerm_subscription.primary.id)[2]
}

output ARM_CLIENT_ID {
  value = azuread_application.this.application_id
}

output ARM_CLIENT_SECRET {
  value = azuread_application_password.this.value
}

output ARM_TENANT_ID {
  value = data.azurerm_subscription.primary.tenant_id
}