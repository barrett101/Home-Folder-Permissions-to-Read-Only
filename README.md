# Home-Folder-Permissions-to-Read-Only
This is a script for making bulk changing to users Home Folder permissions to Read-only.

Sources: https://community.spiceworks.com/t/change-user-home-directories-to-read-only/730334

Below script will go through a CSV file with a list of usernames.  It will then go through all the home folders, if the access on the folder contains the username, and the username equals the username in the folder name it will adjust that users permission to read-only.

If you need to get a list of usernames to populate the CSV file, run the below, and get the username in "SAMAccount" field.  Then create another CSV, name the column heading "Username" and then paste all the usernames below.

Get-ADUser -Filter * -SearchBase "OU=Users,DC=your,DC=domain,DC=com" -Properties * | Export-Csv  "c:\temp\ADUserExport.csv"
