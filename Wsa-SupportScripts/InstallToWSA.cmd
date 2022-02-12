@echo off
set "package=%1"

@set ADB_LOC=C:\Users\Omen\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\
@set PORT=127.0.0.1:58526

if not exist %ADB_LOC% (
	echo cannot find ADB_LOC | %ADB_LOC% | please check if it exists
)

echo %%"[TIP:]   If you see error connecting to PORT, then click WSA->Developer_mode(Should be on)->Manage_developer_setting"
echo %%          sometimes eventhough developer mode is enabled, port are not connected, so this wakes it up
echo %%"[TIP:]   If you see error device offline, then in Manage_developer_setting->USB_debugging(on)"
echo ===============

PUSHD %ADB_LOC%
	adb connect %PORT%
	adb -s %PORT% install %package%
POPD
TIMEOUT 5
EXIT /B

::By Harshal Kudale Modified by Ishansh
::https://github.com/HarshalKudale/EasySideload-WSA