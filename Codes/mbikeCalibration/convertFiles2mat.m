
%path = 'D:\Data\HelpConnect-CrashAlgo\Verifikationstests\01_allMotorbikeTestFiles\'
path = uigetdir(pwd, 'Select a folder');

files = dir(fullfile(path, '*.csv'));
% Display the names
%filesfiles.name

for i =1:numel(files)    
    files(i).name
    filepath = strcat(files(i).folder,'\',files(i).name);
    fprintf('Convert File %i/%i %s \n',i,numel(files),filepath);
    logFile  = Cobi_CrashAlgo_Logfile(filepath);
    data     = logFile.getSimulationData;
    filepath = strsplit(filepath,'.csv');
    filepath = string(strcat(filepath(1),'.mat'));
    save(filepath,'data');
    %Simulink.sdi.report('ReportOutputFolder','C:\temp','ShortenBlockPath',false)
end


%file = 'IMU_logFile_android_mb_Google-Pixel-3_crcl1.1941_mcal1.1414_2020-06-23T10-46-12.534+0200_v13.csv'

%filepath = strcat(path,file);
%logFile = Cobi_CrashAlgo_Logfile(filepath);
%data = logFile.getSimulationData;

%filepath = strsplit(filepath,'.csv');
%filepath = string(strcat(path(1),'.mat'));
%save(filepath,'data')