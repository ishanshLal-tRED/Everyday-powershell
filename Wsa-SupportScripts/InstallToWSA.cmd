@echo off
:: I reccommend using minimal adb

@set ADB_LOC=%LOCALAPPDATA%\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\
:: trailing backslash required, I've stored my adb.exe in this location/directory, this is WSA WindowsApp's location
@SET PORT=127.0.0.1:58526
:: generally same across WSA's

ECHO %%"[TIP:]    If you see error connecting to PORT, then click WSA->Developer_mode(Should be on)->Manage_developer_setting"
ECHO %%           sometimes eventhough developer mode is enabled, but ports are not connected, so this wakes it up
ECHO %%"[TIP:]    If you see error device offline, then in Manage_developer_setting->USB_debugging(on)"
ECHO %%"[Usage:]  Right click on apk file, Open With -> Select 'Always open with this', double click it againa and i'll get Installed"
ECHO ===============
if "%~1"=="" (
	ECHO perform Usage instructions
	pause
	EXIT /B
)

@Set "package=%1"

if not exist "%ADB_LOC%adb.exe" (
	ECHO "cannot find ADB in | %ADB_LOC% | please check if it exists"
)

PUSHD %ADB_LOC%
	adb connect %PORT%
	adb -s %PORT% install %package%
POPD
TIMEOUT 5

::By Harshal Kudale, Modified by Ishansh Lal
::https://github.com/HarshalKudale/EasySideload-WSA
::https://github.com/ishanshLal-tRED/Everyday-powershell