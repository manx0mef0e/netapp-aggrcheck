#requires -Modules DataONTAP

$cred = Get-Credential 
$netappClusters = 'ppsanclu01','ppsanclu02'
if (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "NetApp PowerShell Toolkit" }){
    #Import-Module DataONTAP
    $AggregateResult = @()
    foreach ($singleNAcluster in $netappclusters){
        Add-NcCredential $singleNAcluster -Credential $cred
        Connect-NcController $singleNAcluster | Out-Null
        $Result = Get-NcAggr | Where-Object Name -NotLike "*root*" 
        foreach ($r in $Result) {

            $AggregateResult += [pscustomobject]@{
                Name = $r.Name
                Used = $r.Used
                NcController = $r.NcController
            }
        }
    }

    Write-Output $AggregateResult
}
    else {
        Write-Output "not installed or do something else like install"
    }