copy /Y tfweaponeditor.sp ..\tfweaponeditor.sp
..\compile ..\tfweaponeditor.sp
del ..\tfweaponeditor.sp
copy /Y ..\compiled\tfweaponeditor.smx ..\..\plugins\tfweaponeditor.smx

copy /Y tfweaponeditor.inc ..\include\tfweaponeditor.inc

copy /Y external_test.sp ..\external_test.sp
..\compile ..\external_test.sp
del ..\external_test.sp
copy /Y ..\compiled\external_test.smx ..\..\plugins\external_test.smx

pause