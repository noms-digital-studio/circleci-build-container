FROM ubuntu

#Check for package upgrades
RUN apt-get update

#Basic build deps
RUN apt-get install -y git curl apt-transport-https software-properties-common ca-certificates

#Install docker
RUN apt-get remove docker docker-engine
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce

#CircleCI requirements
RUN apt-get install -y net-tools netcat unzip zip locales sudo openssh-client ca-certificates tar gzip parallel
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN groupadd --gid 3434 circleci \
  && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
  && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep


#Setup php
##Horrid hack, bug filed
##https://bugs.launchpad.net/ubuntu/+source/software-properties/+bug/1699086
RUN add-apt-repository ppa:ondrej/php -y ; exit 0
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated php7.1 libphp7.1-embed php7.1-cgi php7.1-cli php7.1-dev php7.1-fpm php7.1-phpdbg php7.1-bcmath php7.1-bz2 php7.1-common php7.1-curl php7.1-dba php7.1-enchant php7.1-gd php7.1-gmp php7.1-imap php7.1-interbase php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-odbc php7.1-pgsql php7.1-pspell php7.1-readline php7.1-recode php7.1-snmp php7.1-soap php7.1-sqlite3 php7.1-sybase php7.1-tidy php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-opcache php7.1-xsl
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
RUN sed -i 's/zend.assertions = -1/zend.assertions = 1/' /etc/php/7.1/cli/php.ini

#Setup node/npm
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash
RUN apt-get install -y nodejs

#Setup yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

#Setup ruby
RUN apt-get install -y ruby
RUN gem install bundler

#Setup python
RUN apt-get install -y python-pip python3-pip

USER circleci

CMD ["/bin/sh"]
