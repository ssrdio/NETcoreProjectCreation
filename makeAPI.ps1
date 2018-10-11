param(
	[Parameter(Mandatory=$true)] [string]$name,
	[switch] $tests
)

Set-Location "..\"

New-Item -ItemType Directory -Path ($name)

Set-Location ($name)

New-Item -ItemType Directory -Path "src"

Set-Location "src"

dotnet new sln -n $name
dotnet new webapi --no-https -o ($name)

dotnet sln ($name + ".sln") add ($name + "/" + $name + ".csproj")

if($tests)
{
    dotnet new xunit -o ($name + ".Tests")
    dotnet sln ($name + ".sln") add ($name + ".Tests/" + $name + ".Tests.csproj")
}

Copy-Item "..\..\NETcoreProjectCreation\nlog.config" -Destination ($name)
Copy-Item "..\..\NETcoreProjectCreation\Startup.cs" -Destination ($name)

Set-Location("..\..\")

Copy-Item "NETcoreProjectCreation\Dockerfile" -Destination ($name)
Copy-Item "NETcoreProjectCreation\Makefile" -Destination ($name)

Set-Location ($name + "\src\" + $name)

dotnet add package NLog
dotnet add package NLog.Web.AspNetCore
dotnet add package Swashbuckle.AspNetCore

(Get-Content "Startup.cs") | ForEach-Object {$_ -replace "{PROJECT_NAME}", $name} | Set-Content "Startup.cs"

$file = Get-Item ($name + ".csproj")
$doc = [xml](Get-Content $file)

$GenerateDocumentationFile = $doc.CreateElement("GenerateDocumentationFile")
$GenerateDocumentationFileValue = $doc.CreateTextNode("true")
$GenerateDocumentationFile.AppendChild($GenerateDocumentationFileValue)
$doc.Project.PropertyGroup.AppendChild($GenerateDocumentationFile)

$NoWarn = $doc.CreateElement("NoWarn")
$NoWarnValue = $doc.CreateTextNode("`$(NoWarn);1591")
$NoWarn.AppendChild($NoWarnValue)
$doc.Project.PropertyGroup.AppendChild($NoWarn)

$CopyToOutputDirectory = $doc.CreateElement("CopyToOutputDirectory")
$CopyToOutputDirectoryValue = $doc.CreateTextNode("Always")
$CopyToOutputDirectory.AppendChild($CopyToOutputDirectoryValue)

$Content = $doc.CreateElement("Content")
$ContentAtribute = $doc.CreateAttribute("Update")
$ContentAtribute.Value = "nlog.config"
$Content.Attributes.Append($ContentAtribute)
$Content.AppendChild($CopyToOutputDirectory)

$ItemGroup = $doc.CreateElement("ItemGroup")
$ItemGroup.AppendChild($Content)

$doc.Project.AppendChild($ItemGroup)

$doc.Save($file.FullName)

Set-Location "../.."

$lounchSettings = Get-Content ("src/" + $name + "/Properties/launchSettings.json") | Out-String | ConvertFrom-Json
$port = $lounchSettings.profiles.$name.applicationUrl.Split(":")[-1]
# $port = $lounchSettings.iisSettings.iisExpress.applicationUrl.Split(":")[-1]

(Get-Content "Dockerfile") | ForEach-Object {$_ -replace "{PROJECT_NAME}", $name} | Set-Content "Dockerfile"
(Get-Content "Makefile") | ForEach-Object {$_ -replace "{PROJECT_NAME}", $name.ToLower()} | Set-Content "Makefile"
(Get-Content "Makefile") | ForEach-Object {$_ -replace "{PORT_NUMBER}", $port} | Set-Content "Makefile"
