FROM alessiomorale/jetson-builder-cv:r32.4.4_cv4.4.0_1.1

# install tzdata avoiding interactive prompts
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    apt-get update && \
    apt-get install --upgrade ca-certificates && \
    DEBIAN_FRONTEND=noninteractive apt-get install  --upgrade gnupg2 tzdata -y && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean autoclean -y

# install the base environment and all build tools
RUN apt-get update && \
    apt-get install build-essential cmake git python3-pip python3 python3-dev -y --no-install-recommends && \
    apt-get clean autoclean -y
RUN pip3 --no-cache-dir install scikit-build
RUN apt-get update && \
    apt-get install \
    python3-pandas \
    python3-h5py \
    libhdf5-serial-dev \
    hdf5-tools \
    libhdf5-dev \
    zlib1g-dev \
    zip \
    libjpeg8-dev \
    liblapack-dev \
    libblas-dev \
    gfortran \
    nano \
    ntp \
    libxslt1-dev \
    libxml2-dev \
    libffi-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpng-dev \
    openmpi-doc \
    openmpi-bin \
    libopenmpi-dev \
    libopenblas-dev \
    -y --no-install-recommends && \
    apt-get clean autoclean -y

RUN pip3 install -U --no-cache-dir pip testresources setuptools
RUN pip3 install -U --no-cache-dir futures==3.1.1 protobuf==3.12.2 pybind11==2.5.0
RUN pip3 install -U --no-cache-dir cython==0.29.21
RUN pip3 install -U --no-cache-dir numpy==1.19.0
RUN pip3 install -U --no-cache-dir future==0.18.2 mock==4.0.2 h5py==2.10.0 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.3.3 
RUN pip3 install -U --no-cache-dir grpcio==1.30.0 absl-py==0.9.0 py-cpuinfo==7.0.0 psutil==5.7.2 portpicker==1.3.1 six requests==2.24.0 astor==0.8.1 termcolor==1.1.0 wrapt==1.12.1 google-pasta==0.2.0
RUN pip3 install -U --no-cache-dir scipy==1.4.1
RUN pip3 install -U --no-cache-dir pandas==1.0.5
RUN pip3 install -U --no-cache-dir gdown
RUN pip3 install --no-cache-dir --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==2.2.0+nv20.6

RUN apt-get update && \
    apt-get install \
    libjpeg-dev \ 
    zlib1g-dev \
    libpython3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    -y --no-install-recommends && \
    apt-get clean autoclean -y

# Install PyTorch v1.7 - torchvision v0.8.1
RUN wget https://nvidia.box.com/shared/static/wa34qwrwtk9njtyarwt5nvo6imenfy26.whl -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl && \
    pip3 install ./torch-1.7.0-cp36-cp36m-linux_aarch64.whl && \
    rm  ./torch-1.7.0-cp36-cp36m-linux_aarch64.whl
RUN ls /usr/local/cuda
RUN mkdir -p ~/projects; cd ~/projects && \
    git clone --branch v0.8.1 https://github.com/pytorch/vision torchvision && \
    cd torchvision && \
    export BUILD_VERSION=0.8.1 && \
    python3 setup.py install
RUN pip3 install -U --no-cache-dir virtualenv

RUN mkdir -p /projects; cd /projects
WORKDIR /projects

SHELL ["/bin/bash"]

RUN ["/bin/bash", "-c", "echo 'export CUDA_HOME=/usr/local/cuda' >> /root/.bashrc"]
RUN ["/bin/bash", "-c", "echo 'export PATH=$CUDA_HOME/bin:$PATH' >> /root/.bashrc"]
RUN ["/bin/bash", "-c", "echo 'export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH' >> /root/.bashrc"]

COPY /resources/docker-entrypoint.sh /


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
