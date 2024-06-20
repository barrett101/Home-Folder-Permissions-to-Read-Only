#START - USER DEFINED VARIABLES
#Populate Variables Below
$logPath = "C:\temp\HomeFolder.log"
#Enter the root folder of the where all the user folders are, example if \\your.domain.com\users\jsmith then enter your root path is \\your.domain.com\users\ .  Make sure to add the trailing \ .
$HomeFolderRoot = "\\your.domain.com\users\"
$UserListCSV = "C:\temp\userlist.csv"
#END - USER DEFINED VARIABLES

#This imports the users defined in the CSV into a variable.  Make sure the column heading the CSV is called Username.
$userList = Import-Csv -Path $UserListCSV
#This get a list of the folders located in the root of the HomeFolder.
$HomeFolders = Get-ChildItem $HomeFolderRoot -Directory
#Goes through each of the users in the CSV
foreach ($user in $userList)
{
    #Get the username from the $user variable
    $username = $user.Username
    #Then is goes through all of the home folders.
    foreach ($HomeFolder in $HomeFolders) 
    {
        #It retrieves the home folder path
        $Path = $HomeFolder.FullName
        #It then retrieves the permissions on the folder
        $Acl = (Get-Item $Path).GetAccessControl('Access')
        #It then retrieves the username from the home folder path.
        $UsernameOnlyFromPath = $Path.Replace("$HomeFolderRoot","")
        #If the username is a match in the access/permissions on the folder, and the username from the CSV equals the username presented in the home folder path.
        #The reason for the additional check is a -eq is more precise than -match.
        IF(($acl.Access.IdentityReference -match "$username") -and ($usernameOnlyFromPath -eq $Username))
        {
            #Writes to the log file
            "Applied read-only access to $username on $path." | out-file -FilePath "$logpath" -Append
            #Changes the security on the folder for the username to Read-only.
            $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'readandexecute','ContainerInherit,ObjectInherit', 'None', 'Allow')
            $Acl.SetAccessRule($Ar)
            Set-Acl -path $Path -AclObject $Acl
            $ar = $null
        }
        $path = $null
        $acl =$null
        $UsernameOnlyFromPath = $null
    }
}
