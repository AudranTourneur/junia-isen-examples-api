output "url" {
    description = "The primary endpoint where the blob storage is accessible"
    value = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_account_id" {
    description = "The ID of the storage account"
    value = azurerm_storage_account.main.id
}