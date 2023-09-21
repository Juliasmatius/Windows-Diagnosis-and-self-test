@echo off

REM Copyright Juli/Julimiro juli@julimiro.eu.org
echo This work is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/?ref=chooser-v1) ![CC Icon](https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1) ![BY Icon](https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1) ![SA Icon](https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1)
msg * This work is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/) to Juli/Julimiro juli@julimiro.eu.org



:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

:menu
cls
echo Select an option:
echo 1. Asynchronous tests
echo 2. Synchronous tests
echo 3. Exit

set /p choice=Enter your choice (1/2/3): 

if "%choice%"=="1" goto async
if "%choice%"=="2" goto sync
if "%choice%"=="3" goto end

echo Invalid choice. Please select 1, 2, or 3.
pause
goto menu




:sync
:--------------------------------------
echo Disabling sleep mode...
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

echo Sleep mode disabled successfully.


start msinfo32
start systeminfo

echo Running netsh winsock reset
start netsh winsock reset

echo Running Perfmon
start perfmon /report

echo Running mdsched
echo Aka Memory Diagnostic Tool
start mdsched.exe /c

echo Running msdt
echo Aka Windows Update Troubleshooter
start msdt.exe /id WindowsUpdateDiagnostic


echo Running eventvwr.msc
echo Aka Windows Event Viewer
start eventvwr.msc

echo Running verifier
echo Aka Driver Verifier Manageer
start verifier

echo Running cleanmgr
echo Aka Disk Cleanup
start cleanmgr

echo Running DriverQuery
start driverquery

echo Runnning bcdedit
start bcdedit

echo Running winsat formal
start winsat formal

echo Checking uptime
start systeminfo | find "System Up Time"

echo Running sfc /scannow
echo Aka System File Checker
start sfc /scannow

echo Running DISM.exe /Online /Cleanup-Image /restorehealth
echo Aka Deployment Image Servicing And Management
echo Aka if stuff is corrupted fix it
start DISM.exe /Online /Cleanup-Image /restorehealth

echo Running chkdsk /f /v /r
echo Aka check disk
start chkdsk /f /v /r


echo Downloading msrt.exe
powershell -command "Invoke-WebRequest -URI 'https://download.microsoft.com/download/2/C/5/2C563B99-54D9-4D85-A82B-45D3CD2F53CE/Windows-KB890830-x64-V5.117.exe' -OutFile msrt.exe"

echo Running msrt.exe
start msrt.exe /F:Y
goto end



:async
:--------------------------------------
echo Disabling sleep mode...
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

echo Sleep mode disabled successfully.


msinfo32
systeminfo

echo Running netsh winsock reset
netsh winsock reset

echo Running Perfmon
perfmon /report

echo Running mdsched
echo Aka Memory Diagnostic Tool
mdsched.exe /c

echo Running msdt
echo Aka Windows Update Troubleshooter
msdt.exe /id WindowsUpdateDiagnostic


echo Running eventvwr.msc
echo Aka Windows Event Viewer
eventvwr.msc

echo Running verifier
echo Aka Driver Verifier Manageer
verifier

echo Running cleanmgr
echo Aka Disk Cleanup
cleanmgr

echo Running DriverQuery
driverquery

echo Runnning bcdedit
bcdedit

echo Running winsat formal
winsat formal

echo Checking uptime
systeminfo | find "System Up Time"

echo Running sfc /scannow
echo Aka System File Checker
sfc /scannow

echo Running DISM.exe /Online /Cleanup-Image /restorehealth
echo Aka Deployment Image Servicing And Management
echo Aka if stuff is corrupted fix it
DISM.exe /Online /Cleanup-Image /restorehealth

echo Running chkdsk /f /v /r
echo Aka check disk
chkdsk /f /v /r


echo Downloading msrt.exe
powershell -command "Invoke-WebRequest -URI 'https://download.microsoft.com/download/2/C/5/2C563B99-54D9-4D85-A82B-45D3CD2F53CE/Windows-KB890830-x64-V5.117.exe' -OutFile msrt.exe"

echo Running msrt.exe
msrt.exe /F:Y
goto end

:end

echo Restoring power settings to defaults...
powercfg -change -standby-timeout-ac 30
powercfg -change -standby-timeout-dc 5

echo Power settings restored to defaults.
