# This URL does not exist until April 7, 2016:
CHPL_RELEASE_URL_DEFAULT=https://github.com/chapel-lang/chapel/releases/download/1.13.0/chapel-1.13.0.tar.gz

configHelp() {
    # Print help
    echo;
    echo "This script builds the rpm for a given Debian release"
    echo "It expects \$CHPL_RELEASE to be defined and \$DEBIAN_RELEASE to be"
    echo "defined or provided as command line argument"
    echo;
    echo "   ./<script> <release>"
    echo;
}


configSetup() {
    # Setup all the common variables and confirm inputs are defined

    echo ""

    # This variable is always read as an environment variable
    if [ -z ${CHPL_RELEASE_URL} ]; then
        echo "\$CHPL_RELEASE_URL undefined; Setting \$CHPL_RELEASE_URL to:"
        CHPL_RELEASE_URL=${CHPL_RELEASE_URL_DEFAULT}
        echo "${CHPL_RELEASE_URL}"
        echo ""
        export CHPL_RELEASE_URL
    fi

    # This variable can be read as env var or passed as argument
    if [ -z ${DEBIAN_RELEASE} ]; then
        echo "\$DEBIAN_RELEASE undefined; Setting \$DEBIAN_RELEASE to:"
        DEBIAN_RELEASE=`lsb_release -a 2> /dev/null | grep Codename | awk '{print $2}'`
        echo "${DEBIAN_RELEASE}"
        echo ""
        export DEBIAN_RELEASE
    fi

    # Package specific
    PKG=chapel
    BINARY=chpl
    VERSION=1.13

    # Machine specific (generated dynamically)
    DEBIAN=1
    ARCH=amd64

    TARBALL=${PKG}-${VERSION}.tar.gz
    ORIG_TARBALL=${PKG}_${VERSION}.orig.tar.gz

    # Directories
    SRC_TAR=$(basename ${CHPL_RELEASE_URL})
    SRC=$(basename ${CHPL_RELEASE_URL} | cut -f 1,2,3 -d '.')
    DEB_SRC=debian

    # Package Files
    BASENAME=${PKG}_${VERSION}-${DEBIAN}

    CHANGES=${BASENAME}_${ARCH}.changes
    DEB=${BASENAME}_${ARCH}.deb
    DEB_TAR_GZ=${BASENAME}.debian.tar.gz
    DEB_TAR_XZ=${BASENAME}.debian.tar.xz
    DSC=${BASENAME}.dsc
}

configClean() {
    # Clean up files generated by scripts

    # Create gzipped tarball from source
    safeClean ${TARBALL}
    safeClean ${PKG}
    safeClean ${ORIG_TARBALL}
    safeClean ${PKG}

    ### debian files ###
    safeClean ${PKG}/debian

    # Clean package files
    safeClean ${CHANGES}
    safeClean ${DEB}
    safeClean ${DEB_TAR_GZ}
    safeClean ${DEB_TAR_XZ}
    safeClean ${DSC}
    safeClean build-area
}

safeClean() {
    # Safely cleanup directories and files
    if [ -z ${1} ]; then
        echo "Critical Error: internal variable undefined"
        exit 1
    else
        rm -rf ${1}
    fi
}
