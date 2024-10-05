# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y borgbackup curl openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Set the environment variable for the Borg passphrase
ENV BORG_PASSPHRASE_FILE=/root/.borgbackup/password

# Create necessary directories
RUN mkdir -p /opt/scripts/xborg /root/.borgbackup /root/.ssh

# Copy the SSH keys and known_hosts file to the container
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY known_hosts /root/.ssh/known_hosts

# Set the proper permissions for the SSH keys
RUN chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub /root/.ssh/known_hosts

# Copy the password file into the container
COPY password /root/.borgbackup/password

# Copy the backup script to the container
COPY Auntie-Daily-Borg.sh /opt/scripts/xborg/Auntie-Daily-Borg.sh

# Make the script executable
RUN chmod +x /opt/scripts/xborg/Auntie-Daily-Borg.sh

# Set the default command to run the backup script
CMD ["/opt/scripts/xborg/Auntie-Daily-Borg.sh"]
