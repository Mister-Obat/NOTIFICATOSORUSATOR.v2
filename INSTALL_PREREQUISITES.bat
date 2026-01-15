@echo off
echo Installing Windows Workload for .NET...
echo This requires Administrator privileges.
dotnet workload install windows
echo.
echo If the above succeeded, try running BUILD_APP.bat
pause
