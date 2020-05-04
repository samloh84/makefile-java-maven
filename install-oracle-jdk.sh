#!/bin/bash

set -euxo pipefail

if [ ${EUID} != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36"
ORACLE_JDK_ARCHIVE_URL=https://download.oracle.com/otn-pub/java/jdk/14.0.1+7/664493ef4a6946b186ff29eb326336a2/jdk-14.0.1_linux-x64_bin.tar.gz
ORACLE_JDK_VERSION=14.0.1
ORACLE_JDK_TEMP_DIR="/tmp/oracle-jdk-${ORACLE_JDK_VERSION}"
ORACLE_JDK_INSTALL_DIR="/opt/oracle-jdk/${ORACLE_JDK_VERSION}"
ORACLE_JDK_ARCHIVE_FILE="jdk-${ORACLE_JDK_VERSION}_linux-x64_bin.tar.gz"
ORACLE_JDK_ARCHIVE_PATH="${ORACLE_JDK_TEMP_DIR}/${ORACLE_JDK_ARCHIVE_FILE}"



mkdir -p "${ORACLE_JDK_TEMP_DIR}" "${ORACLE_JDK_INSTALL_DIR}"
#curl --user-agent "${USER_AGENT}" --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie;" -o "${ORACLE_JDK_ARCHIVE_PATH}" "${ORACLE_JDK_ARCHIVE_URL}"
wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -O "${ORACLE_JDK_ARCHIVE_PATH}" "${ORACLE_JDK_ARCHIVE_URL}"
tar -C "${ORACLE_JDK_INSTALL_DIR}" --strip-components=1 -xz -f "${ORACLE_JDK_ARCHIVE_PATH}"
rm -rf "${ORACLE_JDK_TEMP_DIR}"
update-alternatives --install "/usr/bin/java" "java" "${ORACLE_JDK_INSTALL_DIR}/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "${ORACLE_JDK_INSTALL_DIR}/bin/javac" 1
update-alternatives --set java "${ORACLE_JDK_INSTALL_DIR}/bin/java"
update-alternatives --set javac "${ORACLE_JDK_INSTALL_DIR}/bin/javac"
cat <<-EOF | tee /etc/profile.d/java_home.sh
export JAVA_HOME="${ORACLE_JDK_INSTALL_DIR}"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
EOF