%addpath('C:\Repositories\hc-crashdetection\eBike\Safety-Crash-Algorithm')
%addpath('C:\Repositories\hc-crashdetection\eBike\Safety-Crash-Algorithm\simulinkModels')
%p = genpath('C:\Repositories\hc-crashdetection\eBike\Safety-Crash-Algorithm')
%addpath(genpath('C:\Repositories\hc-crashdetection\eBike'));
%addpath('C:\Repositories\hc-crashdetection\mbikeCalibration')
%load('D:\Data\HelpConnect-CrashAlgo\Verifikationstests\01_allMotorbikeTestFiles\IMU_logFile_android_mb_Google-Pixel-3_crcl1.1941_mcal1.1414_2020-06-23T12-39-07.786+0200_v13.mat')




%% ************** Setting paths (these can be used also in a startup.m)

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



%% ****************** Load File:
% Pixel 3 -> 1.Testfahrt Nino mit verrutschen vom Handy:
% logFile = Cobi_CrashAlgo_Logfile('C:\Users\sot2fr\OneDrive - Robert Bosch GmbH\Pocketmode@HC\Messdaten\20220321\IMU_logFile_mb_android_Google-Pixel-3_lib1.1.1_crcl1.1973_mcal1.2005_2022-03-21T18-16-16.337+0100_v13.csv');

% Wunschdaten -> 2x gerade aus Fahrt, 1x Fahrt mit Smartphone drehen im Stand etc.
logFile = Cobi_CrashAlgo_Logfile('C:\Users\sot2fr\OneDrive - Robert Bosch GmbH\Pocketmode@HC\Messdaten\20220530_Wunschdaten\IMU_logFile_mb_android_HUAWEI-VOG-L29_lib1.1.1_crcl1.1973_mcal1.2005_2022-05-30T16-30-21.754+0200_v13.csv');
data = logFile.getSimulationData;


%% ************* open Simulink models:
%open('C:\Repositories\hc-crashdetection\mbikeCalibration\CrashAlgo_TestEnvironment_MotorradThorsten.slx')
%open('C:\Repositories\hc-crashdetection\mbikeCalibration\SDI_crashOverviewMotorbikeCalibrationThorsten.mldatx')


%% ****************** Process Algo
% run the simulation
%sim('CrashAlgo_TestEnvironment_Motorrad_v2')

% show the results in the Simulation Data Inspector
%open('SDI_crashOverview.mldatx')
