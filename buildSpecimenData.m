function buildSpecimenData

specimenDataDir = 'specimenData';

% Read Data Common to All Experiments
[~,data]       = csvread2(fullfile(specimenDataDir,'specimenData.csv'));
[~,imperfData] = csvread2(fullfile(specimenDataDir,'initialImperfections.csv'));
[~,lc1Data]    = csvread2(fullfile(specimenDataDir,'loadCase1.csv'));

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
    specimenData(i).LC1.numCycles = lc1Data.Num_Cycle(i);
    targets = zeros(0,2);
    dirOfMotion = [0 0];
    if specimenData(i).LC1.numCycles > 0
        targets = vertcat(targets,...
            [lc1Data.target_Dx_LC1a(i) lc1Data.target_Dy_LC1a(i)]);
        dirOfMotion = targets - [specimenData(i).Dxo specimenData(i).Dyo];
        dirOfMotion = dirOfMotion/norm(dirOfMotion);
    end
    if specimenData(i).LC1.numCycles > 1
        targets = vertcat(targets,...
            [lc1Data.target_Dx_LC1b(i) lc1Data.target_Dy_LC1b(i)]);
    end
    specimenData(i).LC1.targets = targets;
    specimenData(i).LC1.dirOfMotion = dirOfMotion;
    
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