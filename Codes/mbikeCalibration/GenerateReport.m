
path = 'D:\Data\HelpConnect-CrashAlgo\Verifikationstests\01_allMotorbikeTestFiles\'
%path = uigetdir(pwd, 'Select a folder');

files = dir(fullfile(path, '*.mat'));
% Display the names
%filesfiles.name

model = 'CrashAlgo_TestEnvironment_MotorradThorsten.slx'; 
timestring = string(datetime('now','TimeZone','local','Format','dd-MMM-yy_HH-mm-ss'));
mkdir(path,timestring);
%Simulink.sdi.clear;

model_h = load_system(model)
%set_param(model_h,'FastRestart','on');

for i =1:numel(files)    
%for i =1:2    
    filepath = strcat(files(i).folder,'\',files(i).name);
    load(filepath);    
    sim(model);
    fprintf('Generate Report of File %i/%i: \n %s \n',i,numel(files),files(i).name);
    pause(1)
    reportName = filepath;
    filepath = strcat(files(i).folder,'\',timestring);
    RunIDs = Simulink.sdi.getAllRunIDs;
    Simulink.sdi.getRun(RunIDs(end));
    Simulink.sdi.save('temp.mldatx');
    pause(1)
    Simulink.sdi.clear;
    Simulink.sdi.load('temp.mldatx');
    pause(1)
    Simulink.sdi.report('ReportOutputFolder',filepath,'ReportOutputFile',strcat(files(i).name,'.html'),'LaunchReport',false);
    pause(1)
    %Search Replace Header to File Name
    filepath = strcat(files(i).folder,'\',timestring,'\',strcat(files(i).name,'.html'));
    fid  = fopen(filepath,'r');
    f=fread(fid,'*char')';
    fclose(fid);
    f = strrep(f,'Inspect Signals',files(i).name);
    f = eraseBetween(f,'<table class="SummaryTable">','</table>');
    pause(2)
    filepath = strcat(files(i).folder,'\',timestring,'\','\output.html');
    fid  = fopen(filepath,'a');
    fprintf(fid,'%s',f);
    fclose(fid);
end
set_param(model,'FastRestart','off');

%file = 'IMU_logFile_android_mb_Google-Pixel-3_crcl1.1941_mcal1.1414_2020-06-23T10-46-12.534+0200_v13.csv'

%filepath = strcat(path,file);
%logFile = Cobi_CrashAlgo_Logfile(filepath);
%data = logFile.getSimulationData;

%filepath = strsplit(filepath,'.csv');
%filepath = string(strcat(path(1),'.mat'));
%save(filepath,'data')