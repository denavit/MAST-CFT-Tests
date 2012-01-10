function names = channelNames(specimenNum)

% Cross Head Channels
namesCH = {'X_Displ','X_Force','Y_Displ','Y_Force','Z_Displ','Z_Force',...
    'RX_Displ','RX_Force','RY_Displ','RY_Force','RZ_Displ','RZ_Force',...
    'Shear','Warp'};

% String Pot Channels
if specimenNum <= 9
    namesSP = {...
        'SP6_2N','SP9_2N','SP12_2N','SP13_8N',...
        'SP6_2W','SP9_2W','SP12_2W','SP13_8W'};
else
    namesSP = {...
        'SP6_0N','SP10_0N','SP14_0N','SP18_0N','SP22_0N',...
        'SP6_0W','SP10_0W','SP14_0W','SP18_0W','SP22_0W'};
end

% LVDT Channels
if specimenNum <= 9
    namesLVDT = {...
        'LV1_0N','LV2_0N','LV3_0N','LV4_0N','LV5_0N','LV6_2N','LV17_0N',...
        'LV1_0W','LV2_0W','LV3_0W','LV4_0W','LV5_0W','LV6_2W','LV17_0W',...
        'LV1_0S','LV2_0S','LV3_0S','LV4_0S','LV5_0S','LV6_2S','LV17_0S'};
else
    namesLVDT = {...
        'LV1_0N','LV2_0N','LV3_0N','LV4_0N','LV25_0N',...
        'LV1_0W','LV2_0W','LV3_0W','LV4_0W','LV25_0W',...
        'LV1_0S','LV2_0S','LV3_0S','LV4_0S','LV25_0S'};
end

% Strain Gage Channels
if specimenNum <= 9
    namesSGa = {...
        'SG0_6N','SG1_6N','SG2_6N','SG3_6N','SG4_6N','SG6_0N','SG9_0N','SG12_0N','SG13_6N','SG17_6N',...
        'SG0_6W','SG1_6W','SG2_6W','SG3_6W','SG4_6W','SG6_0W','SG9_0W','SG12_0W','SG13_6W','SG17_6W',...
        'SG0_6S','SG1_6S','SG2_6S','SG3_6S','SG4_6S','SG6_0S','SG9_0S','SG12_0S','SG13_6S','SG17_6S'};
    if specimenNum == 5
        namesSGa{ 9} = 'SG13_8N';
        namesSGa{19} = 'SG13_8W';
        namesSGa{29} = 'SG13_8S';
    end
else
    namesSGa = {...
        'SG0_6N','SG1_6N','SG2_6N','SG3_6N','SG6_6N','SG13_0N','SG19_6N','SG25_6N',...
        'SG0_6W','SG1_6W','SG2_6W','SG3_6W','SG6_6W','SG13_0W','SG19_6W','SG25_6W',...
        'SG0_6S','SG1_6S','SG2_6S','SG3_6S','SG6_6S','SG13_0S','SG19_6S','SG25_6S',...
        'SG0_6E','SG1_6E'};
end
switch specimenNum
    case 1
        namesSGb = {'SG0_6NR','SG0_6NT','SG2_6NR','SG2_6NT','SG2_6ST','SG4_6NR','SG4_6NT'};
    case 2
        namesSGb = {'SG0_6SR','SG0_6ST','SG2_6NT','SG2_6SR','SG2_6ST','SG4_6SR','SG4_6ST'};
    case 3
        namesSGb = {'SG0_6SR','SG0_6ST','SG1_6S2','SG2_6NT','SG2_6SR','SG2_6ST','SG4_6SR','SG4_6ST'};
    case 4
        namesSGb = {'SG0_6WR','SG0_6WT','SG2_6E','SG2_6SR','SG2_6ST','SG2_6WR','SG2_6WT','SG4_6WR','SG4_6WT'};
    case 5
        namesSGb = {'SG0_6WR','SG0_6WT','SG2_6E','SG2_6NR','SG2_6NT','SG2_6WR','SG2_6WT','SG4_6WR','SG4_6WT'};
    case 6
        namesSGb = {'SG0_6NT','SG0_6ST','SG2_6NT','SG2_6ST','SG4_6NT','SG4_6ST'};
    case 7
        namesSGb = {'SG0_6ST','SG2_6NT','SG2_6ST','SG4_6ST'};
    case 8
        namesSGb = {'SG0_6ST','SG0_6WT','SG2_6NT','SG2_6ST','SG2_6WT','SG4_6ST'};
    case 9
        namesSGb = {'SG0_6NT','SG2_6NT','SG2_6ST','SG2_6WT','SG4_6NT','SG4_6WT'};
    case 10
        namesSGb = {};
    case 11
        namesSGb = {'SG1_6WT','SG2_6WT'};
    case 12
        namesSGb = {'SG1_6NR','SG1_6NT','SG1_6WR','SG1_6WT','SG2_6E','SG2_6NR','SG2_6NT','SG2_6WR','SG2_6WT','SG10_0N'};
    case 13
        namesSGb = {'SG1_6NR','SG1_6NT','SG1_6WR','SG1_6WT','SG2_6NR','SG2_6NT','SG2_6WR','SG2_6WT'};
    case 14
        namesSGb = {};
    case 15
        namesSGb = {'SG1_6WT','SG2_6WT'};
    case 16
        namesSGb = {'SG1_6NR','SG1_6NT','SG1_6WR','SG1_6WT','SG2_6NR','SG2_6NT','SG2_6WR','SG2_6WT'};
    case 17
        namesSGb = {'SG1_6NR','SG1_6NT','SG1_6WR','SG1_6WT','SG2_6NR','SG2_6NT','SG2_6WR','SG2_6WT'};
    case 18
        namesSGb = {'SG0_6Wo','SG2_6E','SG3_6E','SG6_6E'};
    otherwise
        error('Bad specimenNum');
end

% Combine All
names = horzcat(namesCH,namesSP,namesLVDT,namesSGa,namesSGb);

end