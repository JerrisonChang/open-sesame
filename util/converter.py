import pandas as pd
from optparse import OptionParser
import os

DATA_FOLDER = 'DATA/labeled_data'
# optpr = OptionParser()

# optpr.add_option()

def convert_to_conll(path: str, outf: str, sheet_num: int = 0,):
    def helper(row: pd.Series) -> str:
        if any(pd.isna(row)):
            return '\n'
        else:
            return '\t'.join( [str(int(i)) if isinstance(i, float) else i for i in row]) + '\n'
    
    df = pd.read_excel(path, sheet_name = sheet_num, engine='openpyxl')
    sents_in_conll = df.iloc[:,:15].apply( helper, axis= 1)
    with open(outf, 'w') as f:
        f.writelines( sents_in_conll )

if __name__ == "__main__":
    FILE_NAME = "NGSS_LS1B_Kevin_Edited_Frames"
    
    xlpath = os.path.join(DATA_FOLDER, f"{FILE_NAME}.xlsx")
    outfpath = os.path.join(DATA_FOLDER, f"{FILE_NAME}.conll")
    convert_to_conll(xlpath, outfpath)