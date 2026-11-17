@echo off
rem Compila WirelessBattery.exe com MSVC + Windows SDK (sem depender do vcvarsall).
setlocal enabledelayedexpansion
cd /d "%~dp0"
set VC=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133
set SDK=C:\Program Files (x86)\Windows Kits\10
set SDKV=10.0.26100.0
set PATH=%VC%\bin\Hostx64\x64;%SDK%\bin\%SDKV%\x64;%PATH%
set INCLUDE=%VC%\include;%SDK%\Include\%SDKV%\ucrt;%SDK%\Include\%SDKV%\um;%SDK%\Include\%SDKV%\shared;%SDK%\Include\%SDKV%\winrt;%SDK%\Include\%SDKV%\cppwinrt
set LIB=%VC%\lib\x64;%SDK%\Lib\%SDKV%\ucrt\x64;%SDK%\Lib\%SDKV%\um\x64
if not exist build mkdir build
rc /nologo /i res /fo build\app.res res\app.rc || exit /b 1
set SOURCES=
for %%f in (src\*.cpp src\drivers\*.cpp) do set SOURCES=!SOURCES! %%f
cl /nologo /std:c++17 /O1 /EHsc /MT /utf-8 /W0 /DUNICODE /D_UNICODE /D_WIN32_WINNT=0x0A00 /DWINVER=0x0A00 /DNOMINMAX /Fobuild\ ^
   !SOURCES! build\app.res /Fe:WirelessBattery.exe ^
   /link /SUBSYSTEM:WINDOWS /ENTRY:wWinMainCRTStartup hid.lib setupapi.lib cfgmgr32.lib ole32.lib oleaut32.lib comctl32.lib gdi32.lib user32.lib shell32.lib advapi32.lib runtimeobject.lib ws2_32.lib bthprops.lib || exit /b 1
echo Built WirelessBattery.exe
