<#
.SYNOPSIS
  Automatically finds the primary network adapter and sets a static DNS server.

.DESCRIPTION
  This script must be run with Administrator privileges.
  It identifies the primary adapter by finding the active connection that has an
  IPv4 Default Gateway configured. It then sets the DNS and verifies the change.
#>

# --- Step 1: Define the new DNS server IP ---
$NewDnsServer = "192.168.109.133"

# --- Step 2: Automatically find the primary network adapter ---
Write-Host "Finding the primary network adapter..." -ForegroundColor Yellow
try {
    # This pipeline finds the adapter that is UP and has a default gateway.
    $PrimaryAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1

    # Check if an adapter was found
    if ($null -ne $PrimaryAdapter) {
        $AdapterName = $PrimaryAdapter.InterfaceAlias
        Write-Host "Found primary adapter: '$AdapterName'" -ForegroundColor Green

        # --- Step 3: Set the new DNS server ---
        Write-Host "Setting DNS for '$AdapterName' to $NewDnsServer..." -ForegroundColor Cyan
        Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses $NewDnsServer

        # --- Step 4: Verify the change ---
        Write-Host "Verification:" -ForegroundColor Yellow
        Get-DnsClientServerAddress -InterfaceAlias $AdapterName | Select-Object InterfaceAlias, ServerAddresses
    }
    else {
        # This runs if no active adapter with a gateway was found
        Write-Host "Error: Could not find an active network adapter with a default gateway." -ForegroundColor Red
    }
}
catch {
    # This runs if any command fails
    Write-Host "An unexpected error occurred." -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
}

Read-Host -Prompt "Script finished. Press Enter to exit"
