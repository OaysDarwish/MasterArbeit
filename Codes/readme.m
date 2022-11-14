% readme.m explains the starting point and the main classes to use

%% Explanation of the folder and sub-folder structure
%calimoto
% folder for calimoto stuff: Skript to run necessary tests for a release of
% a new version of the crash algo

%crashDatabase
% stuff necessary to setup, fill, update and query crash database

%doc
% interface description of the crash algo, test documentations

%eBike
% git sub-module of the EB repository. This contains the actual crash
% algorithm (logfile importer, simulink models, etc.)

%MBCDlib
% deprecated

%MBCDlib_Android
% contains the Android library stuff of the MBCD-lib

%MBCDlib_iOS
% contains the iOS library stuff of the MBCD-lib

%mbikeCalibration
% contains everything needed for the motorbike calibration that replaces
% the EB (or cobi) calibration module

%unitTest
% contrains the framework that runs the unit tests of the generated c-code

%% Setting paths (these can be used also in a startup.m)

% path to git repo on local machine (must be run in script mode, not in
% cell mode!)
folderPath = fileparts(which(mfilename));

% path to the importer of csv-logfiles
addpath(fullfile(folderPath, 'eBike\Safety-Crash-Algorithm\matlabLogFileImporter'))

% path to the simulink model of the crash algorithm itself
addpath(fullfile(folderPath, 'eBike\Safety-Crash-Algorithm\simulinkModels'))

% path to the motorbike calibration module
addpath(fullfile(folderPath, 'mbikeCalibration'))

% path to the classes necessary for the crash database
addpath(fullfile(folderPath, 'crashDatabase\classes'))

%% reading logfiles

% create a logFile object with the DEKRA test:
% logFile = Cobi_CrashAlgo_Logfile('C:\Users\dao1wa2\Bosch Group\Connected Life - Pocketmode@HC\Messdaten\20220811_Hosentasch_FussAnAmpelRunter\IMU_logFile_mb_android_samsung-SM-G973F_lib1.1.2_crcl4.0003_mcal1.2005_2022-08-11T16-16-05.665+0200_v13.csv');
filePath = 'M:\20221019_Testversuche_LB\Szenario1_Durchlauf2_163200\Samsung_A5\Export\ExportIMU_logFile_mb_android_samsung-SM-A520F_lib1.2.0_crcl4.0003_mcal4.0009_2022-10-19T16-51-55.366+0200_v15_All - Copy.csv';
logFile = Cobi_CrashAlgo_Logfile(filePath);
% location of logfiles:

% Share Point:
% 'https://bosch.sharepoint.com/:f:/r/sites/msteams_1f1044/Shared%20Documents/Pocketmode@HC?csf=1&web=1&e=fc8k8o'

% EB:
% '\\bosch.com\dfsrb\DfsDE\LOC\Rt\EBI\02_ENG\01_ENG1\01_System\23_CrashDetection\01_MeasurementData\08_automaticSimulationMotorbikeData\01_allMotorbikeTestFiles'

% Connected Life:
% '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\050_DevelopmentData'

% Crash Database:
% '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\010_CrashDatabase'

%% simulating recorded data and visualize results

% copy the simulation data so the model can read it from workspace
data = logFile.getSimulationData;

% neue 
g = [-0.6 -0.23 0.79]'; r = [cross([1 0 0]', g), g]; r = [cross(r(:,1), r(:,2)), r];
alpha = pi/2; r=[cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]*r;
data.InitRotMatFromLogFile = r;
% calc exuction time from logfile 
% tEx = datetime(d.timeStampsStepExec,'ConvertFrom', 'epochtime','TimeZone','Etc/GMT');

% run the simulation
out = sim('CrashAlgo_TestEnvironment_Motorrad_v2');

% show the results in the Simulation Data Inspector
open('SDI_crashOverview.mldatx')
%% activities out of the logfiles

csvTable = readtable(filePath);
tableArray = table2array(csvTable);


% prepare activity data of the table

for iTable = 1:height(csvTable)
    rowi = tableArray(iTable,:);
    activiesdata = rowi(end-8:end-1);
    [maxVal,iMax] = max(activiesdata);
    % IDs:  inVehicle = 1;  onBicycle = 2;  onFoot = 3;     still = 4; 
    %       unknown = 5;    tilting = 6;    walking = 7;    running = 8;
    tableActivityID(iTable) = iMax;
    tableActivityValue(iTable) = maxVal;
    tableActivitySum(iTable) = sum(activiesdata);
end
activityId = tableActivityID;
activityId (tableActivityID == 1) = 2;
activityId (tableActivityID == 3) = 1;
activityId (tableActivityID == 7) = 1;
activityId (tableActivityID == 8) = 1;
activityId (tableActivityID == 4) = 0;
activityId (tableActivityID == 5) = -1;
activityId (tableActivityID == 6) = -1;

figure; plot(1:length(activityId), activityId, 1:length(activityId), tableActivityID, '-o'); legend('ID','tableID')
tout = out.tout;
% plot speed
figure; plot(tout, out.DU_speed_kmh); title('Speed out of sim')
figure; plot(csvTable.accCounter, out.DU_speed_kmh); title('Speed out of sim - AccCounterCSV')

% plot tableActivityID
figure; plot (csvTable.accCounter, tableActivityID); title('tableActivityID')

figure; plot (csvTable.accCounter, tableActivityValue); title('tableActivityValue')

figure; plot (csvTable.accCounter, tableActivitySum); title('tableActivitySum')

% plot android activities
accCounter = csvTable.accCounter - 70000;
figure;
plot(accCounter, csvTable.running, ...
    accCounter, csvTable.walking, ...
    accCounter, csvTable.unknown, ...
    accCounter, csvTable.tilting, ...
    accCounter, csvTable.onFoot, ...
    accCounter, csvTable.inVehicle, ...
    accCounter, csvTable.still, ...
    accCounter, csvTable.onBicycle,...
    accCounter, tableActivityID*10, '-o')
legend('running', 'walking', 'unknown', 'tilting', 'onFoot', 'inVehicle', 'still', 'onBicycle','tableActivityID')

% plot motionClass calculated out of the simulink
figure;
plot(csvTable.accCounter, out.MD_motionClass)


%% plot Gps accuracy - temp
% figure;
% % gps accuracy; critical value of accuracy (10); MD_motionClass; speed
% plot(data.t,data.logfile.gpsAccuracy, data.t, repmat(10,1,length(data.t)), ...
%     data.t, out.MD_motionClass*100, data.t,data.logfile.speed)
% title('gps Accuracy, MD_motionClass, speed')
% legend('gps Accuracy', '10' ,'motionClass', 'speed')




%% Crash Database stuff

% push new crash events to the crash database:
% first, download and extract new files from calimoto SFTP server and
% decrypt these. Then check that a new SO data export file is ready on the
% SharePoint

% create a database object
dbObj = HC_crashDatabase();
% read and export new events into the database
% dbObj.exportEventsToDB()
dbCon = dbObj.dbCon;
eventObj = HC_crashEvent(dbCon, 2806);
%
eventObj.plotOverview()
% 
eventObj.getDetailsFromDatabase();
eventObj.getLogfile();
data = eventObj.logFile.getSimulationData;
tic, eventObj.simulateEvent,toc



open('SDI_crashOverview.mldatx')

% query database and show the results
dbObj.queryDatabase('usageRatio',true);

%% Other important stuff:

% runs all tests and generates c code
runMBCDrelease

%% temp 

% figure; plot(out.yout{1}.Values.Time,out.yout{1}.Values.Data);
% ylim([-25 25]); title('Signal mit 5 Spizen pro Sekunde');
% 
% 
% figure; plot(out.yout{2}.Values.Time,out.yout{2}.Values.Data);
% title('Beispiel eines komplexen Signals mit ca. 16 Spitzen pro Sekunde');
% 
% spizen = out.yout{3}.Values.Data(end);


