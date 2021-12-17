#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  

#Parameters
$SiteURL = "Enter your site"
$ListName= "Enter your list name"
$CSVFile = "Path to CSV with its extension"
$userId = "Enter your userid/email"  
$pwd = Read-Host -Prompt "Enter Password" -AsSecureString  
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId, $pwd)  

    #Get the data from CSV file
    $CSVData = Import-CSV $CSVFile
 
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Creds
  
    #Get the List
    $List = $Ctx.Web.Lists.GetByTitle($ListName)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
 
    #Loop through each Row in the CSV file and update the matching list item based on "ProjectNumber"
    ForEach($Row in $CSVData)
    {
            [Microsoft.SharePoint.Client.ListItemCreationInformation]$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation;
            [Microsoft.SharePoint.Client.ListItem]$ListItem = $List.AddItem($itemCreateInfo);
 
            #Update List Item
            $ListItem["Title"] = $Row.'ProjectNumber'
            $ListItem["fieldNAme2"] = $Row.'ProjectName'
            $ListItem["filedNAme3"] = $Row.'Details'
            $ListItem.Update()
            $Ctx.ExecuteQuery()

        
    }