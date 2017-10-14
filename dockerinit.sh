#!/bin/bash

SHOKO_USER=${SHOKO_USER:-shoko}
SHOKO_USERID=${SHOKO_USERID:-99}
SHOKO_GROUP=${SHOKO_GROUP:-users}
SHOKO_GROUPID=${SHOKO_GROUPID:-100}

getent group ${SHOKO_GROUP} 2>&1 > /dev/null || groupadd -g ${SHOKO_GROUPID} ${SHOKO_GROUP}
getent passwd ${SHOKO_USER} 2>&1 > /dev/null && usermod -d /shoko -s /bin/bash ${SHOKO_USER}
getent passwd ${SHOKO_USER} 2>&1 > /dev/null || useradd -d /shoko -g ${SHOKO_GROUP} -G users -u ${SHOKO_USERID} -s /bin/bash ${SHOKO_USER}

#correct some permissions
chown ${SHOKO_USER}:${SHOKO_GROUP} -R /shoko /shoko/.shoko 

su -l ${SHOKO_USER} -c "cd /opt/shoko; mono Shoko.CLI.exe"

