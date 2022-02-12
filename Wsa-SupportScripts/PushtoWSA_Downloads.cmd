@ECHO off

@SET ADB_LOC=C:\Users\Omen\AppData\Local\Microsoft\WindowsApps\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\
@SET PORT=127.0.0.1:58526

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

::Calculate number of parameters
	@SET num_of_params=0
	@SET MAX_ALLOWED=26

	for %%I IN (%*) DO set /A "num_of_params+=1"
	ECHO Num of files passed = %num_of_params%, Max allowed = %MAX_ALLOWED%

	if %num_of_params% GTR %MAX_ALLOWED% (
		ECHO Maximum of 26 files are allowed, Please reduce the nuber of selections
		TIMEOUT 5
		EXIT /B
	)

	for %%I IN (%*) DO (
		adb -s %PORT% push %%I ./storage/emulated/0/Download
	)

POPD
TIMEOUT 5

::By Harshal Kudale, Contributed by Ishansh Lal
::https://github.com/HarshalKudale/EasySideload-WSA