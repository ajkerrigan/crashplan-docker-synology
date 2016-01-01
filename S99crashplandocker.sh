#!/bin/sh
#
# Startup script for running CrashPlan in a Docker container on a Synology
# NAS.
#
# AJ Kerrigan

IMAGE=ajkerrigan/crashplan

# Pointing CRASHPLAN_DIR to an existing CrashPlan directory will allow
# the new container to take over for a previous installation, without
# the need to adopt the old computer.
CRASHPLAN_DIR="/usr/local/etc/crashplan"

# Pointing DATA_DIR to an existing CrashPlan backup archive
# will allow the new instance of CrashPlan to skip a lot of time
# synchronizing the backup state.
DATA_DIR="/volume1/CrashPlan/backupArchives"

# Add/change entries here to suit your needs, for example:
# USER_VOLUMES="-v /volume1:/volume1:ro -v /photos:/photos:ro"
#
# The default setting will give the CrashPlan container read-only
# access to /volume1
USER_VOLUMES="-v /volume1:/volume1:ro"

VOLUMES="${USER_VOLUMES} -v ${CRASHPLAN_DIR}:/config -v ${DATA_DIR}:/data -v /etc/localtime:/etc/localtime:ro"
PORTS="-p 4242:4242 -p 4243:4243"
RUN_CMD="docker run -d --net=host --name=crashplan ${VOLUMES} ${PORTS}"
START_CMD="docker start"
STOP_CMD="docker stop"
PS_CMD="docker ps --all --filter name=crashplan"

CONTAINER_ID=`${PS_CMD} | tail -n +2 | cut -d ' ' -f 1`
[ ${CONTAINER_ID} ] && CONTAINER_STATUS=`docker inspect --format="{{.SynoStatus}}" ${CONTAINER_ID}`

case $1 in
start)
    if [ -z ${CONTAINER_ID} ]; then
        echo "No existing CrashPlan container found. Running image \"${IMAGE}\"."
        ${RUN_CMD} ${IMAGE}
    elif [ ${CONTAINER_STATUS} == "exited" ]; then
        echo "Starting CrashPlan container with ID ${CONTAINER_ID}."
        ${START_CMD} ${CONTAINER_ID}
    else
        echo "Skipping start for CrashPlan container (ID ${CONTAINER_ID}) with \"${CONTAINER_STATUS}\" status."
    fi
    exit 0
    ;;

stop)
    if [ -z ${CONTAINER_ID} ]; then
        echo "Can't find a CrashPlan container to stop."
    elif [ ${CONTAINER_STATUS} == "running" ]; then
        echo "Stopping CrashPlan container (ID ${CONTAINER_ID})."
        ${STOP_CMD} ${CONTAINER_ID}
    else
        echo "Skipping stop for CrashPlan container (ID ${CONTAINER_ID}) with \"${CONTAINER_STATUS}\" status."
    fi
    exit 0
    ;;

status)
    if [ -z ${CONTAINER_ID} ]; then
        echo "No CrashPlan container found."
    else
        ${PS_CMD}
        echo "Authentication Info for CrashPlan service instance"
        awk -F ',' '{ print "\n\tPort: " $1 "\n\tAuth Token: " $2 "\n\tHost: " $3 }' ${CRASHPLAN_DIR}/id/.ui_info
    fi
    exit 0
    ;;
*)
    /bin/echo "Usage: $0 { start | stop | status }"
    exit 1
    ;;

esac
