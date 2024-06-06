@echo off
echo Scanning removable devices with Microsoft Defender...

setlocal enabledelayedexpansion

:: Get current date and time to create a unique filename
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

:: Set the path for saving the scan results
set "result_file=%USERPROFILE%\Documents\scan_result_%datetime%.txt"

:: List of possible removable drive letters
set drives=D E F G H I J K L M N O P Q

:: Flag to check if any USB device is found
set "usb_found="

:: Loop through each drive and check if it exists
for %%d in (%drives%) do (
    if exist %%d:\ (
        echo Scanning drive %%d:\
        "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -File %%d:\ > "scan_result_temp.txt"
        if %errorlevel% equ 0 (
            echo Scan completed for drive %%d:\
            type "scan_result_temp.txt" >> "%result_file%"
            type "scan_result_temp.txt"
            set "usb_found=1"
        ) else (
            echo Failed to scan drive %%d:\
        )
    )
)

:: Delete the temporary scan result file if no USB devices were found
if not defined usb_found (
    echo No USB devices found.
    goto :end
)

:: Delete the temporary scan result file
del "scan_result_temp.txt" /q

:end
echo Scan process completed. Results saved to:
echo %result_file%
pause
