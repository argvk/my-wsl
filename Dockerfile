FROM my-wsl-image:latest

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb

RUN apt update && apt upgrade -y
RUN apt install -y \
    build-essential \
    procps \
    curl \
    file \
    git \
    fish \
    cuda-toolkit-12-8 \
    cuda-toolkit-12-4 \
    direnv \
    postgresql-client

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN useradd -m -s /usr/bin/fish k && \
    echo 'k ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER k

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

ENV SHELL=/usr/bin/fish
RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
RUN fish -c "fisher -v"

WORKDIR /home/k
RUN git clone https://github.com/argvk/my-config my-config

RUN brew bundle install --file=my-config/Brewfile

RUN mkdir -p .config/fish
RUN cp my-config/config.fish .config/fish/config.fish
RUN cp my-config/fish_plugins .config/fish/fish_plugins
RUN fish -c "fisher update"

COPY terminal-profile.json /usr/share/wsl/terminal-profile.json
COPY wsl.conf /etc/wsl.conf
