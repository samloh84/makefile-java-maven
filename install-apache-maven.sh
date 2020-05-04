#!/bin/bash

set -euxo pipefail

if [ ${EUID} != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

MAVEN_VERSION=3.6.3
MAVEN_TEMP_DIR="/tmp/maven-${MAVEN_VERSION}"
MAVEN_INSTALL_DIR="/opt/maven/${MAVEN_VERSION}"
MAVEN_ARCHIVE_URL="https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_ARCHIVE_FILE="apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_ARCHIVE_PATH="${MAVEN_TEMP_DIR}/${MAVEN_ARCHIVE_FILE}"

mkdir -p "${MAVEN_TEMP_DIR}" "${MAVEN_INSTALL_DIR}"
curl -L -o "${MAVEN_ARCHIVE_PATH}" "${MAVEN_ARCHIVE_URL}"
tar -C "${MAVEN_INSTALL_DIR}" --strip-components=1 -xz -f "${MAVEN_ARCHIVE_PATH}"
rm -rf "${MAVEN_TEMP_DIR}"
update-alternatives --install "/usr/bin/mvn" "mvn" "${MAVEN_INSTALL_DIR}/bin/mvn" 1
update-alternatives --set mvn "${MAVEN_INSTALL_DIR}/bin/mvn"
