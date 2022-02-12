$kind = $args[0] # 1st argument

#Right click VSCodium in start menu -> Open-file-location[one more time if it points to shortcut] -> VSCodium.exe
#Right click -> Copy as path, paste it below,
#Run the script
if($kind -eq $null){
    Write-Host "[Usage, update vscodium_loc before running]"
    Write-Host "  add    - Adds \`"New - New Generic file\`" to context menu"
    Write-Host "  remove - Removes \`"New - New Generic file\`" from context menu"
    $kind = Read-Host
}

#Functions
function ConfirmChange($param_str){
    Write-Host $param_str
    Write-Host "Choice [y]Yes, [n]No [default: No] >> " -NoNewline
    $KeyPress = [System.Console]::ReadKey()
    Write-Host
    Switch ($KeyPress.key) {
        Y { return $true }
        default {
            Write-Host "Invalid Option selected, using default option" # fallthrough
        }
        N { return $false } 
    }
}

#/f quite_execution, /v key-value, /d key-value:data
if ($kind -eq "add"){
    REG ADD "HKEY_CLASSES_ROOT\.generic" /f /d "genericfile"
    REG ADD "HKEY_CLASSES_ROOT\.generic\ShellNew" /f /v NullFile /t REG_SZ
    REG ADD "HKEY_CLASSES_ROOT\.generic\ShellNew" /f /v IconPath /t REG_SZ /d "${Env:SystemRoot}\\System32\\imageres.dll,2"
    REG ADD "HKEY_CLASSES_ROOT\.generic\ShellNew\config" /f /v NoExtension /t REG_SZ
    REG ADD "HKEY_CLASSES_ROOT\genericfile" /f /d "Generic File"
}elseif ($kind -eq "remove"){
    REG DELETE "HKEY_CLASSES_ROOT\.generic" /f
    REG DELETE "HKEY_CLASSES_ROOT\genericfile" /f
}else{
    Write-Host "Please restart Script with appropriate option as parameter" #powershell has no goto, so for simplicity of script, just restart it
}
pause
