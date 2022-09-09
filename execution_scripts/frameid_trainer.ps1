$TAG = "without_military_000"
$frameid_model = "frameid0908"

conda activate open-sesame

python -m sesame.frameid --mode train --model_name $frameid_model --train_data_tag $TAG 