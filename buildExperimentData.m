function buildExperimentData(selectedSpecimens)
tic 

load specimenData.mat
numSpecimen = length(specimenData);
if nargin < 1
    selectedSpecimens = 1:numSpecimen;
end

exptDataDir = 'experimentData';
specimenDataDir = 'specimenData';

% Build Data
for iTest = selectedSpecimens
    specimenName = specimenData(iTest).specimen;
    fprintf('Building Experimental Data for Specimen %s\n',specimenName);
    
    % Clear existing .mat files from the experimental data directory
    delete(fullfile(exptDataDir,[specimenName '*.mat']));
    
    % Retreive Desired Channels
    channels = channelNames(iTest);
    numChannels = length(channels);
    
    % Read Data File
    filename = fullfile(exptDataDir,[specimenData(iTest).specimen '.dat']);
    [iData,iUnits] = readExptDataFile(filename);
    
    % Initilize Structures
    exptData = struct;
    exptDataUnits = struct; 
    
    % Store Time
    exptData.time = iData.time;
    exptDataUnits.time = '';    
    
    % Store Data
    for iChannel = 1:numChannels
        % Copy data
        assert(isfield(iData,channels{iChannel}),...
            'Header not in data: %s',channels{iChannel});
        exptData.(channels{iChannel}) = iData.(channels{iChannel});
        
        % Copy units
        assert(isfield(iUnits,channels{iChannel}),...
            'Header not in units: %s',channels{iChannel});
        exptDataUnits.(channels{iChannel}) = iUnits.(channels{iChannel});
    end
    
    % Convert to Consistent Units
    for iChannel = 1:numChannels
        channel = channels{iChannel};
        switch exptDataUnits.(channel)
            case {'inches','in','in.'}
                % No conversion necessary
                exptDataUnits.(channel) = 'in';
            case {'kip','kips'}
                % No conversion necessary
                exptDataUnits.(channel) = 'kip';
            case {'deg','degrees'}
                exptData.(channel) = convertUnits.angle(...
                    exptData.(channel),'deg','rad');
                exptDataUnits.(channel) = 'rad';
            case {'k-ft','kip-ft'}
                exptData.(channel) = convertUnits.moment(...
                    exptData.(channel),'kft','kin');
                exptDataUnits.(channel) = 'kin';
            case 'micro-e'
                exptData.(channel) = 10^6 * exptData.(channel);
                exptDataUnits.(channel) = 'in/in';
            otherwise
                error('Unknwon units: %s',exptDataUnits.(channel))
        end
    end
        
    
    % Save Data
    save(fullfile(exptDataDir,[specimenData(iTest).specimen '.mat']),...
        'exptData','exptDataUnits','-v7.3');

    exptDataAll = exptData;
            
    % Split Data Into Load Cases
    lcFilename = fullfile(specimenDataDir,specimenData(iTest).specimen,'LoadCases.csv');
    if exist(lcFilename,'file') ~= 2
        fprintf('  LoadCases.csv not found\n');
    else
        [~,lcData] = csvread2(lcFilename);
        
        for iLC = 1:length(lcData.Load_Case)
            Load_Case        = lcData.Load_Case{iLC};
            Start_Time_Stamp = lcData.Start_Time_Stamp{iLC};
            End_Time_Stamp   = lcData.End_Time_Stamp{iLC};
            
            Start_Ind = find(strcmp(Start_Time_Stamp,exptDataAll.time));
            End_Ind   = find(strcmp(End_Time_Stamp,exptDataAll.time));
            
            assert(isscalar(Start_Ind),'Could not find Start_Time_Stamp');
            assert(isscalar(End_Ind),'Could not find End_Time_Stamp');
            assert(Start_Ind < End_Ind,'Start_Ind greater than End_Ind');
            
            exptData = struct;
            for iChannel = 1:numChannels
                exptData.(channels{iChannel}) = ...
                    exptDataAll.(channels{iChannel})(Start_Ind:End_Ind);
            end
            
            save(fullfile(exptDataDir,[specimenData(iTest).specimen '-' Load_Case '.mat']),...
                'exptData','exptDataUnits','-v7.3');
        end       
    end
    
    % Limit Point Data
    lpFilename = fullfile(specimenDataDir,specimenData(iTest).specimen,'LimitPoints.csv');
    if exist(lpFilename,'file') ~= 2
        fprintf('  LimitPoints.csv not found\n');
    else
        [~,lpData] = csvread2(lpFilename);
        
        % Initilize data structure
        limitPoints = struct;
        for iChannel = 1:numChannels
            limitPoints.all.(channels{iChannel}) = zeros(0,1);
        end
        uniqueLoadCases = unique(lpData.Load_Case);
        for iLC = 1:length(uniqueLoadCases)
            limitPoints.(uniqueLoadCases{iLC}) = limitPoints.all;
        end
        
        % Compute limit point data
        for iLP = 1:length(lpData.Time_Stamp)    
            Time_Stamp  = lpData.Time_Stamp{iLP};
            Load_Case   = lpData.Load_Case{iLP};
            
            Ind = find(strcmp(Time_Stamp,exptDataAll.time));
            assert(isscalar(Ind),'Could not find Time_Stamp');
            
            for iChannel = 1:numChannels
                value = mean(exptDataAll.(channels{iChannel})(Ind+(-5:5)));
                limitPoints.all.(channels{iChannel}) = vertcat(...
                    limitPoints.all.(channels{iChannel}),value);
                limitPoints.(Load_Case).(channels{iChannel}) = vertcat(...
                    limitPoints.(Load_Case).(channels{iChannel}),value);
            end
        end 

        % Save Data
        save(fullfile(exptDataDir,[specimenData(iTest).specimen '-LimitPoints.mat']),...
            'limitPoints','exptDataUnits','-v7.3');
    end    
end

toc
end