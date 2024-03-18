set VERSION=%1

cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2022
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient

mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
cd v8
call git pull && gclient sync

echo =====[ Building V8 ]=====
call python3 tools\dev\v8gen.py x64.release -- v8_monolithic=true v8_use_external_startup_data=false use_custom_libcxx=false is_component_build=false treat_warnings_as_errors=false v8_symbol_level=0 is_clang=false
call ninja -C out.gn\x64.release v8_monolith

md output\v8\Lib\Win64DLL
copy /Y out.gn\x64.release\obj\v8_monolith.lib output\v8\Lib\Win64DLL\
