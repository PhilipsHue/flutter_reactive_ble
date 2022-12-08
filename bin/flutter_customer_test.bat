PUSHD packages\flutter_reactive_ble
CALL flutter analyze --no-fatal-infos || GOTO :END
CALL flutter test || GOTO :END
POPD

PUSHD packages\reactive_ble_mobile
CALL flutter analyze --no-fatal-infos || GOTO :END
CALL flutter test || GOTO :END
POPD

PUSHD packages\reactive_ble_platform_interface
CALL flutter analyze --no-fatal-infos || GOTO :END
CALL flutter test || GOTO :END
POPD

@ECHO.
@ECHO.
@ECHO Testing complete.
GOTO :EOF

:END
@ECHO.
@ECHO.
@ECHO Testing failed.
EXIT /B 1
