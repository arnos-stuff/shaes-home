FROM phusion/baseimage:latest-amd64

RUN install_clean \
 build-essential rsync file curl time wget git git-lfs tmux zsh sudo neovim unzip httpie iputils-ping \
 software-properties-common cmake make gcc g++ 

# user setup
ARG luser=shae
ENV LUSER=${luser}
ENV TERM=xterm-256color

RUN groupadd -r ${LUSER} -g 777
RUN useradd -m -u 777 -r -g 777 -s /usr/bin/zsh ${LUSER}
RUN adduser ${LUSER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY ./shell /home/${LUSER}/shell


RUN apt-get update && \
    apt-get install -y -q --allow-unauthenticated \
    git \
    sudo
RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew

USER ${LUSER}
WORKDIR /home/${LUSER}
ENV HOME=/home/${LUSER}
RUN export HOME=${HOME}

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV ZI_HOME=/home/${LUSER}/.zi
RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew
RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew/Cellar
ENV BREW_ROOT=/home/linuxbrew/.linuxbrew
RUN ${BREW_ROOT}/bin/brew install starship zoxide

SHELL [ "/bin/zsh", "-i", "-lc" ]
RUN command mkdir -p "${ZI_HOME}/bin"
RUN compaudit | xargs chown -R "$(whoami)" "${ZI_HOME}"

RUN compaudit | xargs chmod -R go-w "${ZI_HOME}"
RUN git clone https://github.com/z-shell/zi.git "${ZI_HOME}/bin"
RUN git config --global --add safe.directory "${ZI_HOME}/bin"

RUN typeset -A ZI ; ZI[BIN_DIR]="${HOME}/.zi/bin"

RUN eval "$(cat ${ZI_HOME}/bin/zi.sh)"

RUN export fpath=(${BREW_ROOT}/share/zsh-completions $fpath)
RUN autoload -Uz _zi ; (( ${+_comps} )) && _comps[zi]=_zi
RUN autoload -Uz compinit ; compinit
USER ${LUSER}
WORKDIR /home/${LUSER}/code/configs/

COPY shell/zsh/shae-ubuntu-zshrc /home/${LUSER}/.zshrc
COPY shell/zsh/shae-ubuntu-zshenv /home/${LUSER}/.zshenv
COPY shell/zsh/shae-ubuntu-zshenv /etc/zshenv
COPY shell/zsh/shae-ubuntu-zshrc /etc/zshrc

COPY shell/zsh/run.zsh /home/${LUSER}/run.zsh

USER root
RUN chmod -R 777 /home
RUN chown -R ${LUSER}:${LUSER} /home/${LUSER}/.zshrc
RUN chown -R ${LUSER}:${LUSER} /home/${LUSER}

USER ${LUSER}
RUN mkdir /home/${LUSER}/.cargo
RUN touch /home/${LUSER}/.cargo/.env


RUN git clone https://github.com/arnos-stuff/starship-themes starship

RUN mkdir -p /home/${LUSER}/.config/
RUN cp starship/g-g-go.toml /home/${LUSER}/.config/starship.toml

RUN zi self-update 2> /dev/null || true;
RUN zi update --all -p 15 2> /dev/null || true;
RUN zi compile --all 2> /dev/null || true;

WORKDIR /home/${LUSER}/

ENTRYPOINT ["/bin/zsh", "-i", "-l"]
