#!/bin/bash
#------------------------------------------
#(Copyrightⓒ 2019 Microstrong. All rights Reserved| Confidential)
#
#
#
#------------------------------------------

SCANNING_TIME=$(date +%Y%m%d%H%M%s)
HOSTNAME="$(hostname)"
OS_NAME="$(uname -s)"
################
# Get OS Version
################
case ${OS_NAME} in
    AIX)
        OS_VER=`/usr/bin/oslevel`
    ;;
    Linux)
        cat /etc/*-release | grep -i Ubuntu | grep "18.04" >> /dev/null 
        if [ $? -eq 0 ]; then
            OS_VERSION="Ubuntu18"
            #break
        fi	
        cat /etc/*-release | grep -i Ubuntu | grep "16.04" >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="Ubuntu16"
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "7." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS7"
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "6." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS6"
            #break
        fi	
        cat /etc/*-release | grep -i Cent | grep "5." >> /dev/null
        if [ $? -eq 0 ]; then
            OS_VERSION="CentOS5"
            #break
        fi	
    ;;
    SunOS)
        OS_VER=`uname -r`
    ;;
    HP-UX)
       OS_VER=`uname -r`
    ;;
    *)
    ;;
esac

RESULT_FILE="./syscan.res"

echo "#################################" > "$RESULT_FILE"
echo "######## Start Syscan #############" >> $RESULT_FILE
echo "#################################" >> $RESULT_FILE

echo "Host Name  : $HOSTNAME" >> $RESULT_FILE
echo "Scan Time  : $SCANNING_TIME=" >> $RESULT_FILE
echo "Os Name    : $OS_NAME" >> $RESULT_FILE
echo "OS Version : $OS_VERSION" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE



echo "###################" >> $RESULT_FILE
echo "#U-01" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18) 
                #sshd config 
                grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
                if [ $? -ne 0 ]; then
                    echo "Scan Error in U-01" >> $RESULT_FILE
                fi
 
            ;; 
            CentOS7)
                #sshd config 
                grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
            ;; 
            CentOS6)
                #telnet config
                grep "auth required" /etc/pam.d/login | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
                echo "-----------" >> $RESULT_FILE
                cat /etc/securetty >> $RESULT_FILE
            ;; 
            *)
                echo "Not Supported...." >> $RESULT_FILE
            ;;
	esac
    ;;
    SunOS)
	cat /etc/default/login | grep CONSOLE | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    AIX)
	cat /etc/security/user | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    HP-UX)
	cat /etc/securetty | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    *)
        echo "Not Supported...." >> $RESULT_FILE
    ;;
esac
echo "#####U-01 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE


echo "###################" >> $RESULT_FILE
echo "#U-02" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                cat /etc/login.defs  | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
                echo "--------------" >> $RESULT_FILE
                grep password /etc/pam.d/common-password | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
            ;; 
            CentOS7)
                cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
            ;; 
            CentOS6|CentOS5)
                cat /etc/pam.d/system-auth | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
                echo "--------------" >> $RESULT_FILE
                cat /etc/login.defs | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
            ;; 


	esac
    ;;
    SunOS)
        cat /etc/default/passwd | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    AIX)
        cat /etc/default/user | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    HP-UX)
        cat /etc/default/security | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
    *)
        echo "Not Supported...." | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE
    ;;
esac
echo "#####U-02 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE



echo "###################" >> $RESULT_FILE
echo "#U-03" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
            ;; 


	esac
    ;;
    SunOS)
    ;;
    AIX)
    ;;
    HP-UX)
    ;;
    *)
        echo "Not Supported...." >> $RESULT_FILE
    ;;
esac
echo "#####U-03 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE


echo "###################" >> $RESULT_FILE
echo "#U-04" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
            ;; 


	esac
    ;;
    SunOS)
    ;;
    AIX)
    ;;
    HP-UX)
    ;;
    *)
        echo "Not Supported...." >> $RESULT_FILE
    ;;
esac
echo "#####U-04 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE



echo "###################" >> $RESULT_FILE
echo "#U-05" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
            ;; 


	esac
    ;;
    SunOS)
    ;;
    AIX)
    ;;
    HP-UX)
    ;;
    *)
        echo "Not Supported...." >> $RESULT_FILE
    ;;
esac
echo "#####U-05 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE



echo "###################" >> $RESULT_FILE
echo "#U-06" >>               $RESULT_FILE
echo "###################" >> $RESULT_FILE
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
            ;; 


	esac
    ;;
    SunOS)
    ;;
    AIX)
    ;;
    HP-UX)
    ;;
    *)
        echo "Not Supported...." >> $RESULT_FILE
    ;;
esac
echo "#####U-06 End######" >> $RESULT_FILE
echo "" >> $RESULT_FILE
echo "" >> $RESULT_FILE




