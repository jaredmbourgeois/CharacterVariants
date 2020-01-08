#!/bin/sh

#
#  Build.sh
#  Created by Jared on 1/3/20.
#
#SIMPSONS_DIRECTORY=/Users/jared/Projects/CharacterVariants/SimpsonsCharacters/SimpsonsCharacters/
#WIRE_DIRECTORY=/Users/jared/Projects/CharacterVariants/WireCharacters/WireCharacters/
#MOMD_TARGET_DIRECTORIES=(SIMPSONS_DIRECTORY,WIRE_DIRECTORY)
MODEL_NAME=CoreDataModel
MODEL_DIRECTORY=/Users/jared/Projects/CharacterVariants/CharacterVariantsCommon/
MODEL_PATH="${MODEL_DIRECTORY}""${MODEL_NAME}"".xcdatamodel"

MOMC=/Applications/Xcode.app/Contents/Developer/usr/bin/momc

MOMD_PATH="${MOMD_DIRECTORY}""${MODEL_NAME}"".momd"
$MOMC $MODEL_PATH $MOMD_PATH



#FRAMEWORK_DIRECTORY=/Users/jared/Projects/CharacterVariants/CharacterVariantsCommon/CharacterVariantsCommon/
#SIMPSONS_MOMD_DIRECTORY=/Users/jared/Projects/CharacterVariants/SimpsonsCharacters/SimpsonsCharacters/
#WIRE_MOMD_DIRECTORY=/Users/jared/Projects/CharacterVariants/WireCharacters/WireCharacters/

#MOMD_DIRECTORIES=(
#    FRAMEWORK_DIRECTORY,
#    SIMPSONS_MOMD_DIRECTORY,
#    WIRE_MOMD_DIRECTORY
#)
#FOR DIRECTORY in "${MOMD_DIRECTORIES[@]}"
#DO
#    MOMD_PATH="${DIRECTORY}""${MODEL_NAME}"".momd"
#    $MOMC $MODEL_PATH $MOMD_PATH
#DONE
