# MainScript.ps1

# Function to check if the current user is an administrator
function Test-IsAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if the user is an admin and call the appropriate script
if (Test-IsAdmin) {
    Write-Output "User is an administrator. Running Script with Prvileges..."
    .\ScriptWithAdminPriv.ps1
} else {
    Write-Output "User is not an administrator. Running Script without Prvileges..."
    .\ScriptWithNoAdminPriv.ps1
}
