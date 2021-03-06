@Call SetPath
@echo.
@echo Upgrade Digispark Bootloader with spi programming by avrdude
set FILENAME=t85_default.hex
@if exist %FILENAME% (
  avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:%FILENAME%:a
  goto end
)
@rem Try another path
avrdude -pt85 -cstk500v1 -PCOM6 -b19200 -u -Uflash:w:..\firmware\releases\%FILENAME%:a
:end
pause
