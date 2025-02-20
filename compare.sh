#!/bin/bash

function HELP(){

    local _name=${0##*/}
    echo "usage: ${_name} <A_csv_file> <B_csv_file>"

}


if [[ $# -ne 2 ]]; then
    HELP
    exit 1
fi


A_PATH=$1
B_PATH=$2

A_FILE=${A_PATH##*/}
A_NAME=${A_FILE/.csv/}
B_FILE=${B_PATH##*/}
B_NAME=${B_FILE/.csv/}

OUTPUT_DIR="output/compare"
OUTPUT_FILE="output/compare/${A_NAME}_vs_${B_NAME}.csv"

if [[ ! -e ${OUTPUT_DIR} ]]; then
    mkdir ${OUTPUT_DIR}
fi

if [[ -e ${OUTPUT_FILE} ]]; then
    read -p "overwrite ${OUTPUT_FILE}?(Y/n)"
    if [[ "$REPLY" == "Y" ]]; then
        rm $OUTPUT_FILE
    fi
fi

package_list="$(cat ${A_PATH} ${B_PATH} | awk -F"," {'print $1}' | sort  | uniq)"

printf "%s, %s, %s, %s, %s, %s, %s, %s\n" \
    "pkg" "A_mk_path" "B_mk_path" "A_license" "B_license" "A_version" "B_version" "status" >> ${OUTPUT_FILE}

for pkg in ${package_list}
do
    # parse A
    A_mk_path=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $2); print $2}' ${A_PATH}))
    A_license=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $3); print $3}' ${A_PATH}))
    A_version=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $4); print $4}' ${A_PATH}))

    # parse B
    B_mk_path=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $2); print $2}' ${B_PATH}))
    B_license=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $3); print $3}' ${B_PATH}))
    B_version=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $4); print $4}' ${B_PATH}))

    # status
    if [[ -z ${A_version[0]} ]]; then
        status="B only"
    elif [[ -z ${B_version[0]} ]]; then
        status="A only"
    elif [[ "${A_version[0]}" != "${B_version[0]}" ]]; then
        status="diff"
    elif [[ "${A_version[0]}" == "${B_version[0]}" ]]; then
        status="same"
    elif [[ ${#A_versio[@]} -gt 1 || ${#B_version[@]} -gt 1 ]]; then
        status="conflict"
    fi


    #echo "====${pkg}==="
    #echo "A_mk_path: ${A_mk_path}"
    #echo "A_license: ${A_license}"
    #echo "A_version: ${A_version}"
    #echo "B_mk_path: ${B_mk_path}"
    #echo "B_license: ${B_license}"
    #echo "B_version: ${B_version}"
    #echo "status: ${status}"

    if [[ "${status}" == "conflict" ]]; then
        echo "conflict package: $pkg"
    else
        printf "%s, %s, %s, %s, %s, %s, %s, %s\n" \
            "${pkg}" "${A_mk_path}" "${B_mk_path}" "${A_license}" "${B_license}" "${A_version}" "${B_version}" \
            "${status}" >> ${OUTPUT_FILE}
    fi

    #grep "CONFIG_PACKAGE_$pkg" ../prplos_test/prplos/.config
    #echo ""

done






