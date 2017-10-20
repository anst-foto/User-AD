[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/anst-foto/Broom/blob/master/LICENSE)
![Language: PowerShell](https://img.shields.io/badge/language-PowerShell-blue.svg)

# User-ActivDirectory

PowerShell-скрипт для добавления пользователей в ActivDirectory из csv-файла

***

*  **Добавление пользователей в AD (PowerShell)**
*  **&copy; Starinin Andrey (AnSt), 2017**
*  **Версия: 0.5**
*  **[MIT License](https://github.com/anst-foto/User-ActiveDirectory/blob/master/LICENSE)**

***

## Изменения:
* v0.5 (Октябрь 2017):	Добавление фотографии пользователя
* v0.4 (Июль 2017):	Добавление информации в дополнительные поля
* v0.3 (Июнь 2017): Добавление пользователя в соответствующую группу
* v0.2 (Июнь 2017): Проверка: существует пользователь или нет
* v0.1 (Март 2017): Создание скрипта

***
## Версии:
* PowerShell-скрипт (разработка в **PowerGUI Script Editor v3.8.0.129**)

***
## Описание:
Для работы с данным PowerShell-скриптом необходимо подготовить csv-файл - *user.csv* с разделителями ";". В данном файле первой строкой должны идти заголовки столбцов.
### Заголовки:
* **Login** - логин
* **Password** - пароль
* **LastName** - фамилия
* **FirstName** - имя
* **MiddleName** - отчество
* **Department** - отдел
* **Title** - должность

Файл *user.csv* должен быть переведён в кодировку **UTF-8**.

Скрипт созаёт пользователя в AD на основании данных, указанных в *user.csv*. Если пользователь уже существует, то ему изменяются значения отдела, должности и компании (организации). После этого происходит добавление пользователя в группу.
