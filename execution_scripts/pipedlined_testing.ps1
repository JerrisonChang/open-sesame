# $GRADE = "2s"
$TAG = "student_276"
# $input_text_file = "DATA\ngss\PS2.A_$($GRADE).txt"
$input_text_file = "DATA\student_notes__22.txt"
$targetid_model = "targetid0724"
$frameid_model = "frameid0724"
$argid_model = "argid0725"

conda activate open-sesame

function Exit-With-Error {
    param ($output)
    [console]::beep(250,250)
    [console]::beep(250,250)

    $output
    exit
}

$target_output = python -m sesame.targetid --mode predict  --model_name $targetid_model `
    --raw_input $input_text_file  --output_suffix $TAG
if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $target_output }
[console]::beep(1000,200)

$frame_output = python -m sesame.frameid --mode predict  --model_name $frameid_model `
    --raw_input logs\$targetid_model\predicted-targets__$TAG.conll --output_suffix "$($TAG)_singleframe"
if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $frame_output }
[console]::beep(1000,200)

$fe_output = python -m sesame.argid --mode predict --model_name $argid_model `
    --raw_input logs\$frameid_model\predicted-frames__${TAG}_singleframe.conll --output_suffix $TAG
if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $fe_output }


[console]::beep(2000,200)
Start-Sleep -m 100
[console]::beep(2000,800)
Start-Sleep -m 100
[console]::beep(2000,800)
