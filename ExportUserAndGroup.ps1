[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") 
#Using Get-SPSite in SharePoint 2010, 2016 and 2019

 
 $filename = "d:\AllWebSitesUsersandGroups.txt"
 $URL="http://<<hostname>>/"
 $site = Get-SPSite $URL 
 
 # #Provide title to header  to "Tab Separated Text File" 
  "Site Name`t URL `t Group Name `t Login Name `t Display Name `t E-Mail" | out-file $filename

 #Iterate through all Webs 
 foreach ($web in $site.AllWebs) 
 { 
 
      #Write the Header to "Tab Separated Text File" 
      "$($web.title) `t $($web.URL) `t `t `t `t " | out-file  $filename  -append 
 
      #Get all Groups and Iterate through 
      foreach ($group in $Web.groups)
        { 
           "`t `t $($Group.Name) `t `t `t " | out-file $filename  -append 
           #Iterate through Each User in the group 
           foreach ($user in $group.users) 
            { 
              #Exclude Built-in User Accounts  please remove comment from below
              if(($User.LoginName.ToLower() -ne "nt authority\authenticated users") -and ($User.LoginName.ToLower() -ne "sharepoint\system") -and ($User.LoginName.ToLower() -ne "nt authority\local service")) 
              { 
               "`t `t `t $($user.LoginName) `t $($user.name) `t $($user.Email)" | out-file $filename -append 
               } 
            }
       } 
 } 
 write-host "Report Generated at " $filename 
 #Note : once export the user using text file and import the text file using tab separator

#Global function site retrival
function global:Get-SPSite($url) { return new-Object Microsoft.SharePoint.SPSite($url) } 

#Global function web retrival
function global:Get-SPWeb($url) {
 $site= New-Object Microsoft.SharePoint.SPSite($url) 
 f($site -ne $null) 
 { $web=$site.OpenWeb(); 
 } 
 return $web 
 }
