
function Open-FileDialog {
        [cmdletBinding()]
        param(
            [Parameter()]
            [ValidateScript({Test-Path $_})]
            [String]
            $InitialDirectory
        )
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog 
    if($InitialDirectory){
        $FileBrowser.InitialDirectory = $InitialDirectory
    }

    else{
    $fileBrowser.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    }$FileBrowser.Filter = 'CSV (*.csv)|*.csv'

[void]$FileBrowser.ShowDialog()
$FileBrowser.FileName

}

Write-Host "Welcome to Netscaler ADC Secret Keys importer tool. Please , make sure that the OTP4ADC.ps1 script is located in the same folder" -ForegroundColor Green
$gatewayURI= Read-Host -Prompt "Please, provide your gateway URI"
$attribute= Read-Host -Prompt "Please, provide attribute name. Default -userParameters"
 Write-Host "Select .CSV file with the seeds" -ForegroundColor Green
 Start-Sleep -s 1
$FileBrowser = Open-FileDialog .\

$file = Import-Csv $FileBrowser
foreach ($line in $file)
{


Try {
$DeviceName="Token2"+$line.model

$results= @( .\OTP4ADC.ps1 -attribute $attribute -GatewayURI $gatewayURI -username $line.upn -DeviceName $DeviceName  -Secret $line."secret key" -ExportPath Temp)
 }
Catch {

$_ | Out-File .\errors.txt -Append

}

}
Remove-Item -LiteralPath "Temp" -Force -Recurse

$results 


