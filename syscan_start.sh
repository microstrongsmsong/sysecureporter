#!/bin/bash
#------------------------------------------
#(Copyrightⓒ 2019 Microstrong. All rights Reserved| Confidential)
#
#
#
#------------------------------------------

OS_NAME="$(uname -s)"

################
# Get OS Version
################
case ${OS_NAME} in
    AIX)
        OS_VER=`/usr/bin/oslevel`
	./syscan_unix.sh $OS_NAME $OS_VERSION
    ;;
    Linux)
        cat /etc/*-release | grep -i Ubuntu | grep "18.04" >> /dev/null 
        if [ $? -eq 0 ]; then
            OS_VERSION="Ubuntu18"
            ./syscan_linux.sh $OS_NAME $OS_VERSION
            #break
        fi	
        cat /etc/*-release | grep -i Ubuntu | grep "16.04" >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="Ubuntu16"
            ./syscan_linux.sh $OS_NAME $OS_VERSION
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "7." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS7"
            ./syscan_linux.sh $OS_NAME $OS_VERSION
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "6." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS6"
            ./syscan_linux.sh $OS_NAME $OS_VERSION
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "5." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS5"
            ./syscan_linux.sh $OS_NAME $OS_VERSION
            #break
        fi	
    ;;
    SunOS)
        OS_VER=`uname -r`
        ./syscan_unix.sh $OS_NAME $OS_VERSION
    ;;
    HP-UX)
       OS_VER=`uname -r`
       ./syscan_unix.sh $OS_NAME $OS_VERSION
    ;;
    *)
    ;;
esac

#############################
## Start syscan Linux/Unix ##




