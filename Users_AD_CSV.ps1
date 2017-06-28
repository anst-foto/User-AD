Import-Module ActiveDirectory
Clear-Host

#*******************************************************
Write-Host -ForegroundColor Yellow "*******************************************************"
""
Write-Host -ForegroundColor Yellow "Добавление пользователей в AD (PowerShell)"
Write-Host -ForegroundColor Yellow "(c) AnSt. Март 2017"
Write-Host -ForegroundColor Yellow "Версия: 0.3 (Июнь 2017)"
""
Write-Host -ForegroundColor Yellow "*******************************************************"
""
Write-Host -ForegroundColor Green "Изменения:
v0.3 (Июнь 2017):   Добавление пользователя в соответствующую группу
v0.2 (Июнь 2017):   Проверка: существует пользователь или нет
v0.1 (Март 2017):   Создание скрипта"
""
Write-Host -ForegroundColor Yellow "*******************************************************"
""
#*******************************************************

$Users = Import-Csv -Delimiter ";" -Path "C:\user.csv"
$CN = "OU=Users,OU=Departament,DC=Organization,DC=local"
Foreach ($User in $Users)
{	
    $Password = $User.Password
    $Detailedname = $User.LastName + " " + $User.FirstName + " " + $User.MiddleName
    $UserFirstname = $User.FirstName
    $UserLastName = $User.LastName
    $Department = $User.Department
    $Company = "Company"
    $Title = $User.Title
    $SAM= $User.Login + "@company.local"
    Try {
            New-ADUser -Name $Detailedname -SamAccountName $User.Login -UserPrincipalName $SAM -DisplayName $Detailedname -GivenName $User.FirstName -Surname  $User.LastName -Company $Company -Department $Department -Title $Title  -AccountPassword  (ConvertTo-SecureString -AsPlainText $Password -Force) -PasswordNeverExpires $true -Enabled $true -Path $CN -Verbose
        }
    Catch {
            Set-ADUser -Identity "CN=$Detailedname,OU=Users,OU=Departament,DC=Organization,DC=local" -Company $Company -Department $Department -Title $Title -Verbose
          }
    Finally {    
        if ($Department -eq 'Departament1') {Add-ADGroupMember -Identity "Departament1" -Members $User.Login -Verbose}
        elseif ($Department -eq 'Departament2') {Add-ADGroupMember -Identity "Departament2" -Members $User.Login -Verbose}
        elseif ($Department -eq 'Departament3') {Add-ADGroupMember -Identity "Departament3" -Members $User.Login -Verbose}
    }
}
