@echo off
setlocal enabledelayedexpansion

:: Define variables
set IMAGE_NAME=ollama-gradio
set CONTAINER_NAME=ollama-gradio-app
set VOLUME_NAME=ollama_models
set GRADIO_PORT=7860
set OLLAMA_PORT=11434
set USE_GPU=1  :: 0 to disable GPU

:: 0. Check environment
where docker >nul 2>&1 || (
    echo [ERROR] Docker not found in PATH. Please install Docker and add it to your PATH.
    exit /b 1
)

docker info >nul 2>&1 || (
    echo [ERROR] Docker daemon is not running.
    exit /b 1
)

:: 1. Check if image exists, build if not
echo [INFO] Checking for Docker image %IMAGE_NAME%...
docker images --format "{{.Repository}}" | find "%IMAGE_NAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Image not found. Building image %IMAGE_NAME%...
    docker build -t %IMAGE_NAME% . || (
        echo [ERROR] Failed to build image.
        exit /b 1
    )
) else (
    echo [INFO] Image %IMAGE_NAME% already exists.
    choice /m "Do you want to rebuild the image and container" /c YN
    if !errorlevel! equ 1 (
        echo [INFO] Rebuilding image...
        docker build -t %IMAGE_NAME% . || (
            echo [ERROR] Failed to build image.
            exit /b 1
        )
        echo [INFO] Checking for existing container %CONTAINER_NAME%...
        docker inspect %CONTAINER_NAME% >nul 2>&1 && (
            echo [INFO] Removing existing container...
            docker rm -f %CONTAINER_NAME% >nul 2>&1 || (
                echo [ERROR] Failed to remove container.
                exit /b 1
            )
        ) || (
            echo [INFO] No existing container found.
        )
    )
)

:: 2. Check if volume exists, create if not
echo [INFO] Checking for Docker volume %VOLUME_NAME%...
docker volume inspect %VOLUME_NAME% >nul 2>&1 || (
    echo [INFO] Volume not found. Creating volume %VOLUME_NAME%...
    docker volume create %VOLUME_NAME% || (
        echo [ERROR] Failed to create volume.
        exit /b 1
    )
)

:: 3. Check if container exists, create if not, start if stopped
echo [INFO] Checking for Docker container %CONTAINER_NAME%...
docker ps -a --filter "name=%CONTAINER_NAME%" | find "%CONTAINER_NAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Container not found. Creating and starting new container %CONTAINER_NAME%...
    echo [INFO] Checking for GPU support...
    set GPU_FLAG=
    if "%USE_GPU%"=="1" (
        docker info --format "{{.Runtimes}}" | find "nvidia" >nul 2>&1
        if !errorlevel! equ 0 (
            set GPU_FLAG=--gpus all
            echo [INFO] GPU acceleration ^(NVIDIA detected^).
        ) else (
            echo [WARNING] GPU requested but no NVIDIA runtime available - falling back to CPU.
        ) 
    ) else (
        echo [INFO] Running in CPU mode.
    )


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
) else (
    echo [INFO] Container %CONTAINER_NAME% already exists.
    docker ps --filter "name=%CONTAINER_NAME%" | find "%CONTAINER_NAME%" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [INFO] Container is already running.
    ) else (
        echo [INFO] Starting existing container...
        docker start %CONTAINER_NAME% || (
            echo [ERROR] Failed to start container.
            exit /b 1
        )
    )
)

:: 4. Display deployment information
echo.
echo [SUCCESS] Deployment completed
echo ========================
echo Gradio Access URL:   http://localhost:%GRADIO_PORT%
echo Ollama API URL:      http://localhost:%OLLAMA_PORT%
echo ========================
echo Management Commands:
echo View logs:          docker logs -f %CONTAINER_NAME%
echo Enter container:    docker exec -it %CONTAINER_NAME% bash
echo Stop container:     docker stop %CONTAINER_NAME%
echo Remove container:   docker rm -f %CONTAINER_NAME%
echo Remove image:       docker rmi %IMAGE_NAME%
echo Inspect volume:     docker volume inspect %VOLUME_NAME%

@REM :: 5. Auto-open browser (optional)
@REM timeout /t 5 >nul
@REM start "" "http://localhost:%GRADIO_PORT%"

endlocal
pause