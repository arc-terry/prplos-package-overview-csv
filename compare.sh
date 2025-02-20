#!/bin/bash



A_FILE=$1
B_FILE=$2
OUTPUT_FILE=$3

if [[ -e ${OUTPUT_FILE} ]]; then
    read -p "overwrite ${OUTPUT_FILE}?(Y/n)"
    if [[ "$REPLY" == "Y" ]]; then
        rm $OUTPUT_FILE
    fi
fi

package_list="$(cat ${A_FILE} ${B_FILE} | awk -F"," {'print $1}' | sort  | uniq)"

printf "%s, %s, %s, %s, %s, %s, %s, %s\n" \
    "pkg" "A_mk_path" "B_mk_path" "A_license" "B_license" "A_version" "B_version" "status" >> ${OUTPUT_FILE}

for pkg in ${package_list}
do
    # parse A
    A_mk_path=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $2); print $2}' ${A_FILE}))
    A_license=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $3); print $3}' ${A_FILE}))
    A_version=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $4); print $4}' ${A_FILE}))

    # parse B
    B_mk_path=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $2); print $2}' ${B_FILE}))
    B_license=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $3); print $3}' ${B_FILE}))
    B_version=($( awk -F"," -v PKG=${pkg} '$1 == PKG{sub(/^[ \t]+/, "", $4); print $4}' ${B_FILE}))

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






