# .NET core API creator

This project contains a script which will create .NET core 2.1 API project in which it will configure
1. [Swagger](https://swagger.io/)
2. Logging with [nlog](https://nlog-project.org/)
3. Docker build enviorment
4. Docker runtime enviorment

## Setup

1. Clone the project
2. If not your PS is not jet configured run:
```
PS C:\> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
3. Run .\makeAPI.ps1 testAPI (it will create testAPI project)
