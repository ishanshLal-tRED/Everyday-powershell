$vscodium_loc = "C:\Users\Omen\AppData\Local\Programs\VSCodium\VSCodium.exe"

$kind = $args[0] # 1st argument

#Right click VSCodium in start menu -> Open-file-location[one more time if it points to shortcut] -> VSCodium.exe
#Right click -> Copy as path, paste it below,
#Run the script
if($kind -eq $null){
    Write-Host "[Usage]"
    Write-Host "  add    - Adds VSCodium Options to context menu"
    Write-Host "  remove - Removes VSCodium Options from context menu"
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
    $option = "Add <Edit with VSCodium> for Open-file context"
    $confirmation = ConfirmChange($option)
    if($confirmation){
        REG ADD "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with VSCodium" /f /d "Edit with VSCodium"
        REG ADD "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with VSCodium" /f /v Icon /d "$vscodium_loc,0"
        
        REG ADD "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with VSCodium\cmd" /f /d "$vscodium_loc \`"%1\`""
    }
    $option = "Add <Open Folder as VS Code Project> for Open-folder context"
    $confirmation = ConfirmChange($option)
    if($confirmation){
        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\shell\vscodium" /f /d "Open Folder in VSCodium"
        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\shell\vscodium" /f /v Icon /d "$vscodium_loc,0"

        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\shell\vscodium\cmd" /f /d "$vscodium_loc \`"%1\`""
    }
    $option = "Add <Open Folder as VS Code Project> for Open-Directory context"
    $confirmation = ConfirmChange($option)
    if($confirmation){
        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\vscodium" /f /d "Open Directory in VSCodium" #default
        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\vscodium" /f /v Icon /d "$vscodium_loc,0"
        
        REG ADD "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\vscodium\cmd" /f /d "$vscodium_loc \`"%V\`""
    }
}elseif ($kind -eq "remove"){
    REG DELETE "HKEY_CURRENT_USER\Software\Classes\*\shell\Open with VSCodium" /f
    REG DELETE "HKEY_CURRENT_USER\Software\Classes\Directory\shell\vscodium" /f
    REG DELETE "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\vscodium" /f
}else{
    Write-Host "Please restart Script with appropriate option as parameter" #powershell has no goto, so for simplicity of script, just restart it
}
pause