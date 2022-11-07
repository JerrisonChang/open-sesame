$GRADE = "ed"
$UNIT = "LS1"
$input_files = "A", "B", "C", "D"
# $input_text_file = "DATA\ngss\PS2.A_$($GRADE).txt"
$targetid_model = "targetid0724"
$frameid_model = "frameid0724"
$argid_model = "argid0725"
$multipleframe = $true

conda activate open-sesame

foreach ($letter in $input_files) {
    $TAG = "NGSS_$($UNIT)$($letter)_$($GRADE)"
    $input_text_file = "DATA\ngss\$($UNIT).$($letter)_$($GRADE).txt"
    Write-Output ">>> Processing $($TAG)..."
    
    if ($multipleframe) {
        $optional_arg = "--multiple_frames"
        $TAG2 = "$($TAG)_multiframe"
    } else {
        $TAG2 = "$($TAG)_singleframe"
    }
    
    if (! (Test-Path -Path logs\$targetid_model\predicted-targets__$TAG.conll)) { # run this if the file is not present
        python -m sesame.targetid --mode predict  --model_name $targetid_model `
            --raw_input $input_text_file  --output_suffix $TAG
    } else {
        Write-Output ">>> the file is there, no need to rerun!"
    }

    python -m sesame.frameid --mode predict  --model_name $frameid_model `
        --raw_input logs\$targetid_model\predicted-targets__$TAG.conll --output_suffix $TAG2 $optional_arg
    
    if (!$multipleframe) {
        python -m sesame.argid --mode predict --model_name $argid_model `
            --raw_input logs\$frameid_model\predicted-frames__$($TAG)_singleframe.conll --output_suffix "$($TAG)_singleframe"
    }
}
