% script VARIABLES_TRAVELLERS
INDEX_LOMBARDIA =1;
INDEX_LAZIO     =2;
INDEX_CAMPANIA  =3;

LEGEND_PLOT     =1;
THREE_PLOT      =2;
DEATHS_PLOT     =3;
CHEATERS_PLOT   =4;
ACTIVES_PLOT    =5;
TOTALS_PLOT     =6;

NULL_MODEL      =0;
STANDARD_RMS    =1;
ROOT_NULL_MODEL =2;

BEST_JUMPERS.REGIONS{INDEX_LOMBARDIA}=0;
BEST_JUMPERS.REGIONS{INDEX_LAZIO}    =36;
BEST_JUMPERS.REGIONS{INDEX_CAMPANIA} =37;


CMAPS=cell(1,4);
CMAPS{1}=repmat([0,0,1],4,1);    %% without travelers old CMAPS{1}=linspecer(4); 
CMAPS{2}=repmat([1,0,0],4,1);    %% with travelers    old CMAPS{2}=linspecer(4); 
CMAPS{3}=linspecer(4)*0;  %% ground truth      old CMAPS{3}=linspecer(4); 
CMAPS{4}=linspecer(4)*0;  %% data              old CMAPS{4}=linspecer(4); 

MK=cell(1,4);
MK{1}='--';   %% without travelers
MK{2}=':';    %% with travelers %mk{end+1}='-.';
MK{3}='-';    %% ground truth
MK{4}='o';    %% data

LW=[3,5,1,1.5]; %% old LW=[3,5,1,2];
MS=[5,5,5,7]; %% old MS=[5,5,5,5];

POS=[0,0,3000,600];%old [0,0,3000,600];

SAVE_DIR='FIGURES/';