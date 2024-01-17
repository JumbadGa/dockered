# Application Image
FROM python:3.11.7

USER root
# Set environment variables


COPY --from=base $JAVA_HOME $JAVA_HOME
COPY --from=base $HADOOP_HOME $HADOOP_HOME
COPY --from=base $SPARK_HOME $SPARK_HOME

# Generate SSH key for communication between nodes
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ""

# Start a shell by default
RUN mkdir -p /opt/work
WORKDIR /opt/work
CMD ["/bin/bash"]
