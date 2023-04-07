# Load command-line parameters
[CmdletBinding()]
param(
    [string]$sql_server, 
    [string]$local_folder, 
    [string]$remote_server, 
    [string]$remote_folder
)
$script_name = $myInvocation.MyCommand.Name
Write-Debug "Start of '$script_name'"

# Reference RMO Assembly
#[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Replication") | Out-Null
#Add-Type -Path "D:\PowerShell\Replication\Microsoft.SqlServer.Replication.dll"
#Add-Type -Path "\\dba_share\windows\scripts\dba\Replication\Microsoft.SqlServer.Replication.dll"
#Add-Type -Path "C:\Windows\assembly\GAC_32\Microsoft.SqlServer.Replication\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Replication.dll"
#Add-Type -path �C:\Windows\assembly\GAC_64\Microsoft.SqlServer.Replication\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Replication.dll�
#Add-Type -Path "C:\Windows\assembly\GAC_64\Microsoft.SqlServer.Replication\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Replication.dll"
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Rmo")
# | Out-Null
#Add-Type -Path "C:\Windows\assembly\GAC_64\Microsoft.SqlServer.Replication\10.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Replication.dll"


# Define functions
function syntax
{
    $message_string = "/******************************************************************************`r`n" + `
                      "*" + "`r`n" + `
                      "* Script: " + $script_name + "`r`n" + `
                      "*" + "`r`n" + `
                      "* Description: PowerShell script that generates SQL statements to" + "`r`n" + `
                      "*              drop/add replication." + "`r`n" + `
                      "*" + "`r`n" + `
                      "* Parameters:  -sql_server    <sql_server_name>`r`n" + `
                      "*             [-local_folder  <save_to_local_folder>]" + "`r`n" + `
                      "*             [-remote_server <copy_to_remote_server>]" + "`r`n" + `
                      "*             [-remote_folder <copy_to_remote_folder>]" + "`r`n" + `
                      "*" + "`r`n" + `
                      "******************************************************************************/"
    error_handler $message_string $log_file
}

function error_handler([string]$errormsg, [string]$logfile)
{
    Write-Output($errormsg) `a
    $errormsg >> $logfile
    EXIT 99
}

function write_file([string]$text, [string]$myfilename, [int]$cr_prefix)
{
    <#
    if ($cr_prefix -eq 1) { "" >> $myfilename }
    if($test){
        $text >> $myfilename
    }
    #>
    $text | Out-File -FilePath $myfilename -Append
}

function initialize_file([string]$myfilename)
{
     #$null | Set-Content $myfilename
     out-file $myfilename -Append 
}


try {
    Write-Debug "`tInside try.."
# Variables
$timestamp = get-date -uformat %Y%m%d%H%M%S
#if ($local_folder -eq "")   {$local_folder = get-location}
if ($local_folder -eq "")   {$local_folder = split-path $myInvocation.MyCommand.Path}
$local_folder = (get-item $local_folder).fullname
if (!$local_folder.EndsWith("\")) {$local_folder = $local_folder + "\"}
$log_file = $local_folder + ($script_name -replace ".ps1","") + "_" + $timestamp + ".log"
if ($sql_server -eq "")   {syntax}
$sql_server = $sql_server.ToUpper()
$remote_server = $remote_server.ToUpper()
$sql_server_name = ($sql_server -replace "\\","-");
$sql_server_name = ($sql_server_name -replace ",","-");
$add_repl_file = "Add_Replication_" + $sql_server_name + "_" + $timestamp + ".sql"
$drop_repl_file = "Drop_Replication_" + $sql_server_name + "_" + $timestamp + ".sql"
$add_repl_file_with_path = $local_folder + $add_repl_file
$drop_repl_file_with_path = $local_folder + $drop_repl_file
$repsvr=New-Object "Microsoft.SqlServer.Replication.ReplicationServer" $sql_server
[int] $Count_Tran_Pub = 0
[int] $Count_Merge_Pub = 0

# Initialize Files
Write-Output "Initialize File: $add_repl_file_with_path";
initialize_file $add_repl_file_with_path
Write-Output "Initialize File: $drop_repl_file_with_path";
initialize_file $drop_repl_file_with_path

foreach($replicateddatabase in $repsvr.ReplicationDatabases)
{
    $Count_Tran_Pub = $Count_Tran_Pub + $replicateddatabase.TransPublications.Count
    $Count_Merge_Pub = $Count_Merge_Pub + $replicateddatabase.MergePublications.Count
}

$message_string = "" + `
"/******************************************************************************`r`n" + `
"* Script: " + $script_name + "`r`n" + `
"* Location: " + $local_folder + "`r`n" + `
"* Command: " + $myInvocation.Line + "`r`n" + `
"* Action: Generate SQL to Add/Drop Replication" + "`r`n" + `
"* Date: " + (get-date -uformat '%m/%d/%Y %I:%M%p') + "`r`n" + `
"* Server: $sql_server" + "`r`n" + `
"* Publisher: " + $repsvr.IsPublisher + "`r`n" + `
"* Transactional Publications: $Count_Tran_Pub" + "`r`n" + `
"* Merge Publications: $Count_Merge_Pub" + "`r`n" + `
"******************************************************************************/" + "`r`n"

write-Output $message_string
write_file $message_string $log_file

$message_string = $message_string -replace "Action: Generate SQL to Add/Drop Replication","Action: Add Replication"
write_file ($message_string) $add_repl_file_with_path 0

$message_string = $message_string -replace "Action: Add Replication","Action: Drop Replication"
write_file ($message_string) $drop_repl_file_with_path 0

# Check if current login has sysadmin
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$sql_server;Database=master;Integrated Security=True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT IS_SRVROLEMEMBER('sysadmin')"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
[void] $SqlAdapter.Fill($DataSet)
$SqlConnection.Close()
$is_sysadmin = $DataSet.Tables[0].Rows[0][0]
if ($is_sysadmin -ne 1) {
    $message_string = "Error: Login must have sysadmin role."
    write_file ($message_string) $add_repl_file_with_path 0
    write_file ($message_string) $drop_repl_file_with_path 0
    error_handler $message_string $log_file
}

#if ((($Count_Tran_Pub + $Count_Merge_Pub + $Count_Snap_Pub) -eq 0) -and ($repsvr.IsPublisher -eq "True"))
#{
#    $message_string = "Error: Unable to find publications."
#    write_file ($message_string) $add_repl_file_with_path 0
#   write_file ($message_string) $drop_repl_file_with_path 0
#    error_handler $message_string $log_file
#}
#else
if (($Count_Tran_Pub + $Count_Merge_Pub + $Count_Snap_Pub) -eq 0) 
{
    $message_string = "Replication not found. Exiting."
    Write-Output $message_string
    write_file $message_string $log_file 0
    write_file $message_string $add_repl_file 0
    write_file $message_string $drop_repl_file 0
    EXIT
}

# Define Script Options
$add_repl_scriptargs = [Microsoft.SqlServer.Replication.scriptoptions]::Creation `
-bor  [Microsoft.SqlServer.Replication.scriptoptions]::IncludeAll `
-bxor [Microsoft.SqlServer.Replication.scriptoptions]::IncludeReplicationJobs

$drop_repl_scriptargs = [Microsoft.SqlServer.Replication.scriptoptions]::Deletion `
-bor  [Microsoft.SqlServer.Replication.scriptoptions]::IncludeAll `
-bxor [Microsoft.SqlServer.Replication.scriptoptions]::IncludeReplicationJobs

# Script Transactional
foreach($replicateddatabase in $repsvr.ReplicationDatabases) 
{
    if ($replicateddatabase.TransPublications.Count -gt 0)
    {
        foreach($tranpub in $replicateddatabase.TransPublications) 
        {
            $message_string = "/******************************************************************************" + "`r`n" + `
                              "* Publication: " + $tranpub.Name + "`r`n" + `
                              "* Type: Transactional" + "`r`n" + `
                              "******************************************************************************/"
            Write-Debug "Inside Scriptout of Transactional Replication"

            Write-Output $message_string
            write_file $message_string $log_file

            write_file ($message_string) $add_repl_file_with_path 0
            write_file ($message_string) $drop_repl_file_with_path 0

            [string]$myscript=$tranpub.script($add_repl_scriptargs)
            write_file $myscript $add_repl_file_with_path 0

            [string]$myscript=$tranpub.script($drop_repl_scriptargs)  
            write_file $myscript $drop_repl_file_with_path 0
        }
    }
}

# Script Merge
foreach($replicateddatabase in $repsvr.ReplicationDatabases) 
{
    if ($replicateddatabase.MergePublications.Count -gt 0)
    {
        foreach($mergepub in $replicateddatabase.MergePublications) 
        {
            $message_string = "/******************************************************************************" + "`r`n" + `
                              "* Publication: " + $mergepub.Name + "`r`n" + `
                              "* Type: Merge" + "`r`n" + `
                              "******************************************************************************/"
            Write-Output $message_string
            write_file $message_string $log_file

            write_file ($message_string) $add_repl_file_with_path 0
            write_file ($message_string) $drop_repl_file_with_path 0

            [string]$myscript=$mergepub.script($add_repl_scriptargs)  
            write_file $myscript $add_repl_file_with_path 0

            [string]$myscript=$mergepub.script($drop_repl_scriptargs)  
            write_file $myscript $drop_repl_file_with_path 0
        }
    }
}

# Copy files to remote server
if (($remote_server -ne "") -or ($remote_folder -ne ""))
{
    if (!$remote_folder.EndsWith("\")) {$remote_folder = $remote_folder + "\"}
    Write-Output "`n`rCopy files to $remote_server."
    $remote_folder = "\\" + $remote_server + "\" + ($remote_folder -replace ":","$")
    if (!(test-path "$remote_folder")) {error_handler "Error: Remote folder not found." $log_file}
    foreach ($file in ($drop_repl_file, $add_repl_file))
    {
        $command = "robocopy /V /Z /R:5 /W:5 $local_folder " + $remote_folder + " $file"
        write_file $command $log_file 1
        invoke-expression -command $command
        if (test-path "$remote_folder$file")
        {
            Write-Output "Copy succeeded."
        }
        else
        {
            error_handler "Copy failed." $log_file
         }
    }
}

# Exit
Write-Output "`r`nCompleted."
write_file "`r`nCompleted." $log_file
}
catch { throw $_ }
