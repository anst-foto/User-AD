Import-Module ActiveDirectory
Clear-Host

#*******************************************************
Write-Host -ForegroundColor Yellow "*******************************************************"
""
Write-Host -ForegroundColor Yellow "Добавление пользователей в AD (PowerShell)"
Write-Host -ForegroundColor Yellow "(c) Starinin Andrey (AnSt). 2017"
Write-Host -ForegroundColor Yellow "Версия: 0.5"
Write-Host -ForegroundColor Yellow "MIT License"
""
Write-Host -ForegroundColor Yellow "*******************************************************"
""
Write-Host -ForegroundColor Gray "*******************************************************"
""
Write-Host -ForegroundColor Gray "MIT License

Copyright (c) 2017 Starinin Andrey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the `'Software`'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED `'AS IS`', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."
""
Write-Host -ForegroundColor Gray "*******************************************************"
""

Write-Host -ForegroundColor Green "Изменения:
v0.5 (Октябрь 2017):	Добавление фотографии пользователя
v0.4 (Июль 2017):	Добавление информации в дополнительные поля
v0.3 (Июнь 2017):   Добавление пользователя в соответствующую группу
v0.2 (Июнь 2017):   Проверка: существует пользователь или нет
v0.1 (Март 2017):   Создание скрипта"
""
Write-Host -ForegroundColor Yellow "*******************************************************"
""
#*******************************************************

$Path = "C:\user.csv"                                                                   #Путь к файлу user.csv
$Users = Import-Csv -Delimiter ";" -Path $Path                                          #Импорт csv-файла
$CN = "OU=Users,OU=Departament,DC=Organization,DC=local"                                #Путь в AD
$ADSI = "ADSI"																			#Имя дополнительного поля
$ADSIData = "Data"																		#Значение дополнительного поля
$ADSI2 = "ADSI2"																		#Имя дополнительного поля
$ADSIData2 = "Data2"																	#Значение дополнительного поля
$Photo = [byte[]](Get-Content "C:\Photo\MyPhoto.jpg" -Encoding byte)                    #Путь к фотографии пользователя
Foreach ($User in $Users)
{	
    $Password = $User.Password                                                          #Пароль пользователя
    $DisplayName = $User.LastName + " " + $User.FirstName + " " + $User.MiddleName     	#Полное имя
    $UserFirstName = $User.FirstName                                                    #Имя
    $UserLastName = $User.LastName                                                      #Фамилия
    $Department = $User.Department                                                      #Отдел
    $Company = "Company"                                                                #Компания (Организация)
    $Title = $User.Title                                                                #Должность
    $SAM= $User.Login + "@company.local"                                                #
    Try {
			#Заведение нового пользователя в AD
            New-ADUser -Name $DisplayName -SamAccountName $User.Login -UserPrincipalName $SAM -DisplayName $DisplayName -GivenName $UserFirstName -Surname  $UserLastName -Company $Company -Department $Department -Title $Title  -AccountPassword  (ConvertTo-SecureString -AsPlainText $Password -Force) -PasswordNeverExpires $true -Enabled $true -Path $CN -Verbose
        }
    Catch {
			#Если пользователь уже существует, то исправление его данных
            Set-ADUser -Identity "CN=$DisplayName,OU=Users,OU=Departament,DC=Organization,DC=local" -Company $Company -Department $Department -Title $Title -Verbose
          }
    Finally {
		#Добавление пользователя к Группе пользователей на основе Отдела
        if ($Department -eq 'Departament1') {Add-ADGroupMember -Identity "Departament1" -Members $User.Login -Verbose}
        elseif ($Department -eq 'Departament2') {Add-ADGroupMember -Identity "Departament2" -Members $User.Login -Verbose}
        elseif ($Department -eq 'Departament3') {Add-ADGroupMember -Identity "Departament3" -Members $User.Login -Verbose}
		#Добавление данных и фотографии юзера в дополнительные поля
		Set-ADUser -Identity "CN=$DisplayName,OU=Users,OU=Departament,DC=Organization,DC=local" -Replace @{$ADSI=$ADSIData;$ADSI2=$ADSIData2;thumbnailPhoto=$photo;jpegPhoto=$photo} -Verbose
    }
}
