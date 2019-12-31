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
#OS_NAME="$(uname -s)"
OS_NAME=$1
OS_VERSION=$2


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

###################################
echo "<checklist>"  >> $RESULT_FILE
###################################

#################################
#### Check Result Write Func ####
function write_chkresult_xml() {
    local testid=$1
    local testcmd=$2
    local testresult=$3

    echo "  <check>"  >> $RESULT_FILE
    echo "    <id>$testid</id>"  >> $RESULT_FILE
    echo "    <cmd>"  >> $RESULT_FILE
    echo -e "$testcmd"  >> $RESULT_FILE
    echo "    </cmd>"  >> $RESULT_FILE
    echo "    <result>"  >> $RESULT_FILE
    echo -e "$testresult"  >> $RESULT_FILE
    echo "    </result>"  >> $RESULT_FILE
    echo "  </check>"  >> $RESULT_FILE
}


#########################
###### U-001 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                systemctl status sshd >> /dev/null
                if [ $? -eq 0 ]; then
                    #sshd config 
                    CMD="grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$' " 
		    RESULT=$(grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$') 
                else
                    CMD="systemctl status sshd" 
		    RESULT="N/A" 
                fi
            ;; 
            CentOS7)
                systemctl status sshd >> /dev/null
                if [ $? -eq 0 ]; then
                    #sshd config 
                    CMD="grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$' " 
		    RESULT=$(grep  PermitRootLogin /etc/ssh/sshd_config | egrep -v '^[[:space:]]*(#.*)?$') 
                else
                    CMD="systemctl status sshd" 
		    RESULT="N/A"
                fi
            ;; 
            CentOS6|CentOS5)
                #telnet config
                CMD="grep "auth required" /etc/pam.d/login | egrep -v '^[[:space:]]*(#.*)?$'" 
		RESULT=$(grep "auth required" /etc/pam.d/login | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            *)
                echo "Not Supported...." >> $RESULT_FILE
            ;;
	esac
    ;;
    SunOS)
        CMD="cat /etc/default/login | grep CONSOLE | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/login | grep CONSOLE | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    AIX)
        CMD="cat /etc/security/user | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/security/user | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    HP-UX)
        CMD="cat /etc/securetty | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/securetty | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-01 "$CMD" "$RESULT"
###### U-001 End ######
#########################

#########################
###### U-002 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD1="cat /etc/login.defs  | egrep -v '^[[:space:]]*(#.*)?$'" 
                CMD2="grep password /etc/pam.d/common-password | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT1=$(cat /etc/login.defs  | egrep -v '^[[:space:]]*(#.*)?$') 
                RESULT2=$(grep password /etc/pam.d/common-password | egrep -v '^[[:space:]]*(#.*)?$') 
		CMD="${CMD1}\n-----------------\n${CMD2}"
                RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 
            CentOS7)
                CMD="cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT=$(cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            CentOS6|CentOS5)
                CMD1="cat /etc/pam.d/system-auth | egrep -v '^[[:space:]]*(#.*)?$'" 
                CMD2="cat /etc/login.defs | egrep -v '^[[:space:]]*(#.*)?$'" 
		RESULT1=$(cat /etc/pam.d/system-auth | egrep -v '^[[:space:]]*(#.*)?$') 
		RESULT2=$(cat /etc/login.defs | egrep -v '^[[:space:]]*(#.*)?$') 
		CMD="${CMD1}\n-----------------\n${CMD2}"
		RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 


	esac
    ;;
    SunOS)
        CMD="cat /etc/default/passwd | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/passwd | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    AIX)
        CMD="cat /etc/default/user | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/user | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    HP-UX)
        CMD="cat /etc/default/security | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/security | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-02 "$CMD" "$RESULT"
###### U-002 End ######
#########################


:<<'END'

#########################
###### U-003 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="" 
                RESULT=$(cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            CentOS7)
                CMD="cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT=$(cat /etc/security/pwquality.conf | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            CentOS6)
            ;; 


	esac
    ;;
    SunOS)
        CMD="cat /etc/default/login | grep RETRIES | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/login | grep RETRIES | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    AIX)
        CMD="cat /etc/security/user | grep loginretries | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/login | grep RETRIES | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    HP-UX)
        CMD="cat /tcb/files/auth/system/default | grep u_maxtries | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /tcb/files/auth/system/default | grep u_maxtries | egrep -v '^[[:space:]]*(#.*)?$') 
	CMD="cat /etc/default/security | grep AUTH_MAXTRIES | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/default/security | grep AUTH_MAXTRIES | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-003 "$CMD" "$RESULT"
###### U-003 End ######
#########################


#########################
###### U-004 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT=$(cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            CentOS7)
                CMD="cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT=$(cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 
            CentOS6)
                CMD="cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$'" 
                RESULT=$(cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$') 
            ;; 


	esac
    ;;
    SunOS)
        CMD="cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    AIX)
        #check is there /etc/security/passwd file?
    ;;
    HP-UX)
        CMD="cat /etc/security/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$'" 
        RESULT=$(cat /etc/security/passwd | grep root | egrep -v '^[[:space:]]*(#.*)?$') 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-004 "$CMD" "$RESULT"
###### U-004 End ######
#########################


#########################
###### U-005 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="echo $PATH" 
                RESULT=$(echo $PATH) 
            ;; 
            CentOS7)
                CMD="echo $PATH" 
                RESULT=$(echo $PATH) 
            ;; 
            CentOS6)
                CMD="echo $PATH" 
                RESULT=$(echo $PATH) 
            ;; 


	esac
    ;;
    SunOS)
        CMD="echo $PATH" 
        RESULT=$(echo $PATH) 
    ;;
    AIX)
        CMD="echo $PATH" 
        RESULT=$(echo $PATH) 
    ;;
    HP-UX)
        CMD="echo $PATH" 
        RESULT=$(echo $PATH) 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-005 "$CMD" "$RESULT"
###### U-005 End ######
#########################



#########################
###### U-006 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD1="find / -nouser -print" 
                CMD2="find / -nogroup -print" 
                RESULT1=$(find / -nouser -print) 
                RESULT2=$(find / -nogroup -print) 
		CMD="${CMD1}\n-----------------\n${CMD2}"
                RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 
            CentOS7)
                CMD1="find / -nouser -print" 
                CMD2="find / -nogroup -print" 
                RESULT1=$(find / -nouser -print) 
                RESULT2=$(find / -nogroup -print) 
		CMD="${CMD1}\n-----------------\n${CMD2}"
                RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 
            CentOS6)
                CMD1="find / -nouser -print" 
                CMD2="find / -nogroup -print" 
                RESULT1=$(find / -nouser -print) 
                RESULT2=$(find / -nogroup -print) 
		CMD="${CMD1}\n-----------------\n${CMD2}"
                RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 


	esac
    ;;
    SunOS)
        CMD="find / -nouser -o -nogroup -xdev -ls 2 > /dev/null"
        RESULT="find / -nouser -o -nogroup -xdev -ls 2 > /dev/null"
    ;;
    AIX)
        CMD="find / -nouser -o -nogroup -xdev -ls 2 > /dev/null"
        RESULT="find / -nouser -o -nogroup -xdev -ls 2 > /dev/null"
    ;;
    HP-UX)
        CMD="find / \ -nouser -o -nogroup \ -xdev -exec ls -al {} \; 2> /dev/null"
        RESULT="find / \ -nouser -o -nogroup \ -xdev -exec ls -al {} \; 2> /dev/null"
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-006 "$CMD" "$RESULT"
###### U-006 End ######




#########################
###### U-007 Start ######
case ${OS_NAME} in
    Linux)
        CMD="ls -l /etc/passwd"
        RESULT="ls -l /etc/passwd"
    ;;
    SunOS)
        CMD="ls -l /etc/passwd"
        RESULT="ls -l /etc/passwd"
    ;;
    AIX)
        CMD="ls -l /etc/passwd"
        RESULT="ls -l /etc/passwd"
    ;;
    HP-UX)
        CMD="ls -l /etc/passwd"
        RESULT="ls -l /etc/passwd"
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-007 "$CMD" "$RESULT"
###### U-007 End ######



#########################
###### U-008 Start ######
case ${OS_NAME} in
    Linux)
        CMD="ls -l /etc/shadow"
        RESULT="ls -l /etc/shadow"
    ;;
    SunOS)
        CMD="ls -l /etc/shadow"
        RESULT="ls -l /etc/shadow"
    ;;
    AIX)
        CMD="ls -ld /etc/security/passwd"
        RESULT="ls -l /etc/security/passwd"
    ;;
    HP-UX)
        CMD="ls -ld /tcb/files/auth"
        RESULT="ls -l /tcb/files/suth"
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-008 "$CMD" "$RESULT"
###### U-008 End ######


#########################
###### U-009 Start ######
case ${OS_NAME} in
    Linux)
        CMD="ls -l /etc/hosts"
        RESULT="ls -l /etc/hosts"
    ;;
    SunOS)
        CMD="ls -l /etc/hosts"
        RESULT="ls -l /etc/hosts"
    ;;
    AIX)
        CMD="ls -l /etc/hosts"
        RESULT="ls -l /etc/hosts"
    ;;
    HP-UX)
        CMD="ls -l /etc/hosts"
        RESULT="ls -l /etc/hosts"
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-009 "$CMD" "$RESULT"
###### U-009 End ######


#########################
###### U-010 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
                CMD1="ls -l /etc/xinetd.conf" 
                CMD2="ls -al /etc/xinetd.d/*" 
                RESULT1=$(ls -l /etc/xinetd.conf) 
                RESULT2=$(ls -al /etc/xinetd.d/*) 
		CMD="${CMD1}\n-----------------\n${CMD2}"
                RESULT="${RESULT1}\n-----------------\n${RESULT2}"
            ;; 


	esac
    ;;
    SunOS)
        CMD="ls -l /etc/inetd.conf" 
        RESULT="ls -l /etc/ineted.conf" 
    ;;
    AIX)
        CMD="ls -l /etc/inetd.conf" 
        RESULT="ls -l /etc/ineted.conf" 
    ;;
    HP-UX)
        CMD="ls -l /etc/inetd.conf" 
        RESULT="ls -l /etc/ineted.conf" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-010 "$CMD" "$RESULT"
###### U-010 End ######



#########################
###### U-011 Start ######
case ${OS_NAME} in
    Linux)
        CMD="ls -l /etc/syslog.conf" 
        RESULT="ls -l /etc/syslog.conf" 
    ;;
    SunOS)
        CMD="ls -l /etc/syslog.conf" 
        RESULT="ls -l /etc/syslog.conf" 
    ;;
    AIX)
        CMD="ls -l /etc/syslog.conf" 
        RESULT="ls -l /etc/syslog.conf" 
    ;;
    HP-UX)
        CMD="ls -l /etc/syslog.conf" 
        RESULT="ls -l /etc/syslog.conf" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-011 "$CMD" "$RESULT"
###### U-011 End ######



#########################
###### U-012 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
            ;; 
            CentOS7)
            ;; 
            CentOS6)
                CMD="ls -l /etc/services.conf" 
                RESULT="ls -l /etc/services.conf" 
            ;; 


	esac
    ;;
    SunOS)
        CMD="ls -l /etc/services.conf" 
        RESULT="ls -l /etc/services.conf" 
    ;;
    AIX)
        CMD="ls -l /etc/services.conf" 
        RESULT="ls -l /etc/services.conf" 
    ;;
    HP-UX)
        CMD="ls -l /etc/services.conf" 
        RESULT="ls -l /etc/services.conf" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-012 "$CMD" "$RESULT"
###### U-012 End ######


#########################
###### U-013 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="" 
                RESULT="" 
            ;; 
            CentOS7)
                CMD="" 
                RESULT="" 
            ;; 
            CentOS6)
                CMD="" 
                RESULT="" 
            ;; 


	esac
    ;;
    SunOS)
        CMD="" 
        RESULT="" 
    ;;
    AIX)
        CMD="" 
        RESULT="" 
    ;;
    HP-UX)
        CMD="" 
        RESULT="" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-013 "$CMD" "$RESULT"
###### U-013 End ######



#########################
###### U-014 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="" 
                RESULT="" 
            ;; 
            CentOS7)
                CMD="" 
                RESULT="" 
            ;; 
            CentOS6)
                CMD="" 
                RESULT="" 
            ;; 
	esac
    ;;
    SunOS)
        CMD="" 
        RESULT="" 
    ;;
    AIX)
        CMD="" 
        RESULT="" 
    ;;
    HP-UX)
        CMD="" 
        RESULT="" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-014 "$CMD" "$RESULT"
###### U-014 End ######



#########################
###### U-015 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="find / -type f -perm -2 -exec ls -l {} \;" 
                RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
            ;; 
            CentOS7)
                CMD="find / -type f -perm -2 -exec ls -l {} \;" 
                RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
            ;; 
            CentOS6)
                CMD="find / -type f -perm -2 -exec ls -l {} \;" 
                RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
            ;; 


	esac
    ;;
    SunOS)
        CMD="find / -type f -perm -2 -exec ls -l {} \;" 
        RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
    ;;
    AIX)
        CMD="find / -type f -perm -2 -exec ls -l {} \;" 
        RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
    ;;
    HP-UX)
        CMD="find / -type f -perm -2 -exec ls -l {} \;" 
        RESULT="find / -type f -perm -2 -exec ls -l {} \;" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-015 "$CMD" "$RESULT"
###### U-015 End ######


#########################
###### U-016 Start ######
case ${OS_NAME} in
    Linux)
        case ${OS_VERSION} in
            Ubuntu16|Ubuntu18)
                CMD="find /dev -type f -exec ls -l {} \;" 
                RESULT="find /dev -type f -exec ls -l {} \;" 
            ;; 
            CentOS7)
                CMD="find /dev -type f -exec ls -l {} \;" 
                RESULT="find /dev -type f -exec ls -l {} \;" 
            ;; 
            CentOS6)
                CMD="find /dev -type f -exec ls -l {} \;" 
                RESULT="find /dev -type f -exec ls -l {} \;" 
            ;; 


	esac
    ;;
    SunOS)
        CMD="find /dev -type f -exec ls -l {} \;" 
        RESULT="find /dev -type f -exec ls -l {} \;" 
    ;;
    AIX)
        CMD="find /dev -type f -exec ls -l {} \;" 
        RESULT="find /dev -type f -exec ls -l {} \;" 
    ;;
    HP-UX)
        CMD="find /dev -type f -exec ls -l {} \;" 
        RESULT="find /dev -type f -exec ls -l {} \;" 
    ;;
    *)
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-016 "$CMD" "$RESULT"
###### U-016 End ######




#########################
###### U-017 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-017 "$CMD" "$RESULT"
###### U-017 End ######


#########################
###### U-018 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-018 "$CMD" "$RESULT"
###### U-018 End ######


#########################
###### U-019 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-019 "$CMD" "$RESULT"
###### U-019 End ######



#########################
###### U-020 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-020 "$CMD" "$RESULT"
###### U-020 End ######



#########################
###### U-021 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-021 "$CMD" "$RESULT"
###### U-021 End ######


#########################
###### U-022 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-022 "$CMD" "$RESULT"
###### U-022 End ######



#########################
###### U-023 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-023 "$CMD" "$RESULT"
###### U-023 End ######


#########################
###### U-024 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-024 "$CMD" "$RESULT"
###### U-024 End ######


#########################
###### U-025 Start ######
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
        CMD="Not Supported OS" 
        RESULT="Not Supported OS" 
    ;;
esac
#echo $CMD
#echo "$RESULT"
write_chkresult_xml U-025 "$CMD" "$RESULT"
###### U-025 End ######

END

















echo "</checklist>"  >> $RESULT_FILE


