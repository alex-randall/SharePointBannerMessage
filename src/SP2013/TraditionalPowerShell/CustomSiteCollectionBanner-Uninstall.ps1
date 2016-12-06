# CustomSiteCollectionBanner-Uninstall.ps1 1.0.0
#
# A SharePoint 2013 PowerShell script that uninstalls the CustomSiteCollectionBanner 
# from a single SharePoint 2013 site collection.
# No config needed other than the required site collection url script parameter.
# If the UserCustomAction is not present, this script still completes 
# successfully and nothing is removed.

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

# loop through the UserCustomActions and see if the banner one is present
foreach ($userCustomAction in $userCustomActions) {
    if ($userCustomAction.Name -eq 'CustomSiteCollectionBanner') {
        # found it!
        # assign it to our variable and stop looping immediately
        $ourUserCustomAction = $userCustomAction;
        break;
    }
}

if ($ourUserCustomAction -ne $null) {
    # delete our UserCustomAction
    $ourUserCustomAction.Delete();
}

Write-Host 'CustomSiteCollectionBanner removed successfully from:' -ForegroundColor: Green;
Write-Host $siteCollectionUrl -ForegroundColor: Green;
Write-Host;