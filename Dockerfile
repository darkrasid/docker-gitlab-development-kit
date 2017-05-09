FROM ubuntu:16.04

RUN apt-get update -y && \
      apt-get install -y sudo vim build-essential \
      zlib1g-dev libyaml-dev libssl-dev libsqlite3-dev\
      libgdbm-dev libreadline-dev libncurses5-dev \
      libffi-dev curl openssh-server checkinstall \
      libxml2-dev libxslt-dev libcurl4-openssl-dev \
      libicu-dev logrotate python-docutils \
      pkg-config cmake git-core \
      software-properties-common python-software-properties && \
      apt-add-repository -y ppa:ubuntu-lxc/lxd-stable && \
      apt-get install -y postgresql postgresql-contrib \
      libpq-dev redis-server g++ \
      nodejs nodejs-legacy npm \
      libkrb5-dev golang ed pkg-config apt-transport-https && \
      curl --location https://deb.nodesource.com/setup_7.x | bash - && \
      sudo apt-get install -y nodejs && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
      sudo apt-get update && sudo apt-get install yarn



RUN npm install phantomjs-prebuilt@2.1.12 -g
RUN sudo update-alternatives --set editor /usr/bin/vim.basic

# Install rbenv
# RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv && \
#   echo '# rbenv setup' > /etc/profile.d/rbenv.sh && \
#   echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh && \
#   echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh && \
#   echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
#   chmod +x /etc/profile.d/rbenv.sh


RUN useradd -ms /bin/bash git



USER git

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv && \
  echo '# rbenv setup' > ~/.bashrc && \
  echo 'export RBENV_ROOT=$HOME/.rbenv' >> ~/.bashrc && \
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
#echo 'export PATH=$PATH:$HOME/.rbenv/bin' >> ~/.bashrc
  # chmod +x /etc/profile.d/rbenv.sh
  


# install ruby-build
RUN mkdir -p $HOME/.rbenv/plugins && \ 
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build 


#RUN echo $PATH
#RUN ln -s ~/.rbenv/shims /usr/local/rbenv/shims
# RUN ln -s ~/.rbenv/bin/rbenv /usr/local/bin/rbenv


#RUN chmod 755 ~/.rbenv/shims
# RUN chmod 755 ~/.rbenv/bin/rbenv

ENV PATH /home/git/.rbenv/shims:/home/git/.rbenv/bin:/home/git/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#ENV PATH /home/git/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# USER root 
# USER git

RUN rbenv install 2.3.3  

RUN rbenv global 2.3.3
RUN rbenv rehash
  # rbenv global 2.3.3 && \
  # rbenv local 2.3.3 && \
  # rbenv rehash   
#
# #ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#
RUN gem install bundler

WORKDIR /home/git 

RUN gem install gitlab-development-kit && \
  gdk init

RUN cd gitlab-development-kit && \
  gdk install 
  # cd ~ && \
  # mv gitlab-development-kit tmp-gitlab
