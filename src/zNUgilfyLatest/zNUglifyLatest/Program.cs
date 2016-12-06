namespace zNUglifyLatest
{
    class Program
    {
        static void Main(string[] args)
        {
            var currentPath = @"F:\_g\SharePointBannerMessage\src\SP2013\TraditionalPowerShell\";


            // minify JavaScript
            var codeSettings = new NUglify.JavaScript.CodeSettings();
            var sourceJavaScriptFilePath = currentPath + "CustomSiteCollectionBanner-zInlineSource.js";
            var unminifiedContents = System.IO.File.ReadAllText(sourceJavaScriptFilePath);
            var result = NUglify.Uglify.Js(unminifiedContents, codeSettings);
            if (result.HasErrors)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                var errors = result.Errors;
                sb.AppendLine();
                foreach (var error in errors)
                {
                    sb.AppendLine(error.ToString());
                }

                throw new System.InvalidOperationException(sb.ToString());
            }
            else
            {
                var newFileNameAndPath = currentPath + "CustomSiteCollectionBanner-zMinifiedInlineSource.min.js";
                System.IO.File.WriteAllText(newFileNameAndPath, result.Code);
            }
        }
    }
}
