# Ollama-Gradio Docker Project

## Project Overview
A containerized solution combining Ollama's LLM capabilities with Gradio's web interface.

## System Requirements

### Minimum Specifications
- **Docker**: 20.10+
- **RAM**: 16GB 
- **Storage**: 20GB available
- **OS**: Windows 10+/macOS 10.15+/Linux (x86_64)

### Recommended Specifications
- **Docker**: Latest stable
- **RAM**: 32GB+
- **Storage**: 50GB SSD
- **GPU**: NVIDIA with CUDA 12+ support

## Quick Start Guide

### For Windows Users
```batch
:: Method 1 - Graphical:
Double-click build_and_run.bat

:: Method 2 - Command Line:
start /B build_and_run.bat
```

### For Unix/Linux/macOS Users
```bash
# 1. Make script executable
chmod +x build_and_run.sh

# 2. Run with privileges
./build_and_run.sh
```

## File Structure
```
.
├── build_and_run.bat        # Windows automation script
├── build_and_run.sh         # Unix shell script
├── Dockerfile               # Container definition
├── gradio_app.py            # Web interface code
├── requirements.txt         # Python dependencies
└── supervisord.conf         # Process management
```

## Network Configuration

| Port  | Service          | Protocol | Description                 |
|-------|------------------|----------|-----------------------------|
| 7860  | Gradio Web UI    | HTTP     | Interactive interface       |
| 11434 | Ollama API       | HTTP     | Model management endpoint   |

## Advanced Configuration

### Environment Variables
```bash
# For GPU support
export USE_GPU=1
```

## Troubleshooting

### Common Issues
1. **GPU Not Detected**:
   ```bash
   # Verify NVIDIA toolkit installation
   nvidia-smi
   ```

2. **Port Conflicts**:
   ```bash
   # Check running services
   sudo lsof -i :7860 -i :11434
   ```

## License
MIT License © 2023