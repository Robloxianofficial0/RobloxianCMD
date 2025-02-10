@echo off
color 0a
Title Robloxian CMD Setup

cls
echo.
echo Downloading Robloxian CMD files...

rem Download the ZIP file using curl
curl -L -o "zipped.zip" "https://github.com/Robloxianofficial0/RobloxianCMD-SourceCode/raw/main/zipped.zip"

rem Verify if the ZIP file was downloaded successfully
if not exist "zipped.zip" (
    echo Failed to download the ZIP file. Check the URL or your internet connection.
    pause
    exit
)

rem Check if 7-Zip is installed
set "SevenZipPath="
if exist "C:\Program Files\7-Zip\7z.exe" (
    set "SevenZipPath=C:\Program Files\7-Zip\7z.exe"
) else if exist "C:\Program Files (x86)\7-Zip\7z.exe" (
    set "SevenZipPath=C:\Program Files (x86)\7-Zip\7z.exe"
) else (
    echo 7-Zip not found. Downloading and installing 7-Zip...
    curl -L -o "7zip_installer.exe" "https://www.7-zip.org/a/7z2201-x64.exe"

    if not exist "7zip_installer.exe" (
        echo Failed to download 7-Zip installer. Exiting.
        del "zipped.zip"
        pause
        exit
    )

    echo Installing 7-Zip...
    start /wait "" "7zip_installer.exe" /S

    rem Verify installation
    if exist "C:\Program Files\7-Zip\7z.exe" (
        set "SevenZipPath=C:\Program Files\7-Zip\7z.exe"
    ) else if exist "C:\Program Files (x86)\7-Zip\7z.exe" (
        set "SevenZipPath=C:\Program Files (x86)\7-Zip\7z.exe"
    ) else (
        echo 7-Zip installation failed. Exiting.
        del "zipped.zip"
        del "7zip_installer.exe"
        pause
        exit
    )
    del "7zip_installer.exe"
)

rem Extract the ZIP file using 7-Zip
echo Extracting files...
"%SevenZipPath%" x zipped.zip -otemp_extracted -y -aoa

rem Check if the 'zipped' folder exists and move the 'source' folder
if exist "temp_extracted\zipped\source" (
    echo Moving 'source' folder and its contents...
    xcopy "temp_extracted\zipped\source" "source" /E /H /Y
) else (
    echo The 'source' folder was not found in the extracted files. Exiting.
    pause
    del "zipped.zip"
    rmdir /s /q temp_extracted
    exit
)

rem Check if 'robloxianCMD.bat' is present in the root of the ZIP file and move it
if exist "temp_extracted\zipped\robloxianCMD.bat" (
    echo Moving 'robloxianCMD.bat' to the current directory...
    copy "temp_extracted\zipped\robloxianCMD.bat" .
) else (
    echo The 'robloxianCMD.bat' file was not found in the ZIP file. Exiting.
    pause
    del "zipped.zip"
    rmdir /s /q temp_extracted
    exit
)

rem Clean up
del "zipped.zip"
rmdir /s /q temp_extracted

echo.
echo Setup complete.
pause
exit
