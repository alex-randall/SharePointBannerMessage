// CustomSiteCollectionBanner-zInlineSource.js
//
// Inline JavaScript source code for the SharePoint 2013 or higher User Custom Action
// that is embedded in the HEAD tag of every SharePoint page of a site collection.
// This source code gets automatically minified into CustomSiteCollectionBanner-zMinifiedInlineSource.min.js
// when the CustomSiteCollectionBanner-Install.ps1 PowerShell script is run. 
function z2c8e78b231ef4ad5b0e1a5c38791aa9a() {

    var boldTextAtFrontOfStatusMessage = "NOTICE!";
    var htmlStatusMessage = "This Site will be migrated and/or archived in \"X\" number of weeks/days.  Please contact &lt;Admin&gt;..."; 

    // internal private function that waits until the SP.SOD SharePoint 2013 or higher JavaScript namespace is present on the page
    function waitUnitSPSODIsPresent(callback) {
        var isPresent = false;
        try {
            if (SP.SOD) {
                isPresent = true;
            }
        } catch (e) {

        }

        if (isPresent) {
            callback();
        } else {
            setTimeout(function () {
                waitUnitSPSODIsPresent(callback);
            }, 100);
        }
    }

    // call the internal private function to wait until SP.SOD namespace is loaded on the SharePoint 2013 or higher page
    waitUnitSPSODIsPresent(function () {

        // now we have SP.SOD
        // next call it's executeOrDelayUntilScriptLoaded() function to ensure that the 
        // SharePoint 2013 and higher Client Side Object Model (CSOM) is available (sp.js) on the 
        // SharePoint 2013 or higher page
        SP.SOD.executeOrDelayUntilScriptLoaded(function() {

            // SharePoint 2013 and higher Client Side Object Model (CSOM) is available!
            // now create status message using the SP.UI.Status api 
            var statusId = SP.UI.Status.addStatus(
                 boldTextAtFrontOfStatusMessage,
                 htmlStatusMessage
            );

            // change the status message to yellow
            SP.UI.Status.setStatusPriColor(statusId, "yellow");

        }, "sp.js");

    });

}

// code derived from https://msdn.microsoft.com/pnp_articles/customize-your-sharepoint-site-ui-by-using-javascript
// to ensure it is SharePoint 2013 and higher Minimal Download Strategy friendly
// Is MDS enabled?
if ("undefined" !== typeof g_MinimalDownload && g_MinimalDownload && (window.location.pathname.toLowerCase()).indexOf("/_layouts/15/start.aspx") !== -1 && "undefined" != typeof asyncDeltaManager) {
    // Register script for MDS if possible
    RegisterModuleInit("z2c8e78b231ef4ad5b0e1a5c38791aa9a.js", z2c8e78b231ef4ad5b0e1a5c38791aa9a); //MDS registration
    z2c8e78b231ef4ad5b0e1a5c38791aa9a(); //non MDS run
} else {
    z2c8e78b231ef4ad5b0e1a5c38791aa9a();
}