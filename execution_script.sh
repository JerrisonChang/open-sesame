#! /bin/bash
TAG="0731"
input_text_file="DATA/test_sentences.txt"
targetid_model="targetid0724"
frameid_model="frameid0724"
argid_model="argid0725"
alias python="/opt/anaconda3/envs/open-sesame/bin/python"

python -m sesame.targetid --mode predict  --model_name $targetid_model \
    --raw_input $input_text_file  --output_suffix $TAG

python -m sesame.frameid --mode predict  --model_name $frameid_model \
    --raw_input logs/$targetid_model/predicted-targets__$TAG.conll --output_suffix $TAG

python -m sesame.argid --mode predict --model_name $argid_model \
    --raw_input logs/$frameid_model/predicted-frames__$TAG.conll --output_suffix $TAG