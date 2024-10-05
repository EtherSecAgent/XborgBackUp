# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y borgbackup curl openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Set the environment variable for the Borg passphrase
ENV BORG_PASSPHRASE_FILE=/root/.borgbackup/password

# Create necessary directories
RUN mkdir -p /opt/scripts/xborg /root/.borgbackup

# Copy the password file into the container
COPY password /root/.borgbackup/password

# Copy the backup script to the container
COPY Auntie-Daily-Borg.sh /opt/scripts/xborg/Auntie-Daily-Borg.sh

# Make the script executable
RUN chmod +x /opt/scripts/xborg/Auntie-Daily-Borg.sh

# Set the default command to run the backup script
CMD ["/opt/scripts/xborg/Auntie-Daily-Borg.sh"]
