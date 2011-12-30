function [data,units] = readExptDataFile(filename)

% Open file
fid = fopen(filename);

% Read headers
headers = textscan(fgetl(fid),'%q','delimiter','\t');
funits  = textscan(fgetl(fid),'%q','delimiter','\t');
headers = headers{1};
headers = headers(2:end);
funits = funits{1};
funits = funits(2:end);
assert(isequal(size(funits),size(headers)),'Headers and units not the same size');

% Read data
numColumns = length(headers);
pattern = ['%q' repmat('%n',1,numColumns)];
frewind(fid);
C = textscan(fid,pattern,'delimiter','\t','CollectOutput',true,'HeaderLines',2);
time  = C{1};
ndata = C{2};

% Close file
fclose(fid);

% Sort data
data  = struct;
units = struct;
data.time  = time;
units.time = '';
for i = 1:numColumns
    data.(headers{i}) = ndata(:,i);
    units.(headers{i}) = funits{i};
end
        
end