# Use NVIDIA's base image with CUDA and cuDNN
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    lsb-release \
    software-properties-common \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Add NVIDIA CUDA repository manually
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb -o cuda-keyring.deb \
    && dpkg -i cuda-keyring.deb \
    && rm cuda-keyring.deb \
    && apt-get update

# Add NVIDIA Container Toolkit repository
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -fsSL https://nvidia.github.io/libnvidia-container/ubuntu22.04/libnvidia-container.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    > /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && apt-get update


# Install TensorRT
RUN apt-get install -y \
    libnvinfer8 \
    libnvonnxparsers8 \
    libnvparsers8 \
    libnvinfer-plugin8 \
    python3-libnvinfer \
    && rm -rf /var/lib/apt/lists/*

# Add ROS 2 repository
RUN curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc \
    | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros2-latest.list \
    && apt-get update

RUN apt-cache search ros-humble*
# Install ROS 2
RUN apt-get install -y \
    ros-${ROS_DISTRO}-ros-base \
    && rm -rf /var/lib/apt/lists/*

# Add colcon repository and install colcon extensions
RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Intall requirements
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip 
RUN python3 -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
RUN python3 -m pip install transformers sentencepiece accelerate bitsandbytes protobuf

# Source ROS 2 setup script
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# Install additional ROS 2 tools
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-ros-base \
    && rm -rf /var/lib/apt/lists/*


# Verify installation of TensorRT
RUN dpkg -l | grep nvinfer

# Verify installation of ROS 2
RUN source /opt/ros/${ROS_DISTRO}/setup.bash

# Set the working directory
WORKDIR /workspace

# Set default command
CMD ["/bin/bash"]

