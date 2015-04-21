@echo off


xcopy model_export ..\..\model_export /SY
xcopy raw ..\..\raw /SY
xcopy source_data ..\..\source_data /SY
xcopy zone_source ..\..\zone_source /SY

echo -- 

pause