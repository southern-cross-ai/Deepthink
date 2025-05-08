@echo off
REM === Build the Docker image ===
docker build -t ollama-gradio-app .

REM === Run container in background ===
docker run -d -p 7860:7860 -p 11434:11434 -v %USERPROFILE%\.ollama:/root/.ollama --name ollama-ui ollama-gradio-app

REM === Wait for Gradio frontend to be ready ===
echo Waiting for Gradio to be ready...
:wait_loop
powershell -Command "(Invoke-WebRequest -Uri http://localhost:7860 -UseBasicParsing -TimeoutSec 2) > $null 2>&1"
IF %ERRORLEVEL% NEQ 0 (
  timeout /t 1 >nul
  goto wait_loop
)

REM === Open the Gradio frontend in browser ===
start http://localhost:7860
