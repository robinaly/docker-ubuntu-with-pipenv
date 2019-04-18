ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}
ARG PYTHON_VERSION=3.7.2
# FIX user id for user motoko
ARG UID=10000
# use bash shell as default
SHELL ["/bin/bash", "-c"]

# install dependencies for python, pip and pipenv
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    	sudo \
    	curl \
    	git \
    	gcc \
    	make \
    	openssl \
    	libssl-dev \
    	libbz2-dev \
    	libreadline-dev \
    	libsqlite3-dev \
    	zlib1g-dev \
    	libffi-dev \
    	ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# add the user Motoko, tribute to https://en.wikipedia.org/wiki/Motoko_Kusanagi
RUN useradd --create-home --shell /bin/bash --no-log-init --system -u ${UID} motoko && \
  echo "motoko  ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

USER motoko
WORKDIR /home/motoko

# set some local environment variables
ENV LANG en_US.UTF-8

# install pyenv for motoko
RUN curl -o run.sh https://pyenv.run && \
	# uncomment for generating checksum
    #sha256sum run.sh > check.txt && \
    #cat check.txt && \
  	echo "bba6650e68eb9cb8b8aff98f478214c338ac03612b23a73454f8746520f53c85  run.sh" > check.txt && \
  	sha256sum -c check.txt && \
  	rm check.txt && \
  	cat run.sh | bash && \
  	rm run.sh

# update path to use pyenv
ENV PATH ~/.pyenv/bin:~/.local/bin:$PATH

# set the bashrc (for interactive sessions) and bash_profile (for login sessions)
RUN echo "eval \"\$(pyenv init -)\"" > ~/pyenv_init && \
    echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/pyenv_init && \
    cat ~/pyenv_init >> ~/.bash_rc && \
    cat ~/pyenv_init >> ~/.bash_profile && \
    rm  ~/pyenv_init
	  
# tell non-interactive shells to still use ~/.bashrc
#ENV BASH_ENV=~/.bashrc

# use login bash shell as default from now on, so that the bash_profile is sourced before any RUN command
SHELL ["/bin/bash", "-lc"]

# install python ${PYTHON_VERSION}, upgrade pip, and install pipenv
RUN pyenv update && \
	pyenv install ${PYTHON_VERSION} && \
	pyenv global  ${PYTHON_VERSION} && \
	pip install --user --upgrade pip && \
	pip install --user --upgrade pipenv


