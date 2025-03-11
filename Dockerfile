FROM my-wsl-image:latest

RUN apt update && apt upgrade -y

RUN apt install build-essential procps curl file git -y

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN useradd -m -s /usr/sbin/nologin k && \
    echo 'k ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER root

USER k
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

RUN echo 'hi'

RUN git clone https://github.com/argvk/my-config ~/my-config

RUN brew bundle install --file=~/my-config/Brewfile

RUN cp ~/my-config/config.fish ~/.config/fish/config.fish
RUN cp ~/my-config/fish_plugins ~/.config/fish/fish_plugins
RUN fisher update
