set VERSION=%1

cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2019
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient

mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
echo target_os = ['win'] >> .gclient
cd v8
call git checkout refs/tags/%VERSION%
call gclient sync

echo =====[ Building V8 ]=====
call gn gen out.gn\x64.release -args="target_os=""win"" target_cpu=""x64"" v8_use_external_startup_data=false v8_enable_i18n_support=false is_debug=false is_clang=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=false is_component_build=true"

call ninja -C out.gn\x64.release -t clean
call ninja -C out.gn\x64.release v8

md output\v8\Lib\Win64DLL
copy /Y out.gn\x64.release\v8.dll.lib output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8_libplatform.dll.lib output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8.dll output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8_libbase.dll output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8_libplatform.dll output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\zlib.dll output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8.dll.pdb output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8_libbase.dll.pdb output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\v8_libplatform.dll.pdb output\v8\Lib\Win64DLL\
copy /Y out.gn\x64.release\zlib.dll.pdb output\v8\Lib\Win64DLL\