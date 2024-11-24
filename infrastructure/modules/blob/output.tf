output "url" {
    description = "The primary endpoint where the blob storage is accessible"
    value = azurerm_storage_account.main.primary_blob_endpoint
}
