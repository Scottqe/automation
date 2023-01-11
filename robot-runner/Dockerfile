FROM linuxserver/docker-compose

User root

#=========================================
# apt-get Install related tools
#=========================================
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    python-numpy \
    iproute2 \
    git \
    curl \
    sudo \
    software-properties-common \
    wget \
    zip \
    unzip

#=========================================
# Install robotframework and library
#=========================================
RUN pip3 install -U \
    requests \
    robotframework \
    robotframework-requests \
    robotframework-seleniumlibrary \
    robotframework-selenium2library \
    robotframework-httplibrary \
    robotframework-faker \
    robotframework-imaplibrary \
    pexpect \
    websocket \
    click \
    pytz \
    websocket-client \
    selenium \
    docker \
    jsonref \
    deepdiff \
    jsonschema \
    websockets \
    boto3

#==================================
# Workspace
#==================================
RUN mkdir /home/robot
RUN mkdir /home/robot/robot-runner
COPY . /home/robot/robot-runner
VOLUME /home/robot
WORKDIR /home/robot


#==================================
# Install Docker CLI 
#==================================
RUN curl -O https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz && \
    tar zxvf docker-18.03.1-ce.tgz && \
    cp docker/docker /usr/local/bin/ && \
    rm -rf docker docker-18.03.1-ce.tgz

#==================================
# Install python dotenv
#==================================
RUN pip3 install -U python-dotenv
