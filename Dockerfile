# Use Ubuntu as the base image
FROM ubuntu:latest AS base
USER root
# Set environment variables
ENV HADOOP_VERSION=3.3.6
ENV SPARK_VERSION=3.5.0

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y wget openssh-server openjdk-11-jdk --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
    # mv /usr/lib/jvm/java-11-openjdk /opt/java && \
    # update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1 && \
    # update-alternatives --set java ${JAVA_HOME}/bin/java

# Install Hadoop & Spark
# RUN wget -O - https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C /opt/ && \
#     cd /opt && \
#     mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
#     rm -rf hadoop-${HADOOP_VERSION}
# RUN wget -O - https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz | tar -xz -C /opt/ && \
#     cd /opt && \
#     mv spark-${SPARK_VERSION}-bin-without-hadoop /opt/spark && \
#     rm -rf spark-${SPARK_VERSION}-bin-without-hadoop


# Copy specific tar and tgz files into the same destination directory
COPY hadoop-${HADOOP_VERSION}.tar.gz /opt/
# COPY spark-${SPARK_VERSION}-bin-without-hadoop.tgz /opt/

# Unpack Hadoop tar file
RUN tar -xzf /opt/hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ \
    && mv /opt/hadoop-${HADOOP_VERSION} /opt/hadoop/ \
    && rm -f /opt/hadoop-${HADOOP_VERSION}.tar.gz

# Unpack Spark tgz file
# RUN tar -xzf /opt/spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C /opt/ \
#     && mv /opt/spark-${SPARK_VERSION}-bin-without-hadoop /opt/spark/ \
#     && rm -f /opt/spark-${SPARK_VERSION}-bin-without-hadoop.tgz

# Application Image
FROM python:3.11.7

USER root
# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV SPARK_HOME=/opt/spark
ENV PATH=${PATH}:${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${SPARK_HOME}/bin

COPY --from=base $JAVA_HOME $HADOOP_HOME $SPARK_HOME

# Generate SSH key for communication between nodes
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""

# Start a shell by default
RUN mkdir -p /opt/work
WORKDIR /opt/work
CMD ["/bin/bash"]
