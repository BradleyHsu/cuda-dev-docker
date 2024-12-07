# CUDA Development Environment

A Docker-based development environment optimized for CUDA development on H100 GPUs, with PyTorch support.

## Features

- CUDA 12.2 development tools and runtime
- NVIDIA development & debugging tools:
  - NSight Systems
  - NSight Compute
  - CUDA-GDB
  - CUDA-MEMCHECK
  - NVIDIA Visual Profiler
- PyTorch with CUDA support
- Customized development environment:
  - Vim with optimized configuration and Tokyo Night theme
  - Oh My Zsh with Powerlevel10k
  - Conda environment management

## Prerequisites

- Docker installed
- NVIDIA Container Toolkit
- NVIDIA drivers supporting CUDA 12.2
- H100 GPU

## Building

```bash
# Clone this repository
git clone <your-repo-url>
cd cuda-dev

# Build the Docker image
docker build -t cuda-dev .