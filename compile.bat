copy /Y tfweaponeditor.sp ..\tfweaponeditor.sp
..\compile ..\tfweaponeditor.sp
del ..\tfweaponeditor.sp
copy /Y ..\compiled\tfweaponeditor.smx ..\..\plugins\tfweaponeditor.smx
pause