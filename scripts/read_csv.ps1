param($pathfile)
$collection=Import-Csv $pathfile
foreach ($item in $collection)
{
    $username=$item.username
    $groupname=$item.groupname
    $firstname=$item.firstname
    $lastname=$item.lastname
    $password=$item.password
    .\crear_usuario.ps1 -username $username -password $password -groupname $groupname
}