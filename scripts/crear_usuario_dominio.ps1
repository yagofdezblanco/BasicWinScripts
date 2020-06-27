param ($username, $password, $groupname, $groupscope)
$workdir="c:\workdir"

#test password
if ($password.length -lt 8)
{
    Write-Host "La contraseña debe tener un minimo de 8 caracteres"
    return
}

if (!($password -match "[0-9]"))
{
    Write-Host "La contraseña debe tener minimo 1 digito"
    return
}

if (!($password -cmatch "[A-Z]"))
{
    Write-Host "La contraseña debe tener minimo 1 mayuscula"
    return
}

if (!($password -cmatch "[a-z]"))
{
    Write-Host "La contraseña debe tener minimo 1 minuscula"
    return
}

if (!($password -cmatch "[_!@#%^&$\.-]"))
{
    Write-Host "La contraseña debe tener minimo 1 caracter especial"
    return
}

if (!($password -cmatch "^[0-9a-zA-Z_!@#%^&$\.-]"))
{
    Write-Host "La contraseña no puede contener caracteres no validos"
    return
}

#test group
Try {
$groupexists=Get-ADGroup $groupname 
}
Catch{}
if ($groupexists -eq $null)
{
    Write-Host "El grupo no existe. Creando grupo..."
    New-ADGroup -Name $groupname -GroupScope $groupscope
}

#test dir
if (!(Test-Path -Path $workdir))
{
    Write-Host "El directorio no existe. Creando directorio..."
    New-Item -ItemType "directory" $workdir
}

#test user
Try {
$userexists=Get-ADUser $username
}
Catch {}
if (!($userexists -eq $null))
{
    Write-Host "El usuario ya existe"
    return
}

#create secure password from plain password
$Secure_String_Pwd = ConvertTo-SecureString $password -AsPlainText -Force

#añadir usuario
New-ADUser $username -AccountPassword $Secure_String_Pwd | Out-Null
Add-ADGroupMember -Identity $groupname -Members $username -Verbose:$false | Out-Null

New-Item -ItemType "directory" $username | Out-Null