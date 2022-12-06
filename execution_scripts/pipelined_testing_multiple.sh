#! /bin/bash
GRADE="ED"
UNIT="ESS2"
INPUT_FILES=("A" "B" "C" "D")

targetid_model="targetid0724"
frameid_model="frameid0724"
argid_model="argid0725"
MULTIPLE_FRAME=false

alias python="/opt/anaconda3/envs/open-sesame/bin/python"

for i in "${INPUT_FILES[@]}"
do
    TAG="NGSS_${UNIT}${i}_${GRADE}"
    input_text_file="DATA/ngss/${UNIT}.${i}_${GRADE}_sent.txt"
    echo ">>> Processing $TAG"

    if [ "$MULTIPLE_FRAME" = true ]
    then
        optional_arg="--multiple_frames"
        TAG2="${TAG}_multiframe"
    else
        TAG2="${TAG}_singleframe"
    fi

    if [ ! -f "logs/${targetid_model}/predicted-targets__${TAG}.conll" ]
    then
        python -m sesame.targetid --mode predict  --model_name $targetid_model \
            --raw_input $input_text_file  --output_suffix $TAG
    else
        echo ">>> the file is there, no need to rerun!"
    fi
    
    if [ ! -f "logs/$frameid_model/predicted-frames__$TAG2.conll" ]
    then 
        python -m sesame.frameid --mode predict  --model_name $frameid_model \
            --raw_input logs/$targetid_model/predicted-targets__$TAG.conll --output_suffix $TAG2 $optional_arg
    else
        echo ">>> the file exists!"
    fi
    

    if [ "$MULTIPLE_FRAME" = false ] 
    then 
        python -m sesame.argid --mode predict --model_name $argid_model \
            --raw_input logs/$frameid_model/predicted-frames__${TAG}_singleframe.conll --output_suffix "${TAG}_singleframe"
    fi
done

