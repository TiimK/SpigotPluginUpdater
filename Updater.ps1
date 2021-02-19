$baseURL = "https://api.spiget.org/v2/"
$rid = "2175"
$downloadfolder = ""
$savelocation = ""
$pllist = ""

function GetPluginName{
    $api = "resources/$rid"
    $apiname = "resources/$rid/versions/latest"
    $uri = $baseURL + $api
    $uriname = $baseURL + $apiname
    $IDGET = Invoke-RestMethod -Uri $uri -Method GET
    $NAMEGET = Invoke-RestMethod -Uri $uriname -Method GET
    $script:ResourceID = $NAMEGET.name
    $ResourceName = $IDGET.name -replace '(-|#|\||"|,|/|:|â|€|™|\?)', ''
    $script:LatestDownload = $IDGet.file.url
    ShowData
    
}
function ShowData{
    Write-Host "Plugin Name $ResourceName and Latest Version $ResourceID and URL https://spigotmc.org/$LatestDownload"
    $script:filename = "$savelocation\$ResourceName-Version-$ResourceID.jar"
    Write-Host "$filename"
    CheckVersion
}
function CheckVersion{
    If(Test-Path -literalpath "$filename"){
    Write-Host "$filename Up to Date :)"
    CheckList
    }
    Else {
    Download
    }
}
function Download{
    Start-Process "https://spigotmc.org/$LatestDownload"
    $confirmdownload = Read-Host "Enter YES when the download completes"
    while("yes" -notcontains $confirmdownload)
    {
        $confirmdownload = Read-Host "You did not enter a valid answer(Yes). Enter YES when the download completes"
    }
    switch($confirmdownload)
    {
        yes{Renameing};
    }
}
function Renameing{
    (Get-ChildItem -Path "$downloadfolder\*.jar" -Filter * | 
    Where-Object {((Get-Date) - $_.LastWriteTime).TotalMinutes -le 5}).FullName |
    Move-Item -Destination $filename
    CheckList
}
function CheckList{
Get-Content "$pllist" | Select-String "$rid" -Context 0,1 | ForEach-Object {
    $rid = $_.Context.PostContext

    if($rid -eq "55555"){
    Write-Host "Should be done"
    }
    else {
    Write-Host "$rid"
    GetPluginName
    }
   
}
}
GetPluginName