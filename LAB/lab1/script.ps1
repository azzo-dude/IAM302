# --- Step 1: Find your network adapter ---
# This command lists all network adapters on your system.
# Look for the 'Name' of the one you are using (e.g., "Wi-Fi" or "Ethernet").
Get-NetAdapter | Format-Table -AutoSize

# --- Step 2: Set the new DNS server ---
# Replace "YourAdapterName" with the actual name from the list above.
# For example: -InterfaceAlias "Ethernet"
Set-DnsClientServerAddress -InterfaceAlias "YourAdapterName" -ServerAddresses "192.168.109.133"

# --- Step 3: Verify the change ---
# This command shows the detailed configuration, including the DNS servers, for your adapter.
Get-DnsClientServerAddress -InterfaceAlias "YourAdapterName"
