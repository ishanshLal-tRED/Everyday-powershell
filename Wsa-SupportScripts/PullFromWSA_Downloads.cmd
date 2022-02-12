@ECHO off

@SET ADB_LOC=C:\Users\Omen\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\
@SET PORT=127.0.0.1:58526

if "%~1"=="" goto directory_pass_as_arg
@SET "PULL_LOCATION=%V/Downloads"
goto end
directory_pass_as_arg:
@SET "PULL_LOCATION=%1"
end:

if not exist %ADB_LOC% (
	ECHO cannot find ADB_LOC | %ADB_LOC% | please check if it exists
	TIMEOUT 5
	EXIT /B
)

ECHO %%"[TIP:]   If you see error connecting to PORT, then click WSA->Developer_mode(Should be on)->Manage_developer_setting"
ECHO %%          sometimes eventhough developer mode is enabled, port are not connected, so this wakes it up
ECHO %%"[TIP:]   If you see error device offline, then in Manage_developer_setting->USB_debugging(on)"
ECHO ===============

pushd %ADB_LOC%

	adb connect %PORT%
	if not exist %PULL_LOCATION% (
		mkdir %PULL_LOCATION%
	)	
	adb -s %PORT% pull ./storage/emulated/0/Download %PULL_LOCATION%

POPD
TIMEOUT 5

::By Harshal Kudale, Contributed by Ishansh Lal
::https://github.com/HarshalKudale/EasySideload-WSA