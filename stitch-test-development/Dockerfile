# Dockerfile to generate a production image.

FROM ubuntu:rolling
LABEL maintainer="labrat.eu"

# Run dependencies script.
COPY dependencies/ubuntu/install-run-dependencies.sh install-run-dependencies.sh 

# Run and remove the script.
RUN ./install-run-dependencies.sh
RUN rm install-run-dependencies.sh

# Clear the unused apt files.
RUN rm -rf /var/lib/apt/lists/*

# Add runtime binaries and scripts.
COPY bin/native/cpp /usr/bin/cpp
COPY bin/native/lib/liblabrat_cpp.so.1 /usr/lib/liblabrat_cpp.so.1
COPY docker/entrypoint.sh /entrypoint.sh

# Set entrypoint.
ENTRYPOINT ["/entrypoint.sh"]
