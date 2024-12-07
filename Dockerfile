# Base image with CUDA support
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# Prevent timezone prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    vim \
    wget \
    curl \
    gcc \
    g++ \
    gdb \
    make \
    python3-dev \
    python3-pip \
    zsh \
    fonts-powerline \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Set up vim color scheme
RUN mkdir -p ~/.vim/colors && \
    curl -o ~/.vim/colors/tokyonight.vim https://raw.githubusercontent.com/ghifarit53/tokyonight-vim/master/colors/tokyonight.vim

# Set up conda environment with PyTorch
RUN $CONDA_DIR/bin/conda create -n cuda_dev python=3.10 -y && \
    $CONDA_DIR/bin/conda init zsh && \
    echo "conda activate cuda_dev" >> ~/.zshrc

RUN $CONDA_DIR/bin/conda run -n cuda_dev \
    conda install -y pytorch pytorch-cuda -c pytorch -c nvidia

# Set up vim configuration
COPY .vimrc /root/.vimrc

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configure Powerlevel10k as the theme
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Enable syntax highlighting
RUN echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Copy p10k configuration
COPY .p10k.zsh /root/.p10k.zsh

# Add p10k config source to zshrc
RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

# Add CUDA development environment variables
ENV PATH="${CONDA_DIR}/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_HOME="/usr/local/cuda"

# Create workspace directory
WORKDIR /workspace

# Set zsh as default shell
RUN chsh -s $(which zsh)

# Default command to start zsh
CMD ["zsh"]
