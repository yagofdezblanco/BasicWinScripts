param ($username, $password, $groupname)
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
$groupexists=Get-LocalGroup $groupname -ErrorAction SilentlyContinue
if ($groupexists -eq $null)
{
    Write-Host "El grupo no existe"
    New-LocalGroup $groupname
}

#test dir
if (!(Test-Path -Path $workdir))
{
    Write-Host "El directorio no existe. Creando directorio..."
    New-Item -ItemType "directory" $workdir
}

#test user
$userexists=Get-LocalUser $username -ErrorAction SilentlyContinue
if (!($userexists -eq $null))
{
    Write-Host "El usuario ya existe"
    return
}

#create secure password from plain password
$Secure_String_Pwd = ConvertTo-SecureString $password -AsPlainText -Force

#añadir usuario
New-LocalUser $username -Password $Secure_String_Pwd | Out-Null
Add-LocalGroupMember -Group $groupname -Member $username -Verbose:$false | Out-Null

New-Item -ItemType "directory" $username | Out-Null