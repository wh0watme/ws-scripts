Set-Variable SEARCHDIR (Get-Location)

if (Test-Path -Path .\multi_module.ps1 -PathType Leaf) {
   Remove-Item .\multi_module.ps1
}

Get-ChildItem -Include "*.csproj" -Recurse | Where-Object DirectoryName -NotLike *build* | Where-Object DirectoryName -NotLike *test* | Where-Object DirectoryName -NotLike *host* | Where-Object DirectoryName -NotLike *migration*  | ForEach-Object {
     Set-Variable CSPROJDIR (Resolve-Path $_ | Split-Path -parent)
     Write-Output "CSPROJDIR= $CSPROJDIR"
     Set-Variable CSPROJ $_.BaseName
     Get-ChildItem -Recurse -Include *.dll | Where-Object FullName -like $CSPROJDIR*\$CSPROJ.dll | Where-Object DirectoryName -NotLike *\obj\* | ForEach-Object {
        #Set-Variable DLL $_.FullName
        Set-Variable DLL (Resolve-Path -Relative $_)
        Write-Output "DLL= $DLL"
        Set-Variable RELCSPROJDIR (Resolve-Path -Relative $CSPROJDIR)
        Write-Output "RELCSPROJDIR= $RELCSPROJDIR"
        Write-Output "java -XX:+UseG1GC -Xmx8g -jar $JARFILE -appPath $DLL -d $RELCSPROJDIR -project $CSPROJ" >>multi_module.ps1
     }
   }
