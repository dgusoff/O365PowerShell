#outputs a gridview showing the last times each local VM was used.
#shamelessly appropriated from http://www.altaro.com/hyper-v/get-vm-last-use-time/
#

Get-VM | Select VMName,CreationTime,
@{Name="CreationAge";Expression={[int]((Get-Date) - $_.CreationTime).TotalDays}},
@{Name="LastUse";Expression={(Get-Item ($_.Harddrives[0].path)).LastWriteTime}},
@{Name="LastUseAge";Expression={[int]((Get-Date) - ((Get-Item ($_.Harddrives[0].path)).LastWriteTime)).TotalDays}},
Notes |Sort LastUse | Out-GridView -Title "VM Aging Report"