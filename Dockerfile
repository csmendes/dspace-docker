
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

# COPY pom.xml /dspace
COPY xmlui.xconf dspace/config/
COPY local.cfg dspace/config/

RUN git config --global url."https://github.com/".insteadOf git://github.com/ \
    && mvn dependency:resolve-plugins -B \
    && mvn -U clean package 
    # -Dmirage2.on=true  
 
FROM openjdk:8-alpine as ANT_BUILD
ENV ANT_VERSION=1.8.0
ENV ANT_HOME=/opt/ant
RUN apk add --clean wget \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz

COPY --from=MAVEN_BUILD /dspace /dspace
# COPY xmlui.xconf /dspace/config/
WORKDIR /dspace/dspace/target/dspace-installer
COPY build.xml .
COPY local.cfg /dspace/dspace/config/dspace.cfg
RUN /opt/ant/bin/ant fresh_install

FROM tomcat:7.0-jdk8-openjdk-slim
RUN apt-get update -y\
    && apt-get install iputils-ping vim -y \
    && useradd -m dspace
    
COPY --from=ANT_BUILD --chown=dspace:dspace /dspace/webapps/* $CATALINA_HOME/webapps/ROOT/
COPY --from=ANT_BUILD --chown=dspace:dspace /dspace/ /dspace

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

USER dspace
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]

WORKDIR $CATALINA_HOME/webapps/
