#!/bin/sh

DEBIAN_SUITE=$1
SUITE=$2
NONFREE=$3

COMPONENTS="main"
if [ "${NONFREE}" = "true" ]; then
    COMPONENTS="${COMPONENTS} non-free-firmware"
fi

# Add debian-security for bullseye & bookworm; note that only the main component is supported
if [ "$DEBIAN_SUITE" = "bullseye" ] || [ "$DEBIAN_SUITE" = "bookworm" ]; then
    echo "deb http://security.debian.org/ ${DEBIAN_SUITE}-security main" >> /etc/apt/sources.list
fi

# Set the proper suite and components in our sources file
sed -i -e "s/Suites: .*/Suites: ${SUITE}/" \
       -e "s/Components: .*/Components: ${COMPONENTS}/" \
          /etc/apt/sources.list.d/mobian.sources

# Setup repo priorities so mobian comes first
cat > /etc/apt/preferences.d/00-mobian-priority << EOF
Package: *
Pin: release o=Mobian
Pin-Priority: 700
EOF
