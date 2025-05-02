@echo off
setlocal enabledelayedexpansion

:: Define variables
set IMAGE_NAME=ollama-gradio
set CONTAINER_NAME=ollama-gradio-app
set VOLUME_NAME=ollama_models
set GRADIO_PORT=7860
set OLLAMA_PORT=11434
set USE_GPU=1  :: Change to 0 to disable GPU

:: 0. Check if container already exists, if so, start it.
echo [INFO] Checking for existing container...
docker ps -a --filter "name=%CONTAINER_NAME%" | find "%CONTAINER_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Container %CONTAINER_NAME% already exists.
    docker ps --filter "name=%CONTAINER_NAME%" | find "%CONTAINER_NAME%" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [INFO] Container is running.
    ) else (
        echo [INFO] Starting existing container...
        docker start %CONTAINER_NAME% || (
            echo [ERROR] Failed to start container
            exit /b 1
        )
    )
    goto DEPLOYMENT_INFO
)

:: 1. Build Docker image (only if container doesn't exist)
echo [INFO] Building Docker image...
docker build -t %IMAGE_NAME% . || (
    echo [ERROR] Failed to build image
    exit /b 1
)

:: 2. Check if volume exists, create if not
docker volume inspect %VOLUME_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Creating volume: %VOLUME_NAME%
    docker volume create %VOLUME_NAME%
)

:: 3. Run new container
if "%USE_GPU%"=="1" (
    set GPU_FLAG=--gpus all
    echo [INFO] GPU acceleration enabled
) else (
    set GPU_FLAG=
    echo [INFO] Running in CPU mode
)

echo [INFO] Creating and starting new container...
docker run -d ^
    %GPU_FLAG% ^
    -p %GRADIO_PORT%:7860 ^
    -p %OLLAMA_PORT%:11434 ^
    -v %VOLUME_NAME%:/root/.ollama ^
    --name %CONTAINER_NAME% ^
    %IMAGE_NAME% || (
    echo [ERROR] Failed to start container
    exit /b 1
)

:DEPLOYMENT_INFO
:: 4. Display deployment information
echo.
echo [SUCCESS] Deployment completed
echo ========================
echo Gradio Access URL:   http://localhost:%GRADIO_PORT%
echo Ollama API URL:     http://localhost:%OLLAMA_PORT%
echo ========================
echo Management Commands:
echo View logs:    docker logs -f %CONTAINER_NAME%
echo Enter container:    docker exec -it %CONTAINER_NAME% bash
echo Stop container:    docker stop %CONTAINER_NAME%
echo Remove container:    docker rm -f %CONTAINER_NAME%
echo Remove image:    docker rmi %IMAGE_NAME%
echo Inspect volume:  docker volume inspect %VOLUME_NAME%

@REM :: 5. Auto-open browser (optional)
@REM timeout /t 5 >nul
@REM start "" "http://localhost:%GRADIO_PORT%"

endlocal
pause