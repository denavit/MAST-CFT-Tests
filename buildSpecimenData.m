function buildSpecimenData

specimenDataDir = 'specimenData';

% Read Data Common to All Experiments
[~,data]       = csvread2(fullfile(specimenDataDir,'specimenData.csv'));
[~,imperfData] = csvread2(fullfile(specimenDataDir,'initialImperfections.csv'));
[~,lc1Data]    = csvread2(fullfile(specimenDataDir,'loadCase1.csv'));
[~,lc2Data]    = csvread2(fullfile(specimenDataDir,'loadCase2.csv'));
[~,lc3Data]    = csvread2(fullfile(specimenDataDir,'loadCase3.csv'));

numTests = length(data.name);

specimenData(numTests) = struct;
for i = 1:numTests
    specimenData(i).specimen = data.name{i}; 
    specimenData(i).type = data.type{i};
    specimenData(i).axis = data.axis{i};
    specimenData(i).units = 'US';
    switch specimenData(i).type
        case 'ccft'
            specimenData(i).D = data.D(i);
        case 'rcft'
            specimenData(i).H = data.H(i);
            specimenData(i).B = data.B(i);
        otherwise
            error('unknown type');
    end
    specimenData(i).t   = data.t(i);
    specimenData(i).L   = data.L(i);
    specimenData(i).Fy  = data.Fy(i);
    specimenData(i).Fu  = data.Fu(i);
    specimenData(i).Es  = data.Es(i);
    specimenData(i).fc  = data.fc(i);
    specimenData(i).Ec  = data.Ec(i);
    specimenData(i).ft  = data.ft(i);
    
    % Data Parsed From the Specimen Name
    temp = textscan(specimenData(i).specimen,'%n%s%n%n','Delimiter','-');
    specimenData(i).specimenNumber = temp{1};
    specimenData(i).type2          = temp{2}{1};
    specimenData(i).nominal.L_ft   = temp{3};    
    specimenData(i).nominal.L_in   = 12*specimenData(i).nominal.L_ft;
    specimenData(i).nominal.fc     = temp{4};
    
    % Initial Imperfections
    specimenData(i).Dxo = imperfData.XTOP(i);
    specimenData(i).Dyo = imperfData.YTOP(i);
    switch specimenData(i).nominal.L_ft
        case 18
            specimenData(i).initialImperfection.height = ...
                [0.0 6*12+2 9*12+2 12*12+2 13*12+8 specimenData(i).L]';
            specimenData(i).initialImperfection.x = [
                0.0
                imperfData.X6_2(i)
                imperfData.X9_2(i)
                imperfData.X12_2(i)
                imperfData.X13_8(i)
                imperfData.XTOP(i)];
            specimenData(i).initialImperfection.y = [
                0.0
                imperfData.Y6_2(i)
                imperfData.Y9_2(i)
                imperfData.Y12_2(i)
                imperfData.Y13_8(i)
                imperfData.YTOP(i)];
        case 26
            specimenData(i).initialImperfection.height = ...
                [0.0 6*12 10*12 14*12 18*12 22*12 specimenData(i).L]';
            specimenData(i).initialImperfection.x = [
                0.0
                imperfData.X6_0(i)
                imperfData.X10_0(i)
                imperfData.X14_0(i)
                imperfData.X18_0(i)
                imperfData.X22_0(i)
                imperfData.XTOP(i)];
            specimenData(i).initialImperfection.y = [
                0.0
                imperfData.Y6_0(i)
                imperfData.Y10_0(i)
                imperfData.Y14_0(i)
                imperfData.Y18_0(i)
                imperfData.Y22_0(i)                
                imperfData.YTOP(i)];            
        otherwise
            error('Unknown Nominal Length')
    end
    
    % Load Case 1
    if isnan(lc1Data.Number_Of_Cycles(i))
        specimenData(i).LC1 = [];
    else
        specimenData(i).LC1.numCycles   = lc1Data.Number_Of_Cycles(i);
        specimenData(i).LC1.dirOfMotion = lc1Data.Direction_Of_Motion(i);
        switch specimenData(i).LC1.numCycles
            case 0
                specimenData(i).LC1.targets = zeros(0,2);
            case 1
                specimenData(i).LC1.targets = ...
                    [lc1Data.target_Dx_LC1a(i) lc1Data.target_Dy_LC1a(i)];
            case 2
                specimenData(i).LC1.targets = ...
                    [lc1Data.target_Dx_LC1a(i) lc1Data.target_Dy_LC1a(i)
                    lc1Data.target_Dx_LC1b(i) lc1Data.target_Dy_LC1b(i)];
            case 3
                specimenData(i).LC1.targets = ...
                    [lc1Data.target_Dx_LC1a(i) lc1Data.target_Dy_LC1a(i)
                    lc1Data.target_Dx_LC1b(i) lc1Data.target_Dy_LC1b(i)
                    lc1Data.target_Dx_LC1c(i) lc1Data.target_Dy_LC1c(i)];
            otherwise
                error('Unknwon Number_Of_Cycles');
        end
    end

    % Load Case 2  
    if isnan(lc2Data.Number_Of_Axial_Load_Levels(i))
        specimenData(i).LC2 = [];
    else
        specimenData(i).LC2.numAxialLoads = lc2Data.Number_Of_Axial_Load_Levels(i);
        specimenData(i).LC2.dirOfMotion   = lc2Data.Direction_Of_Motion(i);
        switch specimenData(i).LC2.numAxialLoads
            case 0
                specimenData(i).LC2.axialLoads = [];
            case 1
                specimenData(i).LC2.axialLoads = lc2Data.Axial_Load_LC2a(i);
            case 2
                specimenData(i).LC2.axialLoads = [lc2Data.Axial_Load_LC2a(i) lc2Data.Axial_Load_LC2b(i)];
            case 3
                specimenData(i).LC2.axialLoads = [lc2Data.Axial_Load_LC2a(i) lc2Data.Axial_Load_LC2b(i) lc2Data.Axial_Load_LC2c(i) ];
            otherwise
                error('Unknwon Number_Of_Axial_Load_Levels');
        end
    end
    
    % Load Case 3   
    if isnan(lc3Data.Number_Of_Axial_Load_Levels(i))
        specimenData(i).LC3 = [];
    else
        specimenData(i).LC3.numAxialLoads = lc3Data.Number_Of_Axial_Load_Levels(i);
        switch specimenData(i).LC3.numAxialLoads
            case 0
                specimenData(i).LC3.axialLoads = [];
            case 1
                specimenData(i).LC3.axialLoads = lc3Data.Axial_Load_LC3a(i);
            case 2
                specimenData(i).LC3.axialLoads = [lc3Data.Axial_Load_LC3a(i) lc3Data.Axial_Load_LC3b(i)];
            case 3
                specimenData(i).LC3.axialLoads = [lc3Data.Axial_Load_LC3a(i) lc3Data.Axial_Load_LC3b(i) lc3Data.Axial_Load_LC3c(i) ];
            otherwise
                error('Unknwon Number_Of_Axial_Load_Levels');
        end
    end
    
    % DxDyFz Pattern
    patternFilename = fullfile(specimenDataDir,[specimenData(i).specimen '-DxDyFzPattern.csv']);
    if exist(patternFilename,'file') == 2
        [~,patternData] = csvread2(patternFilename);
        specimenData(i).DxDyFzPattern.Dx        = patternData.Dx;
        specimenData(i).DxDyFzPattern.Dy        = patternData.Dy;
        specimenData(i).DxDyFzPattern.Fz        = patternData.Fz;
        specimenData(i).DxDyFzPattern.Load_Case = patternData.Load_Case;
    else
        specimenData(i).DxDyFzPattern = [];
    end    
    
end 

%% Save Data
save('specimenData.mat', 'specimenData');
disp('Done Reading Data!');
end