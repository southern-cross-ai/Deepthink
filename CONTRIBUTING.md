# 🧠✨ Contributing to DeepThink AI Projects

Welcome to the DeepThink AI Projects! We’re focused on building flexible and practical AI solutions tailored for various business and research applications. Our goal is to create robust, efficient, and adaptable AI systems that can be easily customized to meet specific requirements. Your contributions are essential to achieving this vision—thank you for being part of our community!

Whether you’re fixing bugs, optimizing performance, adding new features, or enhancing documentation, your effort makes a difference. We appreciate your involvement and are here to support you at every step. Don’t hesitate to reach out if you need guidance!

## 📝 Getting Started

DeepThink projects prioritize modularity, simplicity, and fast deployment. We use Docker to standardize environments and enable seamless GPU acceleration when available. The stack includes Gradio, LangChain, and Chroma, allowing for rapid prototyping and deployment of adaptive AI applications.

Running everything inside Docker ensures consistent behavior across different setups and reduces compatibility issues. Always develop and test your changes within the Docker environment to maintain stability.

## 🛠️ Prerequisites

### Docker Installation

Make sure you have Docker installed and running on your system.

- [Docker Installation Guide](https://docs.docker.com/get-docker/)
- [Docker Compose Guide](https://docs.docker.com/compose/)

#### Docker GPU Test:

To ensure your GPU is accessible, run:

```bash
docker run --gpus all nvidia/cuda:11.8.0-base nvidia-smi
```

## 🚀 Workflow Overview

### Fork the Repository

1. Go to the DeepThink GitHub page and click the "Fork" button.
2. Clone your fork to your local machine:

```bash
git clone https://github.com/yourusername/DeepThink.git
cd DeepThink
```

3. Add the upstream remote:

```bash
git remote add upstream https://github.com/Southern-Cross-AI/DeepThink.git
```

4. Verify your remotes:

```bash
git remote -v
```

### Build the Docker Container

Build the development environment using Docker:

```bash
docker build -t deepthink:latest .
```

### Start the Docker Container

Run the container with GPU support (if available):

```bash
docker run --gpus all -it --rm -v $(pwd):/workspace deepthink:latest /bin/bash
```

Inside the container, navigate to the workspace:

```bash
cd /workspace
```

### Make Your Code Changes

- Modify, enhance, or add new features as needed.
- Update the Dockerfile if you add new dependencies.

### Run Tests

Test your changes locally:

```bash
pytest tests/
```

For GPU-specific tests, run:

```bash
pytest --cuda tests/
```

Exit the container after testing:

```bash
exit
```

## 💡 Submitting Your Contribution

### Commit Your Changes

Stage and commit your changes:

```bash
git add .
git commit -m "Feature: Added new data processing module"
```

### Push Your Branch

```bash
git push origin feature/my-new-feature
```

### Open a Pull Request (PR)

1. Go to your fork on GitHub and click "Compare & pull request".
2. Clearly explain your changes and their impact.
3. Link to any related issues or discussions.

## ✅ Pull Request Review and Testing

- The PR will be reviewed and tested by maintainers.
- Feedback will be provided if modifications are necessary.
- Once approved, your changes will be merged into the main branch.

## 🤝 Community and Support

If you encounter issues or have questions, connect with us on Discord or via email at [support@southerncross.ai](mailto:support@southerncross.ai).

## 💡 Additional Tips

- Keep your Docker environment up to date before testing.
- Ensure your changes do not break existing functionality.
- Clearly document any new dependencies in the Dockerfile.

Thank you for contributing to DeepThink! Your efforts help us build practical and impactful AI solutions! 🎉
