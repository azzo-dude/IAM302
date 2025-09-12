<#
.SYNOPSIS
  Interactively sets a static DNS server for a specified network adapter.

.DESCRIPTION
  This script must be run with Administrator privileges.
  It first displays all network adapters to the user.
  It then prompts the user to enter the name of the target adapter.
  Finally, it sets the specified DNS server address and verifies the change.
#>

# Clear the screen for better readability
Clear-Host

# --- Step 1: Display available network adapters ---
Write-Host "Searching for available network adapters..." -ForegroundColor Yellow
Get-NetAdapter | Format-Table -AutoSize

# --- Step 2: Ask the user for the adapter name ---
# The Read-Host cmdlet pauses the script and waits for the user to type something.
$AdapterName = Read-Host -Prompt "Please enter the Name of the adapter you want to configure (e.g., Ethernet0)"

# --- Step 3: Set the new DNS server on the selected adapter ---
try {
    Write-Host "Setting DNS for '$AdapterName' to 192.168.109.133..." -ForegroundColor Cyan
    # Use -ErrorAction Stop to catch errors, like a wrong adapter name
    Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses "192.168.109.133" -ErrorAction Stop

    # --- Step 4: Verify the change and show the result ---
    Write-Host "Verification:" -ForegroundColor Yellow
    $DnsSettings = Get-DnsClientServerAddress -InterfaceAlias $AdapterName
    Write-Host "Successfully set DNS for $($DnsSettings.InterfaceAlias) to $($DnsSettings.ServerAddresses)" -ForegroundColor Green
}
catch {
    # This block runs if the 'try' block fails for any reason
    Write-Host "An error occurred. Please check that you entered the correct adapter name and are running PowerShell as an Administrator." -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
}
