Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"
$ProgressPreference="SilentlyContinue"

cd "$(Split-Path $script:MyInvocation.MyCommand.Path -Parent)"

Write-Host "Installing latest dotnet"
.\Dotnet-Install.ps1 -SharedRuntime -InstallDir .dotnet -Channel master -Architecture x64
.\Dotnet-Install.ps1 -InstallDir .dotnet -Channel master -Architecture x64

Write-Host "Creating package store"
.\AspNet-GenerateStore.ps1 -InstallDir .store -Architecture x64 -Runtime win7-x64

Write-Host "Restoring MusicStore"
cd src\MusicStore
dotnet restore

Write-Host "Publishing MusicStore"
dotnet publish -c Release -f netcoreapp2.0 --manifest $env:JITBENCH_ASPNET_MANIFEST

Write-Host "Running MusicStore"
cd bin\Release\netcoreapp2.0\publish
dotnet .\MusicStore.dll