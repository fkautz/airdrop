from ubuntu

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y sqlite3
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y ruby1.9.1
RUN apt-get install -y ruby1.9.1-dev
RUN gem install bundler
VOLUME /airdrop
WORKDIR /airdrop
