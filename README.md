# .NET core API creator

This project contains a script which will create .NET 5 API project in which it will configure
1. [Swagger](https://swagger.io/)
2. Logging with [nlog](https://nlog-project.org/)
3. Docker build enviorment
4. Docker runtime enviorment

## Setup

1. Clone the project
2. Run .\makeAPI.ps1 testAPI (it will create testAPI project)

If you want API to run on a specific port `.\makeAPI.ps1 testAPI -port 5500`

If you get `makeAPI.ps1 cannot be loaded because running scripts is disabled on this system` error, run the following command:
```
PS C:\> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
