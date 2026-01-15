@echo off
echo Building Notificatosorusator...
dotnet build Notificatosorusator.csproj
if %errorlevel% neq 0 (
    echo Build Failed!
    pause
    exit /b %errorlevel%
)
echo Build Succeeded!
echo You can now run bin\Debug\net7.0-windows10.0.19041.0\win10-x64\Notificatosorusator.exe
pause
