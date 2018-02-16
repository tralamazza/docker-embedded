FROM base/devel
MAINTAINER tralamazza

ENV XTENSA_TOOLCHAIN xtensa-esp32-elf-linux64-1.22.0-75-gbaf03c2-5.2.0

# init
RUN pacman -Suy --noconfirm
RUN pacman-key --init && \
    update-ca-trust && \
    pacman-db-upgrade

# base packages
RUN pacman -S --noconfirm wget python git zip

# the yak: aur packages -> pacaur -> cower -> import gpg keys -> makepkg can't root -> create makepkg user
RUN useradd -m --shell=/bin/false build && \
    passwd -d build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    sudo -u build sh -c 'gpg --keyserver hkp://pgp.mit.edu --recv-keys 1EB2638FF56C0C53' && \
    sudo -u build sh -c 'cd ~ && git clone https://aur.archlinux.org/cower.git && cd cower && makepkg -si --noconfirm' && \
    sudo -u build sh -c 'cd ~ && git clone https://aur.archlinux.org/pacaur.git && cd pacaur && makepkg -si --noconfirm'
# now we can use `sudo -u build sh -c 'pacaur -S ...'` to intall AUR packages

# ARM
RUN pacman -S --noconfirm arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib

# AVR
RUN pacman -S --noconfirm avr-binutils avr-gcc avr-gdb avr-libc

# Xtensa (https://esp-idf.readthedocs.io/en/latest/get-started/linux-setup.html)
RUN sudo -u build sh -c 'pacaur -S --noconfirm gcc-xtensa-esp32-elf-bin'
RUN sudo -u build sh -c 'gpg --keyserver keys.gnupg.net --recv-keys 702353E0F7E48EDB' && \
    sudo -u build sh -c 'pacaur -S --noconfirm ncurses5-compat-libs' && \
    pacman -S --noconfirm gperf python2-pyserial && \
    mkdir -p xtensa && \
    cd xtensa && \
    wget https://dl.espressif.com/dl/${XTENSA_TOOLCHAIN}.tar.gz && \
    tar xf ${XTENSA_TOOLCHAIN}.tar.gz

# Java
RUN pacman -S --noconfirm jre9-openjdk
