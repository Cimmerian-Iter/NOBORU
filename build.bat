del lpp-builder\buildtmp\* 2>nul
xcopy /y lpp-builder\build\* lpp-builder\buildtmp\
xcopy /y source\* lpp-builder\buildtmp\
cd lpp-builder
vita-mksfoex -s TITLE_ID=KOOB00001 "vsKoob" param.sfo
copy /Y param.sfo /B buildtmp\sce_sys\param.sfo
7z a -tzip "..\vsKoob.vpk" -r .\buildtmp\* .\buildtmp\eboot.bin 
rd /s /q buildtmp