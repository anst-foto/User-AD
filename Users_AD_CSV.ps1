Import-Module ActiveDirectory
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
