# Sample user configuration file.
#
# To use this file:
# Copy this file to /root/cp-user-vars.sh 
# edit the file contents
# save the file

# Number of seconds to wait for the Docker daemon before timing out,
# and the socket we'll test for.
DOCKER_DAEMON_TIMEOUT=10
DOCKER_SOCKET="/var/run/docker.sock"

# Pointing CRASHPLAN_DIR to an existing CrashPlan directory will allow
# the new container to take over for a previous installation, without
# the need to adopt the old computer.
CRASHPLAN_DIR="/usr/local/etc/crashplan"

# Pointing DATA_DIR to an existing CrashPlan backup archive
# will allow the new instance of CrashPlan to skip a lot of time
# synchronizing the backup state.
DATA_DIR="/volume1/CrashPlanBackups"

# Add/change entries here to suit your needs, for example:
# USER_VOLUMES="-v /volume1:/volume1:ro -v /photos:/photos:ro"
#
# The default setting will give the CrashPlan container read-only
# access to /volume1
USER_VOLUMES="-v /volume1:/volume1:ro"

