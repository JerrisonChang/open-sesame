# $GRADE = "2s"
# $input_text_file = "DATA\ngss\PS2.A_$($GRADE).txt"
# $note_id = "345"
# $input_text_file = "DATA\student_notes__$($note_id).txt"
# $TAG = "student_$($note_id)"
conda activate open-sesame

$grade2tag = @{
    '2s' = ""
    '5s' = ""
    '8s' = ""
    '12s' = ""
}


function Exit-With-Error {
    param ($output)
    [console]::beep(250,250)
    [console]::beep(250,250)

    $output
    exit
}

function Start-Single-File {
    param (
        [string]$input_file, 
        [string]$tag,
        [string]$tm = "targetid0724", 
        [string]$fm = "frameid0724", 
        [string]$am = "argid0725"
    )

    $target_output = python -m sesame.targetid --mode predict  --model_name $tm `
        --raw_input $input_file  --output_suffix $tag
    if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $target_output }
    [console]::beep(1000,200)
    
    $frame_output = python -m sesame.frameid --mode predict  --model_name $fm `
        --raw_input logs\$tm\predicted-targets__$tag.conll --output_suffix "$($tag)_singleframe"
    if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $frame_output }
    [console]::beep(1000,200)
    
    $fe_output = python -m sesame.argid --mode predict --model_name $am `
        --raw_input logs\$fm\predicted-frames__${tag}_singleframe.conll --output_suffix $tag
    if ($LASTEXITCODE -ne 0 ) { Exit-With-Error -output $fe_output }
    
    
    [console]::beep(2000,800)
    Start-Sleep -m 100
    [console]::beep(2000,800)
    Start-Sleep -m 100
    [console]::beep(2000,800)
}


foreach ($h in $grade2tag.GetEnumerator()) {
    $file_path = "DATA\ngss\LS1.C_$($h.Name).txt"
    Start-Single-File -input_file $file_path -tag "0312"
}