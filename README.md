# Docker Embedded image

## Installation

Via Docker Hub

    docker pull tralamazza/embedded
    
Manual build

    git clone <this repo>
    docker build -t tralamazza/embedded .


## Usage

#### Call `make` on a shared local folder

    docker run --rm -v ${PWD}:/project tralamazza/embedded sh -c 'cd /project && make'

#### bash interactive session

    docker run --privileged --rm -v ${PWD}:/project -it tralamazza/embedded bash


## Issues

No USB support on Windows using Hyper-V (https://github.com/docker/for-win/issues/1018)
