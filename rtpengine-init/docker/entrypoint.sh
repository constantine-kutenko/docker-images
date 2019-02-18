#!/bin/bash

if [[ $1 = 'rtpengine' ]]
then
    DT_START=$(date +%s)

    echo "Verifying the kernel module is loaded"
    
    if lsmod | grep xt_RTPENGINE >/dev/null
    then
        echo "The kernel module xt_RTPENGINE has already been loaded"

        # Make sure the permissions for /proc/rtpengine/ are right       
        chown -R root:${RTPENGINE_GROUP} /proc/rtpengine/

        exit 0
    else
        echo -e "Installing kernel headers"

        # Get a version of the current kernel
        KERNEL_VERSION_CURRENT=$(uname -r)

        # Get a header version in appropriate format
        headerVersion=($(yum info kernel-headers --disablerepo=example --skip-broken | grep -E 'Release|Arch|Version'|awk '{ print $3 }'))
        KERNEL_HEADERS_VERSION=$(echo "${headerVersion[1]}-${headerVersion[2]}.${headerVersion[0]}")

        # Compare major versions of the kerner and headers
        if [[ "$(echo ${KERNEL_VERSION_CURRENT}|sed -e 's/-.*//g')" != "$(echo ${KERNEL_HEADERS_VERSION}|sed -e 's/-.*//g')" ]]
        then
            echo -e "Major versions of the current kernel and kernel headers are not equal.\nExit!"
            exit 0
        fi

        if [[ "${KERNEL_VERSION_CURRENT}" == "${KERNEL_HEADERS_VERSION}" ]]
        then
            # Install kernel headers for a current kernel
            yum install --disablerepo=example --skip-broken --assumeyes --quiet kernel-devel-$(uname -r) kernel-headers-$(uname -r)

            # Create a symlink to a directory with current kernel version
            if [ ! -d "/lib/modules/${KERNEL_VERSION_CURRENT}/build" ]
            then
                mkdir -p /lib/modules/${KERNEL_VERSION_CURRENT}/build
                ln -s /usr/src/kernels/${KERNEL_VERSION_CURRENT}/* /lib/modules/${KERNEL_VERSION_CURRENT}/build
            fi
        else
            # Install suggested kernel headers from repository
            yum install --disablerepo=example --skip-broken --assumeyes --quiet kernel-devel kernel-headers

            # Create a symlink to a directory with current kernel version
            mkdir -p /lib/modules/${KERNEL_VERSION_CURRENT}/build
            ln -s /usr/src/kernels/${KERNEL_HEADERS_VERSION}/* /lib/modules/${KERNEL_VERSION_CURRENT}/build
        fi

        echo "Compiling the kernel module xt_RTPENGINE"

        cd /usr/src/ngcp-rtpengine-${RTPENGINE_VERSION}-0.el7.centos
        make
        mkdir -p /lib/modules/$(uname -r)/extra
        mv xt_RTPENGINE.ko /lib/modules/$(uname -r)/extra/
        touch /lib/modules/$(uname -r)/modules.order
        touch /lib/modules/$(uname -r)/modules.builtin
        depmod -a
    
        echo "Loading the kernel module xt_RTPENGINE..."
        modprobe -v -f --force-vermagic xt_RTPENGINE

        if lsmod | grep xt_RTPENGINE >/dev/null
        then
            echo "The kernel module xt_RTPENGINE has successfully been loaded"
            lsmod|grep xt_RTPENGINE
        else
            echo "The kernel module xt_RTPENGINE has not been loaded due to an error"
            exit 1
        fi
    
        DT_END=$(date +%s)
        DT_TOTAL=$(expr ${DT_END} - ${DT_START})
        printf -v TS '%d hours% 02d minutes% 02d seconds' `expr ${DT_TOTAL} / 3600` `expr ${DT_TOTAL} / 60 % 60` `expr ${DT_TOTAL} % 60`
        echo "The process took ${TS}."
    fi
  else exec $@
fi
