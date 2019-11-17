#!/bin/bash
#------------------------------------------
#(Copyrightⓒ 2019 Microstrong. All rights Reserved| Confidential)
#
#
#
#------------------------------------------

SCANNING_TIME=$(date +%Y%m%d%H%M)
SCANNING_DATE=$(date +%Y%m%d)
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

RESULT_FILE="./syscan_$SCANNING_DATE.res"
echo "Initialization" > $RESULT_FILE

#####################################
######### Check Infomation ##########
#####################################
echo "<checkinfo>"  >> $RESULT_FILE
echo "<os>$OS_NAME</os>" >> $RESULT_FILE
echo "<version>$OS_VERSION</version>" >> $RESULT_FILE
echo "<hostname>$HOSTNAME</hostname>" >> $RESULT_FILE
echo "<checkdate>$SCANNING_TIME</checkdate>" >> $RESULT_FILE
echo "</checkinfo>"  >> $RESULT_FILE


#################################
#### Check Result Write Func ####
function write_chkresult_xml() {
    local testid=$1
    local testcmd=$2
    local testresult=$2

    echo "  <check>"  >> $RESULT_FILE
    echo "    <id>$testid</id>"  >> $RESULT_FILE
    echo "    <cmd>"  >> $RESULT_FILE
    echo "$testcmd"  >> $RESULT_FILE
    echo "    </cmd>"  >> $RESULT_FILE
    echo "    <result>"  >> $RESULT_FILE
    echo "$testresult"  >> $RESULT_FILE
    echo "    </result>"  >> $RESULT_FILE
    echo "  </check>"  >> $RESULT_FILE
}



echo "<checklist>"  >> $RESULT_FILE
echo "</checklist>"  >> $RESULT_FILE

case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18) 
                #sshd config 
		echo "AAAA"
                grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$' >> $RESULT_FILE >/dev/null 2>&-
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
	echo "[COMMENT]There should be a line that says \"CONSOLE /dev/console \" ." >> $RESULT_FLIE
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


echo "</checklist>"  >> $RESULT_FILE


