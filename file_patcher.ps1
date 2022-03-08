#Requires -Version 6.0

if($args.count -eq 0){
    Write-Host "#Usage" -BackgroundColor Blue -NoNewline && Write-Host ":"
    Write-Host "Create a JSON file with format"
    Write-Host "["
    Write-Host "`t{"
    Write-Host "`t`t`"file`" : `"relative/path/to/file/from/json`""
    Write-Host "`t`t`"line`" : <int: line number>"
    Write-Host "`t`t`"replace`" : `"string to replace`""
    Write-Host "`t`t`"replacement`" : `"replacement string`""
    Write-Host "`t}, ..."
    Write-Host "]"
    Write-Host "===XOR==="
    Write-Host "["
    Write-Host "`t{"
    Write-Host "`t`t`"file`" : `"relative/path/to/file/from/json`""
    Write-Host "`t`t`"patches`":["
    Write-Host "`t`t`t{`"line`" : <int: line number>, `"replace`" : `"string to replace`", `"replacement`" : `"replacement string`"},"
    Write-Host "`t`t`t..."
    Write-Host "`t`t   ]"
    Write-Host "`t}, ..."
    Write-Host "]"
    Write-Host "Note: XOR means either this or that, for the sake of simplification" -ForegroundColor Green
}

function PatchFunction { param([String]$file, [Object[]]$patch_info) # don't know why but func(var1, var2) {} is not working as expected
    
    if(-not(Test-Path -path $file)) {
        $file = (Join-Path -Path $pwd -ChildPath $file)
        Write-Host "$file : file not found" -ForegroundColor Red
        return $false
    }
    
    Write-Host "#########################" 
    Write-Host "Applying Patch to :"
    Write-Host "file: $file"
    $content = Get-Content "$file"
    $patch_info | ForEach-Object {
        $line = $_.line
        $rplc = $_.replace
        $rplm = $_.replacement
        "------------"
        Write-Host "At line: $line"
        Write-Host "by replacing `'$rplc`' with `'$rplm`'"
        Write-Host "Status:" -BackgroundColor Blue -NoNewline

        $line-- # in powershell, lines start from 0
        $found_posn = $content[$line].IndexOf("$rplc")
        if ($found_posn -ge 0) {
            Write-Host "Patching" -ForegroundColor Blue
            $content[$line] = $content[$line] -Replace "$rplc", "$rplm"
            try {
                Set-Content "$file" $content
                return $true
            } catch {
                Write-Host "Unable to save patch to file $file"
                return $false
            }
        } else {
            $found_posn = $content[$line].IndexOf("$rplm")
            if($found_posn -ge 0){
                Write-Host "Already Patched" -ForegroundColor Green
                return $true
            }else{
                Write-Host "Cannot be patched, recheck your JSON file" -ForegroundColor Red
                return $false
            }
        }
    }
}
$args | ForEach {
    Push-Location (Split-Path -Path "$_")
    $patch_discriptor = (Split-Path -Path "$_" -Leaf)
    [int]$num_of_errors = 0
    Get-Content "$patch_discriptor" | ConvertFrom-Json | ForEach-Object {
        try {
            [String]$file = $_.file
            [Object[]]$ptch = $_.patches
            if($ptch -eq $null) {
                $ptch = @(@{
                    line = $_.line
                    replace = $_.replace
                    replacement = $_.replacement
                })
            }
            if (-not (PatchFunction -file $file.ToString() -patch_info $ptch)){
                $num_of_errors++
            }
        } catch { 
            $num_of_errors++
            Write-Host "(Error): $_" -BackgroundColor Red -NoNewline && Write-Host "."
            Write-Host "`tCanbe due to invalid JSON Object format, run without parameters for #usage"
        }
    }
    if ($num_of_errors -gt 0){
        Write-Host "=========================" -ForegroundColor Magenta
        $full_path = (Join-Path -Path $pwd -ChildPath $patch_discriptor)
        Write-Host "No. of errors occurred: $num_of_errors, in patch file `'$full_path`'" -ForegroundColor Red
    }
    Pop-Location
}