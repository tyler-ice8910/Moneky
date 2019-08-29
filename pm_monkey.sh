#!/bin/bash
# -*- encoding: utf8 -*-
###############################################################
## Name:        Monkey Script
## Version:     1.0
## Date:        2019.07.05
## This is Point Mobile Monkey Test Tool.
###############################################################
run_seed()
{
    DEVICE_NUMBER="`adb devices | awk 'NR>1 {print $1}'`"
    DATE=`date "+%Y%m%d"`
    TIME=`date "+%H%M%S"`
    DIR=seed/${DATE}
    SEED_DIR=${DIR}/${TIME}
    mkdir -p ${SEED_DIR}
    TEST_ACTION=1010
    THROTTLE=10
    DEBUG=false
    FILE=${DIR}.txt
    PACKAGE=device.apps.scan2set
    CATEGORY=android.intent.category.PM_TOOL
    echo "input the seed number"
    read SEED
    echo "Collecting traces......."                                                                                                                                                  
echo "---------------------------------------------"
echo "          Seed:" ${SEED}
echo "---------------------------------------------"
echo "---------------------------------------------"
echo "          Logs:" ${SEED_DIR}
echo "---------------------------------------------"
echo "          Monkey Running......    "
echo "---------------------------------------------"

adb -s ${DEVICE_NUMBER} shell monkey -p ${PACKAGE} -c ${CATEGORY} -s ${SEED} --throttle ${THROTTLE} -vvv -v ${TEST_ACTION} -pct-touch 50% --pct-motion 20% --pct-anyevent 30% --ignore-security-exceptions --kill-process-after-error --monitor-native-crashes > ./${SEED_DIR}/seed.txt
    adb -s ${DEVICE_NUMBER} shell cat data/anr/traces.txt.bugreport > ./${SEED_DIR}/seed_traces.txt
    echo "Collecting Dropbox......"
    adb -s ${DEVICE_NUMBER} pull /data/system/dropbox
    if [ ${DEBUG} == false ];then
        echo "Collecting bugreport..."
        adb -s ${DEVICE_NUMBER} bugreport bugreport.zip
        unzip *.zip -d ./${SEED_DIR}/
        rm -rf *.zip
    fi
    echo "Collecting fatal exceptions..."
    echo "-------------------------------------------------" >> ${FILE}
    echo "${TIME} Crashes: " >> ${FILE}
    grep -C 20 -rin -E "CRASH|ANR|NOT RESPONDING" ${SEED_DIR} >> ${FILE}
    echo " " >> ${FILE}
    exit
}

check_device()
{
    DEVICE=`adb devices | awk 'NR>1 {print $1}'`
    if [ -z ${DEVICE} ];then
       echo " "
       echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
       echo "                No Device Connected, Quit!           "
       echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
       echo " "
       exit
       return 1
    else
       return 0
    fi
    return ${DEVICE}
}

select_device()
{
    SD=`adb devices | awk 'NR>1 {print $1}'`
    echo ""
    echo "-------------------------------------------------"
    echo "          The device selected is ${SD}. " 
    echo "-------------------------------------------------"
    echo ""
}

run_monkey()
{
a="--dbg-no-events"
b="--ignore-crashes"
c="--ignore-timeouts"                                                                                                                                                                                    
d="--ignore-security-exceptions"
e="--kill-process-after-error"
f="--monitor-native-crashes"
g="--wait-dbg"
     DATE=`date "+%Y%m%d"`
     TIME=`date "+%H%M%S"`
     DIR=Logs/${DATE}
     LOG_DIR=${DIR}/${TIME}
     SEED=`date "+%s"`
     FILE=${DIR}.txt
     DEVICE_NUMBER=`adb devices | awk 'NR>1 {print $1}'`
     DEBUG=false
CMD="adb -s ${DEVICE_NUMBER} shell monkey -p ${PACKAGE} -c ${CATEGORY} -s ${SEED} --throttle ${THROTTLE} -vvv -v ${TEST_ACTION} -pct-touch 50% --pct-motion 20% --pct-anyevent 30% --ignore-security-exceptions --kill-process-after-error --monitor-native-crashes >${LOG_DIR}/pm_monkey.txt"

echo "Monkey Command: (\"${CMD}\"\)"
mkdir -p ${LOG_DIR}
echo "---------------------------------------------"
echo "          Seed:" ${SEED}
echo "---------------------------------------------"
echo "---------------------------------------------"
echo "          Logs:" ${LOG_DIR}
echo "---------------------------------------------"
echo "          Monkey Running......    "
echo "---------------------------------------------"
echo ""
        echo "Test Package Input : "
        echo ""
        read PACKAGE 
        echo "Enter package-related categories : "
        echo ""
        echo "ex)scan2set can be successfuly tested using android.intent.category.PM_TOOL / Default : android.intent.category.MONKEY"                                                                        
        echo "Default Using??"
        echo " Yes/y , No/n "
        echo ""
        read default_category
        echo ""
        case $default_category in
             Yes|YES|y|Y)
                 CATEGORY=android.intent.category.MONKEY
                 ;;  
             NO|No|N|n)
                 echo " Enter package-related categories :  "
                 read CATEGORY
                 ;;  
        esac
        echo ""
        echo "Test Action Input : "
        echo ""
        read TEST_ACTION
        echo ""
        echo "Action Throttle Input :  "
        echo ""
        echo "ex) 2000 = 2s (milisecond)  "
        echo ""
        read THROTTLE
        echo " Option % set "
        echo ""
        echo "ex)--pct-touch 50% > 50 "
        echo ""
        echo " --pct-touch "
        echo ""
        read pct_t
        echo " "
        echo " --pct-motion "
        read pct_m
        echo ""
        echo " --pct-anyevent "
        read pct_e
        echo ""
        move="--pct-touch ${pct_t}% --pct-motion ${act_m}% --pct-anyevent ${pct_e}%"

adb -s ${DEVICE_NUMBER} shell monkey -p ${PACKAGE} -c ${CATEGORY} -s ${SEED} --throttle ${THROTTLE} -vvv -v ${TEST_ACTION} ${move} ${d} ${e} ${f} >${LOG_DIR}/pm_monkey_device.txt
echo "===================================================================="
echo ""
echo "                         Monkey Finished!!"
echo ""
echo "====================================================================" 

echo "Collecting traces......."
adb -s ${DEVICE_NUMBER} shell cat data/anr/traces.txt.bugreport > ./${LOG_DIR}/traces.txt
echo "Collecting Dropbox......"
adb -s ${DEVICE_NUMBER} pull /data/system/dropbox
if [ ${DEBUG} == false ];then
echo "Collecting bugreport..."
    adb -s ${DEVICE_NUMBER} bugreport bugreport.zip
    unzip *.zip -d ./${LOG_DIR}/
    rm -rf *.zip
fi
echo "Collecting fatal exceptions..."
echo "-------------------------------------------------" >> ${FILE}
echo "${TIME} Crashes: " >> ${FILE}
grep -C 20 -rin -E "CRASH|ANR|NOT RESPONDING" ${LOG_DIR} >> ${FILE}
echo " " >> ${FILE}
exit
}

br()
{
echo "-----------------------------------------------------"
echo "           Are multiple devices connected?           "
echo "-----------------------------------------------------"
echo "             ==========================="
echo "                 Yes = y  /  No = n    "
echo "             ==========================="
read val
case $val in
    y|Y)
          adb devices
          echo ""
          option
          ;;
    n|N)
          SD=`adb devices | awk 'NR>1 {print $1}'`
           echo ""
           echo "----------------------------------------------------"
           echo "          The device selected is ${SD}. " 
           echo "----------------------------------------------------"
           run_monkey
           echo ""
           ;;
    *)
           echo "Input Retry"
           break
           ;;
esac
}

option_debugging()
{
a="--dbg-no-events"
# 액티비티의 실행은 하지만 이벤트를 발생시키지는 않는다.
b="--ignore-crashes"
# 지정을 하지 않는 경우에 Monkey는 어플리케이션의 크래쉬나 익셉션이 발생하면 정지된다. 이 옵션을 지정하면 이벤트 개수만큼 계속 이벤트를 보내게 된다
c="--ignore-timeouts"
# 지정을 하지 않은 경우에 Monkey는 타임 아웃 에러가 발생하면 정지한다. 타임 아웃 에러는 Application Not Responding 다이얼로그와 같은 것이 나올 때는 말한다.옵션을 지정하면 에러 후에도 이벤트를 계속 발생
d="--ignore-security-exceptions"
# 지정 하지 않은 경우네 Monkey는 시큐리티 익셉션(퍼미션 에러)가 발생하면 정지한다. 이 옵션을 지정하면 에러 후에도 이벤트를 계속 발생시킨다.
e="--kill-process-after-error"
# 통상 에러에 의해 Monkey가 정지될 때에는 테스트 된 어플리케이션은 fail이 나지만 프로세스는 돌고 있다. 이 옵션을 지정하면 시스템에서 프로세스로 종료 시그널(kill)을 보낸다
f="--monitor-native-crashes"
# Android의 시스템 네이티브 코드에서 일어나는 크래쉬를 리포트한다. --kill-process-after-error 옵션을 함께 사용하면 시스템은 정지한다.
g="--wait-dbg"
# 디버거가 attached 할 때가지 Monkey 실행을 정지한다.
}

option()
{
a="--dbg-no-events"
b="--ignore-crashes"
c="--ignore-timeouts"
d="--ignore-security-exceptions"
e="--kill-process-after-error"
f="--monitor-native-crashes"
g="--wait-dbg"
 DATE=`date "+%Y%m%d"`
 TIME=`date "+%H%M%S"`
 DIR=Logs/${DATE}
 LOG_DIR=${DIR}/${TIME}
 SEED=`date "+%s"`
 FILE=${DIR}.txt
 DEBUG=false
 mkdir -p ${LOG_DIR}
    echo ""
	echo "Device Serial Nunber to test :   "
	echo ""
	read Test_Device1
	if [ "$Test_Device1" ]; then
        echo ""
		echo "Test Package Input : "
		echo ""
		read pkg
		echo "Enter package-related categories : "
		echo ""
		echo "ex)scan2set can be successfuly tested using android.intent.category.PM_TOOL / Default : android.intent.category.MONKEY"
		echo "Default Using??"
        echo " Yes/y , No/n "
        read default_category
        echo ""
        case $default_category in
             Yes|YES|y|Y)
                 category=android.intent.category.MONKEY
                 ;;
             NO|No|N|n)
                 echo " Enter package-related categories :  "
                 read category
                 ;;
        esac
		echo ""
		echo "Test Action Input : "
		echo ""
		read action
		echo ""
		echo "Action Throttle Input :  "
		echo ""
        echo "ex) 2000 = 2s (milisecond)  "
        echo ""
        read throttle
        echo ""
        echo " Option % set "
        echo ""
        echo "ex)--pct-touch 50% > 50 "
        echo ""
        echo -n " --pct-touch "
        echo ""
        read pct_t
        echo " "
        echo -n " --pct-motion "
        read pct_m
        echo -n " --pct-anyevent "
        read pct_e
        echo ""
        move="--pct-touch ${pct_t}% --pct-motion ${pct_m}% --pct-anyevent ${pct_e}%"
        echo "---------------------------------------------"
        echo "             Seed:" ${SEED}
        echo "---------------------------------------------"
        echo "---------------------------------------------"
        echo "             Logs:" ${LOG_DIR}
        echo "---------------------------------------------"
        echo "             Monkey Running......    "
        echo "---------------------------------------------"
adb -s ${Test_Device1} shell monkey -p ${pkg} -c ${category} -s ${SEED} --throttle ${throttle} -vvv -v ${action} ${move} ${d} ${e} ${f} > ./${LOG_DIR}/pm_monkey_devices.txt
        echo "---------------------------------------------"                                                                                                                                                 
        echo "             Monkey Running......    "
        echo "---------------------------------------------"
		echo "===================================================================="
		echo ""
		echo "                         Monkey Finished!!"
		echo ""
		echo "====================================================================" 
		echo "Collecting traces......."
		adb -s ${Test_Device1} shell cat data/anr/traces.txt.bugreport > ./${LOG_DIR}/traces.txt
		echo "Collecting Dropbox......"
		adb -s ${Test_Device1} pull /data/system/dropbox
		if [ ${DEBUG} == false ];then
			echo "Collecting bugreport..."
			adb -s ${Test_Device1} bugreport bugreport.zip
			unzip *.zip -d ./${LOG_DIR}/
			rm -rf *.zip
		fi
		echo "Collecting fatal exceptions..."
		echo "-------------------------------------------------" >> ${FILE}
		echo "${TIME} Crashes: " >> ${FILE}
		grep -C 20 -rin -E "CRASH|ANR|NOT RESPONDING" ${LOG_DIR} >> ${FILE}
		echo " " >> ${FILE}
        exit
      else [ "*" ]; `then`
           echo ""
           echo "serial number error"
           echo ""
           exit
           break
    fi
}

RunMonkey_Default()
{
check_device
br
}

RunSeed_Default()
{
check_device
run_seed
}

RunMonkey_Default
#RunSeed_Default
