#!/bin/bash


function HELP(){
    local _name=${0##*/}
    echo "usage: ${_name} <path-to-feeds> <output-name>"
}


# MAIN

FEEDS_FOLDER=$1
OUTPUT_NAME=$2
OUTPUT_FOLDER=${OUTPUT_NAME}

if [[ $# != 2 ]];then
    HELP
    exit
fi


# create folder

if [[ -d ${OUTPUT_FOLDER} ]]; then
    read -p "overwrite ${OUTPUT_FOLDER}?(Y/n)"
    if [[ $REPLY == "Y" ]]; then
        rm ${OUTPUT_FOLDER} -r
    fi
fi

mkdir ${OUTPUT_FOLDER}

feed_list=$(cat ${FEEDS_FOLDER}/../feeds.conf | grep "feed_" | awk '{print $2}')

for feed in ${feed_list}
do
    echo "=== $feed ==="
    cat ${FEEDS_FOLDER}/${feed}.index >> "${OUTPUT_FOLDER}/sum.index"
    echo ""
done

# header of csv
#printf "%s, %s, %s, %s, %s, %s\n" \
#    "mk_num" "pk_num" "mk_path" "pk_name" "license" "version" >> "${OUTPUT_FOLDER}/${OUTPUT_NAME}.csv"

printf "%s, %s, %s, %s\n" \
    "pk_name" "mk_path" "license" "version" >> "${OUTPUT_FOLDER}/${OUTPUT_NAME}.csv"

# content of csv
gawk \
    -v OUTPUT_FOLDER=${OUTPUT_FOLDER} \
    -v OUTPUT_NAME=${OUTPUT_NAME} '
    BEGIN{
        mk_num=0
        pk_num=0
        mk_path=""
    }

    /Source-Makefile:/{
        mk_num = mk_num+1
        pk_num = 0
        mk_path = $2
        # makefile_list[mk_num][pk_num]["path"] = $2
    }

    /Package:/{
        pk_num = pk_num + 1
        makefile_list[mk_num][pk_num]["path"] = mk_path
        makefile_list[mk_num][pk_num]["name"] = $2
    }

    /License:/{
        makefile_list[mk_num][pk_num]["license"] = $2
    }

    /Version:/{
        makefile_list[mk_num][pk_num]["version"] = $2
    }

    END{

        output_path = sprintf("%s/%s.csv", OUTPUT_FOLDER, OUTPUT_NAME)

        for (mk_num in makefile_list){
            for (pk_num in makefile_list[mk_num]){
                printf("%s, %s, %s, %s\n", 
                    makefile_list[mk_num][pk_num]["name"], 
                    makefile_list[mk_num][pk_num]["path"], 
                    makefile_list[mk_num][pk_num]["license"],
                    makefile_list[mk_num][pk_num]["version"]);

                printf("%s, %s, %s, %s\n", 
                    makefile_list[mk_num][pk_num]["name"], 
                    makefile_list[mk_num][pk_num]["path"],
                    makefile_list[mk_num][pk_num]["license"],
                    makefile_list[mk_num][pk_num]["version"]) >> output_path
            }
        }
    }

' "${OUTPUT_FOLDER}/sum.index"


