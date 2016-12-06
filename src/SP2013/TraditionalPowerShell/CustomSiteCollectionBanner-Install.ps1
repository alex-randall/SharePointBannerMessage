# CustomSiteCollectionBanner-Install.ps1 1.0.0
#
# A SharePoint 2013 PowerShell script that installs the CustomSiteCollectionBanner 
# into a single SharePoint 2013 site collection.
# Requires: a site collection url script parameter and the various dependency files in the same directory as this script.

Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$siteCollectionUrl
)

# stop this PowerShell script on any error immediately (and output the error)
$ErrorActionPreference = 'Stop';

Write-Host;

# get a SharePoint 2013 server-side object model object that represents the specified site collection
$site = Get-SPSite $siteCollectionUrl;

# get the UserCustomActions for that site collection
$userCustomActions = $site.UserCustomActions;
$ourUserCustomAction = $null;

# loop through the UserCustomActions and see if the banner is present
foreach ($userCustomAction in $userCustomActions) {
    if ($userCustomAction.Name -eq 'CustomSiteCollectionBanner') {
        # found it!
        # assign it to our variable and stop looping immediately
        $ourUserCustomAction = $userCustomAction;
        break;
    }
}

if ($ourUserCustomAction -eq $null) {
    # UserCustomAction doesn't exist yet
    # create a new one 
    $ourUserCustomAction = $userCustomActions.Add();
    $ourUserCustomAction.Name = 'CustomSiteCollectionBanner';
    $ourUserCustomAction.Sequence = 1000;
    $ourUserCustomAction.Location = 'ScriptLink';
}

# get the current physical path
$currentPath = split-path -parent $MyInvocation.MyCommand.Definition;
if (!$currentPath.EndsWith('\\')) 
{
    $currentPath = $currentPath + '\\';
}

# load the open source NUgilfy (https://github.com/xoofx/NUglify) .NET 4 dll into PowerShell memory if not already loaded...
$nuglifyAssemblyPath = $currentPath + 'NUglify.dll';
try 
{
    [System.Reflection.Assembly]::LoadFrom($nuglifyAssemblyPath) | Out-Null;
}
catch 
{
    
}

# now use NUglify (https://github.com/xoofx/NUglify) to minify the JavaScript
$codeSettings = New-Object NUglify.JavaScript.CodeSettings;
$sourceJavaScriptFilePath = $currentPath + 'CustomSiteCollectionBanner-zInlineSource.js';
$unminifiedContents = [System.IO.File]::ReadAllText($sourceJavaScriptFilePath);
$result = [NUglify.Uglify]::Js($unminifiedContents, $codeSettings);
if ($result.HasErrors)
{
    $sb = New-Object System.Text.StringBuilder;
    $errors = $result.Errors;
    $sb.AppendLine();
    foreach ($error in $errors)
    {
        $sb.AppendLine($error.ToString());
    }
    
    throw $sb.ToString();
}
else
{
    $newFileNameAndPath = $currentPath + 'CustomSiteCollectionBanner-zMinifiedInlineSource.min.js';
    [System.IO.File]::WriteAllText($newFileNameAndPath, $result.Code);
}

$userCustomActionMinifiedJsCode = $result.Code;

$ourUserCustomAction.ScriptBlock = $userCustomActionMinifiedJsCode;
$ourUserCustomAction.Update();

Write-Host 'CustomSiteCollectionBanner (re)provisioned successfully to:' -ForegroundColor: Green;
Write-Host $siteCollectionUrl -ForegroundColor: Green;
Write-Host;