#!/sbin/sh

# The below variables shouldn't need to be changed
# unless you want to call the script something else
SCRIPTNAME="VendorInit"
LOGFILE=/tmp/recovery.log

# Functions for logging to the recovery log
log_info()
{
	echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error()
{
	echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

# Functions to update props using resetprop
update_product_device()
{
	log_info "Current product: $product"
	resetprop "ro.build.product" "$1"
	product=$(getprop ro.build.product)
	log_info "New product: $product"
	log_info "Current device: $device"
	resetprop "ro.product.device" "$1"
	device=$(getprop ro.product.device)
	log_info "New device: $device"
}

update_model()
{
	log_info "Current model: $model"
	resetprop "ro.product.model" "$1"
	model=$(getprop ro.product.model)
	log_info "New model: $model"
}

# These variables will pull directly from getprop output
bootmid=$(getprop ro.boot.mid)
bootcid=$(getprop ro.boot.cid)
device=$(getprop ro.product.device)
model=$(getprop ro.product.model)
product=$(getprop ro.build.product)

# Here's where the fun begins...
# To adapt this for other devices, only the MID strings in the case statement
# need to be updated, and the value of the props to be set based on them.
# I tried to make the syntax as straightforward as possible so it's easy
# to update for future devices.
log_info "Updating device properties based on MID and CID..."
log_info "MID Found: $bootmid"
log_info "CID Found: $bootcid"

case $bootmid in
	0P6B10000|0P6B11000|0P6B12000|0P6B13000|0P6B15000|0P6B16000|0P6B17000)
		## US/Int'l/GPE GSM m8 (m8) ##
		if [ "$bootcid" = 'CWS__001' ]; then
			log_info "AT&T variant detected!"
		fi
		if [ "$bootcid" = 'T-MOB010' ]; then
			log_info "T-Mobile US variant detected!"
		fi
		if [ "$bootcid" = 'GOOGL001' ]; then
			log_info "Google Play Edition detected!"
		fi
		update_product_device "htc_m8"
		log_info "Current model: $model"
		;;
	0P6B20000)
		## m8vzw (m8wl) ##
		if [ "$bootcid" = 'VZW__001' ]; then
			log_info "Verizon variant detected!"
		fi
		update_product_device "htc_m8wl"
		update_model "HTC6525LVW"
		;;
	0P6B41000)
		## China Telecom (m8dwg) ##
		update_product_device "htc_m8dwg"
		update_model "HTC M8d"
		;;
	0P6B61000)
		## China Unicom (m8dug) ##
		update_product_device "htc_m8dug"
		update_model "HTC M8e"
		;;
	0P6B64000|0P6B68000)
		## International (m8dug) ##
		update_product_device "htc_m8dug"
		update_model "HTC One_M8 dual sim"
		;;
	0P6B70000)
		## m8spr (m8whl) ##
		if [ "$bootcid" = 'SPCS_001' ]; then
			log_info "Sprint variant detected!"
		fi
		update_product_device "htc_m8whl"
		update_model "831C"
		;;
	0PAJ10000)
		## China Mobile (mectl) ##
		update_product_device "htc_mectl"
		update_model "HTC One_E8"
		;;
	0PAJ20000|0PAJ21000|0PAJ22000)
		## China Unicom/Bangladesh (mecdugl) ##
		update_product_device "htc_mecdugl"
		update_model "HTC One_E8 Dual Sim"
		;;
	0PAJ30000)
		## Europe (mecul_emea) ##
		update_product_device "htc_mecul_emea"
		update_model "HTC One_E8"
		;;
	0PAJ31000)
		## Singapore/Vietnam/Europe MMR (mecul) ##
		update_product_device "htc_mecul"
		update_model "HTC One_E8"
		;;
	0PAJ40000)
		## China Telecom (mecdwgl) ##
		update_product_device "htc_mecdwgl"
		update_model "HTC One_E8 Dual Sim"
		;;
	0PAJ50000)
		## Sprint (mecwhl) ##
		if [ "$bootcid" = 'SPCS_001' ]; then
			log_info "Sprint variant detected!"
		fi
		update_product_device "htc_mecwhl"
		update_model "0PAJ5"
		;;
	0P6B*)
		## M8 ##
		log_error "MID device parameters unknown. Setting default values."
		update_product_device "htc_m8"
		log_info "Current model: $model"
		;;
	0PAJ*)
		## E8 ##
		log_error "MID device parameters unknown. Setting default values."
		update_product_device "htc_mec"
		update_model "HTC One_E8"
		;;
esac

exit 0