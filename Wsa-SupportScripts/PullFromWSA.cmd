@ECHO off
:: I reccommend using minimal adb

@SET ADB_LOC=%LOCALAPPDATA%\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\
:: trailing backslash required, I've stored my adb.exe in this location/directory, this is WSA WindowsApp's location
@SET PORT=127.0.0.1:58526
:: generally same across WSA's

ECHO %%"[TIP:]    If you see error connecting to PORT, then click WSA->Developer_mode(Should be on)->Manage_developer_setting"
ECHO %%           sometimes eventhough developer mode is enabled, but ports are not connected, so this wakes it up
ECHO %%"[TIP:]    If you see error device offline, then in Manage_developer_setting->USB_debugging(on)"
ECHO %%"[#Usage:] Add this file path to Current User Path Environment Variable, (or you can go fancy as you like)"
ECHO %%"[#Usage:] PullFromWSA.cmd <WSA/Folder/Location/Relative/To/storage/emulated/0; default: Download> <custom/pull/location, default: Directory/Structure/As/In/WSA>"
ECHO %%"[#Usage:] Ex. : In (Explorer.AddressBar / cmd)  PullFromWSA.cmd ./Download ./WSA-Download"
ECHO ===============

if "%~1"=="" (
	@SET "PULL_FROM_LOCATION=./storage/emulated/0/Download"
	@SET "PULL_TO_LOCATION=%cd%/Download"
) else (
	@SET "PULL_FROM_LOCATION=./storage/emulated/0/%1"
	if "%~2"=="" (
		@SET "PULL_TO_LOCATION=%cd%/%1/.."
	) else (
		@SET "PULL_TO_LOCATION=%2/.."
	)
)
if not exist "%ADB_LOC%adb.exe" (
	ECHO "cannot find ADB in | %ADB_LOC% | please check if it exists"
	TIMEOUT 5
	EXIT /B
)

PUSHD %ADB_LOC%

	adb connect %PORT%
	if not exist "%PULL_TO_LOCATION%" (
		mkdir "%PULL_TO_LOCATION%"
	)
	
	:: fix error of duplicate dirs
	PUSHD "%PULL_TO_LOCATION%"
	@SET "PULL_TO_LOCATION=%CD%"
	rm -r *
	POPD

	adb -s %PORT% pull "%PULL_FROM_LOCATION%" "%PULL_TO_LOCATION%"

POPD
TIMEOUT 5

::By Harshal Kudale, Modified by Ishansh Lal
::https://github.com/HarshalKudale/EasySideload-WSA
::https://github.com/ishanshLal-tRED/Everyday-powershell