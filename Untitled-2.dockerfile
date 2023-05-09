
# ARG DSPACE_SOURCE_CODE=https://github.com/ibict-br2/repositorio-padrao/archive/dspace-6_x.zip

ARG DSPACE_SOURCE_CODE=https://github.com/DSpace/DSpace/archive/dspace-6_x.zip

FROM alpine as CLONE_CODE
ARG DSPACE_SOURCE_CODE

RUN wget -O dspace.zip $DSPACE_SOURCE_CODE \
    && unzip dspace.zip \
    && mv DSpace-dspace-6_x dspace
#  && mv repositorio-padrao-dspace-6_x dspace

FROM maven:3.6.3-openjdk-8 as MAVEN_BUILD
COPY --from=CLONE_CODE /dspace /dspace
WORKDIR /dspace
RUN apt-get update \
    && apt-get install -y git curl build-essential libssl-dev ruby-full make patch zlib1g-dev liblzma-dev\
    && apt-get clean -y 

# COPY Gemfile .
# COPY Gemfile.lock .

# COPY sh/ /sh/
# RUN mkdir /sh
# COPY /sh/nvm_install.sh .
# COPY /sh/node_install.sh .
# COPY /sh/npm_deps.sh .
# COPY /sh/ruby_install.sh /sh/
# COPY /sh/rvm_activate.sh /sh/
# COPY /sh/template_deps.sh .

# RUN bash nvm_install.sh 
# RUN bash node_install.sh 
# RUN bash npm_deps.sh 
# RUN bash /sh/ruby_install.sh
# RUN bash /sh/rvm_activate.sh
# RUN bash template_deps.sh

# RUN bash /sh/nvm_install.sh 
# RUN bash /sh/node_install.sh 
# RUN bash /sh/npm_deps.sh 
# # RUN bash /sh/ruby_install.sh
# # RUN bash /sh/rvm_activate.sh
# RUN bash /sh/template_deps.sh


# RUN . ~/.bashrc \
#     && gpg --keyserver pool.sks-keyservers.net --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#     && nvm install 14.15.1 \
#     && nvm alias default 14.15.1\
#     && npm install -g bower \
#     && npm install -g grunt --force\
#     && npm install -g grunt-cli --force

# RUN apt-get install gnupg2 \ 
#     && gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#     && curl -sSL https://get.rvm.io | bash -s stable --rails

# COPY rvm_activate.sh .
# RUN echo "EXECUTING rvm_activate.sh" \
#     && exec bash rvm_activate.sh  

# RUN useradd -m dspace

# RUN echo "USER: $USER" \
#     && ls \
#     && chown -R dspace:dspace /root
# RUN exec gem install sass -v 3.3.14 \
#     && gem install compass -v 1.0.1

COPY pom.xml /dspace
COPY xmlui.xconf /dspace/config/

RUN  . ~/.bashrc \
    && git config --global url."https://github.com/".insteadOf git://github.com/ \   
    && mvn dependency:resolve-plugins -B 

COPY local.cfg /dspace/config/local.cfg
# RUN useradd -m dspace

# USER dspace

# WORKDIR /dspace/dspace-xmlui-mirage2/src/main/webapp/
# COPY Gemfile .
# COPY Gemfile.lock .

# RUN . ~/.bashrc \
#  && apt-get install  -y \
#  && gem install nokogiri -v 1.10.10  \
#  && bundle install \
#  && compass -v

WORKDIR /dspace

RUN . ~/.bashrc \
 && git config --global url."https://github.com/".insteadOf git://github.com/ \ 
 && mvn -U clean package -Dmirage2.on=true  
 
#  -Dmirage2.deps.included=false


FROM openjdk:8-alpine as ANT_BUILD
ENV ANT_VERSION=1.8.0
ENV ANT_HOME=/opt/ant
RUN apk add --clean wget \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz

COPY --from=MAVEN_BUILD /dspace /dspace
COPY xmlui.xconf /dspace/config/
WORKDIR /dspace/dspace/target/dspace-installer
COPY build.xml .
COPY local.cfg /dspace/config/dspace.cfg
RUN /opt/ant/bin/ant init_installation update_configs update_code update_webapps update_solr_indexes fresh_install
# init_installation update_configs update_code update_webapps update_solr_indexes 


FROM tomcat:7.0-jdk8-openjdk-slim
RUN apt-get update -y\
    && apt-get install iputils-ping vim -y \
    && useradd -m dspace
    
COPY --from=ANT_BUILD --chown=dspace:dspace /dspace/webapps/* $CATALINA_HOME/webapps/ROOT/
COPY --from=ANT_BUILD --chown=dspace:dspace /dspace/ /dspace

USER dspace

CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]

# RUN /dspace/bin/dspace create-administrator -e "dspace@email.com" -f "dspace" -l "dspace" -c "pt-br" -p "dspacepass"

WORKDIR $CATALINA_HOME/webapps/

