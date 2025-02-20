#!/bin/bash


OUTPUT_DIR="workspace"
OUTPUT_GIT="${OUTPUT_DIR}/prplos"
URL_PRPLOS_CODEBASE=https://gitlab.com/prpl-foundation/prplos/prplos.git


if [[ -e "${OUTPUT_GIT}" ]]; then
    read -p "Overwrite ${OUTPUT_GIT}?(Y/N)"
    if [[ "$REPLY" == "Y" ]]; then
        rm ${OUTPUT_DIR} -rf
        mkdir ${OUTPUT_DIR}
        # download prplos codebase
        git clone ${URL_PRPLOS_CODEBASE} ${OUTPUT_GIT}
    fi
else
    mkdir ${OUTPUT_DIR}
    # download prplos codebase
    git clone ${URL_PRPLOS_CODEBASE} ${OUTPUT_GIT}
fi
