#!/sbin/sh

fastboot=$(getprop ro.boot.bootreason | cut -d, -F2)
if [[ $fastboot == "bootloader" || $fastboot == "longkey" || $fastboot == "reboot"  || $fastboot == "recovery" ]]
then
	insmod /sbin/synaptics_dsx_core.ko
	insmod /sbin/synaptics_dsx_fw_update.ko
	insmod /sbin/synaptics_dsx_rmi_dev.ko
	insmod /sbin/synaptics_dsx_test_reporting.ko
fi
