@echo off
setlocal enabledelayedexpansion

:: Check environment
where docker >nul 2>&1 || (
    echo [ERROR] Docker not found in PATH. Please install Docker and add it to your PATH.
    exit /b 1
)

docker info >nul 2>&1 || (
    echo [ERROR] Docker daemon is not running.
    exit /b 1
)

:: Load .env variables
for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    set "line=%%A"
    if not "!line!"=="" (
        set "firstChar=!line:~0,1!"
        if not "!firstChar!"=="#" (
            set "%%A=%%B"
        )
    )
)

:: Check GPU support
echo [INFO] Checking for GPU support...
if "!DOCKER_RUNTIME!"=="nvidia" (
    docker info --format "{{.Runtimes}}" | find "nvidia" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [INFO] GPU acceleration ^(NVIDIA detected^).
    ) else (
        set DOCKER_RUNTIME=runc
        echo [WARNING] GPU requested but no NVIDIA runtime available - falling back to CPU.
    ) 
) else (
    set DOCKER_RUNTIME=runc
    echo [INFO] Running in CPU mode.
)

:: Docker compose
docker-compose up -d || (
    echo [ERROR] docker-compose failed.
    exit /b 1
)

:: Display deployment information
echo.
echo [SUCCESS] Deployment completed
echo ========================
echo Deepthink Access URL:   http://localhost:%GRADIO_PORT%
echo How to restart:         supervisorctl restart deepthink
echo ========================
echo Management Commands:
echo View logs:          docker logs -f %CONTAINER_NAME%
echo Enter container:    docker exec -it %CONTAINER_NAME% bash
echo Stop container:     docker stop %CONTAINER_NAME%
echo Remove container:   docker rm -f %CONTAINER_NAME%
echo Remove image:       docker rmi %IMAGE_NAME%
echo Inspect volume:     docker volume inspect %VOLUME_NAME%

@REM :: Auto-open browser (optional)
@REM timeout /t 5 >nul
@REM start "" "http://localhost:%GRADIO_PORT%"

endlocal
pause