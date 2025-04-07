#!/bin/bash


function HELP(){
    local _name=${0##*/}
    echo "usage: ${_name} <prplos-codebase-tag-or-branch>"
    echo "e.g. ${_name} prplos-v3.1.0"
}


# MAIN

TAG_INDEX=$1
FEEDS_FOLDER="workspace/prplos/feeds"

# check if worksapce is ready
if [[ ! -d "workspace/prplos" ]]; then
    read -p "workspace is not ready!! prepare?(Y/N)"
    if [[ "$REPLY" == "Y" ]]; then
        echo "bash prepare_workspace.sh"
        bash prepare_workspace.sh
    fi
fi

# setup prplos codebase HEAD points to ${TAG_or_BRANCH}
tag_list="$(git --git-dir=./workspace/prplos/.git tag)"
tag_list=(${tag_list} $(git --git-dir=./workspace/prplos/.git branch -a | awk 'NR>1 {print $1}'))
if [[ -z ${TAG_INDEX} ]]; then
    count=0
    echo "======================"
    for tag in ${tag_list[@]}
    do
        printf "\t (%d) %s\n" $count $tag
        count=$((count+1))
    done
    echo "======================"

    read -e -p "select: "
    TAG_INDEX=$REPLY
fi

TAG=${tag_list[${TAG_INDEX}]}
OUTPUT_NAME=${TAG}
OUTPUT_FOLDER="output/${OUTPUT_NAME}"

cd ./workspace/prplos
git switch --detach ${TAG}
./scripts/gen_config.py clean
./scripts/gen_config.py prpl x86_64
cd -


# create folder

if [[ -d ${OUTPUT_FOLDER} ]]; then
    read -p "Overwrite ${OUTPUT_FOLDER}?(Y/n)"
    if [[ $REPLY == "Y" ]]; then
        rm ${OUTPUT_FOLDER} -r
    fi
fi

mkdir -p ${OUTPUT_FOLDER}

feed_list=$(cat ${FEEDS_FOLDER}/../feeds.conf | grep "feed_" | awk '{print $2}')

# generate sum.index to gather "feeds/*.index"

for feed in ${feed_list}
do
    echo "parsing $feed ..."
    cat ${FEEDS_FOLDER}/${feed}.index >> "${OUTPUT_FOLDER}/sum.index"
done
echo ""

# generate header of csv
#printf "%s, %s, %s, %s, %s, %s\n" \
#    "mk_num" "pk_num" "mk_path" "pk_name" "license" "version" >> "${OUTPUT_FOLDER}/${OUTPUT_NAME}.csv"

printf "%s, %s, %s, %s\n" \
    "pk_name" "mk_path" "license" "version" >> "${OUTPUT_FOLDER}/${OUTPUT_NAME}.csv"

# generate content of csv
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
                #printf("%s, %s, %s, %s\n", 
                #    makefile_list[mk_num][pk_num]["name"], 
                #    makefile_list[mk_num][pk_num]["path"], 
                #    makefile_list[mk_num][pk_num]["license"],
                #    makefile_list[mk_num][pk_num]["version"]);

                printf("%s, %s, %s, %s\n", 
                    makefile_list[mk_num][pk_num]["name"], 
                    makefile_list[mk_num][pk_num]["path"],
                    makefile_list[mk_num][pk_num]["license"],
                    makefile_list[mk_num][pk_num]["version"]) >> output_path
            }
        }
    }

' "${OUTPUT_FOLDER}/sum.index"


