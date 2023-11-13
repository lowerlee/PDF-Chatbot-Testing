# Start from the PyTorch base image with PyTorch 1.10 and CUDA 11.1
# FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-runtime

FROM nvidia/cuda:11.3.1-devel-ubi8

# Install system dependencies and Python
RUN yum update -y && yum install -y \
    python3 \
    python3-pip \
    python3-devel \
    git \ 
    && yum clean all

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install Python dependencies (https://pytorch.org/get-started/previous-versions/#wheel-7)
RUN pip install torch==1.10.0 torchvision==0.11.0 torchaudio==0.10.0 \
    layoutparser layoutparser[ocr] opencv-python-headless \
    jupyter notebook -f https://download.pytorch.org/whl/torch_stable.html

RUN pip install "git+https://github.com/facebookresearch/detectron2.git@v0.5#egg=detectron2"

# # Install Detectron2 compatible with PyTorch 1.10 and CUDA 11.1
# RUN pip install detectron2 -f \
#     https://dl.fbaipublicfiles.com/detectron2/wheels/cu113/torch1.10/index.html

# Add CUDA paths to PATH and LD_LIBRARY_PATH
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Set the working directory
WORKDIR /app

# Copy your notebook and any necessary files into the container
COPY . /app

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter notebook when the container launches
CMD ["jupyter", "notebook", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]