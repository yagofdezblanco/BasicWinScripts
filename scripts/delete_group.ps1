param ($groupname,$parentdir)

if (!(Get-LocalGroup $groupname)
{
    Write-Host "El grupo no existe"
    return
}
$groupusers=Get-LocalGroupMember $groupname
foreach ($user in $groupusers)
{
    
    $userpathdir=$parentdir+"\"+$user.name
    Write-Host "Eliminando directorio $userpathdir"
    Remove-LocalGroupMember -Group $groupname -Member $user
    Remove-LocalUser -Name $user 
    Remove-Item -Path $userpathdir
}