classdef Cobi_CrashAlgo_Logfile < handle
% %******************************************************************************
% %
% % (C) All rights reserved by BOSCH HEALTHCARE SOLUTIONS GMBH, WAIBLINGEN
% %
% %******************************************************************************
% %
% %    __   __   ___  ___
% %   /_ / /  / /__  /    /__/
% %  /__/ /__/ __ / /__  /  /
% %
% %
% %******************************************************************************
% % Administrative Information (automatically filled in)
% % 
% % @ Project: ${project_name}
% % @ File Name: Cobi_CrashAlgo_Logfile.m
% % @ URL: http://www.bosch-healthcare.com/
% % @ Author: Nino Haeberlen (BHCS/ENG5) <Nino.Haeberlen@de.bosch.com>
% % @ Date: 12.06.2019
% %
% % Commit-ID: $ID$
% %
% % -----------------------------------------------------------------------
% % DESCRIPTION:
% %  Class dealing with csv logfiles produced by Cobi crash algo
% %
% % -----------------------------------------------------------------------
% % -----------------------------------------------------------------------
% %
% %
% % Detailed information see:
% %
% %                         !!!<a href="matlab:open(fullfile(pwd, '\doc\html','Cobi_CrashAlgo_Logfile.html'))">Cobi_CrashAlgo_Logfile</a>!!!
% %
% %

% Properties
properties
    % path to log file
    filePath
    % software version of the log file
    logFileVersion
    % version of calibration module
    vCal
    % version of crash classification
    vCRCL
    % type of the operating system (android or iOS)
    osType
    % name of the app version
    appVersionName
    % bicycle or motorbike
    vehicleType
    %vehicle type: bicycle
    vtBicycle = 'bicycle';
    %vehicle type: motorbike
    vtMotorbike = 'motorbike';
    % content of the log file
    data
    % flag if logfile seems to be empty or corrupt
    logfileEmptyOrCorrupt
    % regressionFlag 
    regFlag
    %synchronization method of acc and gyro data arrays
    syncImu = false;    %change only in the object, do not push synImu=true to git Repo!!!
    % startSampleNum
    startSample = 1;
    %startSample = 1;
    % endSampleNum
    %endSampleDelta = 10;        %-> see IMU-logFile-iOS-2019-11-30T05_35_28_033+0100_crcl1.1832_coca1.1304_iPhone XS Max_v11.csv
    endSampleDelta = 0;
    deviceID
end

% Methods
methods
    function logFile        = Cobi_CrashAlgo_Logfile(varargin)
        % %% Cobi_CrashAlgo_Logfile (Constructor)
        % % Constructor of the class
        %
        % %% Syntax
        % %   logFile = Cobi_CrashAlgo_Logfile(filePath);
        %
        % %% Description
        % % creating a object of the class. The content of the file is NOT
        % % read in the moment of construction. Use 'getFileContent' for
        % % this.
        %
        % %% Input Arguments
        % %
        % %%
        % % |filePath|: character string giving the absolute path to the
        % % file. This argument is optional. If it is not given, a ui
        % % is opened  to let the user choose a file.
        % %%
        %
        % %% Output:
        % % |logFile| an object of class Cobi_CrashAlgo_Logfile
        %
        % %% Example:
        % %%
        % %    fileLocation1 = 'C:\data\testdata\cobi\2019-06-12-15-54_9000sensorlog_android_v4.csv';
        % %    logFile1 = Cobi_CrashAlgo_Logfile(fileLocation1)
        %
        % %% See also
        % % ...

        % check the optional input
        if nargin > 0
            filePath = varargin{1};

            varargin(1) = [];
            % check input parameter
            p = inputParser();
            p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
            p.addParameter('plot',true,@(x)isscalar(x) && islogical(x));
            p.parse(varargin{:})
            verbose = p.Results.verbose;
            plotFlag = p.Results.plot;
        else
            % if no file path is given show a dialog to the user
            %[fileName, pathName] = uigetfile({'.csv'},'select a csv-file','..\03_CobiData\');
            [fileName, pathName] = uigetfile({'.csv'},'select a csv-file','\\rt01fs23.DE.bosch.com\23_CrashDetection$\01_MeasurementData\07_automaticSimulationCobiSubset\01_allCobiTestFiles');
            filePath = fullfile(pathName, fileName);
            verbose = 5;
            plotFlag = true;
        end

        if filePath
            % a file can be read only if a file name was given
            logFile.filePath = filePath;
            logFile.getLogFileVersion();
            logFile.getOsType();
            logFile.getVehicleType();
            logFile.getFileContent();
            % when the logfile is not completely empty nor has NaNs in
            % the first 10 lines etc. do the regression test
            if logFile.logfileEmptyOrCorrupt == 0
                logFile.checkLogfilePlausibility('verb',verbose,'plot',plotFlag);
            end
        end
    end
    function logFileVersion      = getLogFileVersion(logFileObj)
        % get the version number from the file name, regexpi (-> case
        % insensitive)
        [~, filename, ~] = fileparts(logFileObj.filePath);
        vStr = regexpi(filename, '(?<=_v)\d+(\.\d)?','match');

        if ~isempty(vStr)
            logFileVersion =  str2double(vStr);
        else
            error(['Currently the version distinction has to be made '...
                'via the file name containing *_vX.csv with X being a '...
                'one ore more decimal digit verison number.'])
        end

        %workaround for Calimoto
        if logFileVersion == 1
            logFileVersion = 12.1;
        end

        % store the version in the property of the instance of the
        % class
        logFileObj.logFileVersion = logFileVersion;
    end

    function osType         = getOsType(logFileObj)
        % determine if the file was recorded with an Android or an iOS
        % device

        if ~isempty(regexp(logFileObj.filePath, 'android','once'))
            osType =  'android';
        elseif ~isempty(regexp(logFileObj.filePath, 'iOS','once'))
            osType = 'iOS';
        else
            osType = 'unknown';
        end
        % store the OS type in the property of the instance of the
        % class
        logFileObj.osType = osType;
    end

    function vehicleType = getVehicleType(logFileObj)
        % determine if the file was recorded with a motorbike or a
        % bicycle

        bMotorbike = ~isempty(regexp(logFileObj.filePath, '_mb_','once'));
        if bMotorbike
            vehicleType =  logFileObj.vtMotorbike;
        else
            vehicleType = logFileObj.vtBicycle;
        end
        % store the vehicleType in the property of the instance of the
        % class
        logFileObj.vehicleType = vehicleType;
    end


    function data           = getFileContent(logFileObj)
        % read the header line and the content of the csv file into a
        % table

        % check if data was already loaded
        if ~isempty(logFileObj.data)
            data = logFileObj.data;
            return
        end

        deltaToLastSample = logFileObj.endSampleDelta;

        %flag for compensation of speed influence onto pitch estimation
        %of kalman filter, turned off for bicycle use case
        data.longAccCompForEulerEstFlagFromWorkspace = int16(0);
        data.timeStampsRotMat = [];

        if logFileObj.logFileVersion >= 9
            [dataTmp, headerTmp, rotMatStates, rotMatTimes]  = logFileObj.readCobiCSV;

            if logFileObj.logfileEmptyOrCorrupt == 0
                if logFileObj.logFileVersion == 12.1 ...
                        || (logFileObj.logFileVersion >= 13 && ...
                        strcmp(logFileObj.vehicleType,logFileObj.vtMotorbike))
                    % calimoto Alphatest

                    %flag for compensation of speed influence onto pitch estimation
                    %of kalman filter, turned on for motorbike use case
                    %(stronger acceleration and deceleration influence 
                    %onto pitch estimation)
                    data.longAccCompForEulerEstFlagFromWorkspace = int16(1);

                    if logFileObj.logFileVersion == 12.1
                        % exec time was stored in ms instead of s
                        dataTmp.execStepTime = dataTmp.execStepTime*1e-3;
                        % time was stored in ns instead of s
                        dataTmp.accTime = dataTmp.accTime*1e-9; 
                        dataTmp.gyrTime = dataTmp.gyrTime*1e-9;
                    end

                    data.rotMatStates = rotMatStates;
                    data.timeStampsRotMat = rotMatTimes;
                    if isempty(rotMatStates)
                        data.InitRotMatFromLogFile = eye(3,3);
                    else
                        [~, iInitRotMatThisLogFile] = min(abs(dataTmp.execStepTime(1)-rotMatTimes));
                        data.InitRotMatFromLogFile = rotMatStates(:,:,iInitRotMatThisLogFile);
                    end

                    dataTmp.hubConnection = ones(size(dataTmp.hubConnection));
                end

                % in logFile v11 and before there was often the case that signals are
                % valid not from the first recorded sample. When the hub
                % connection was established, signals could be seen as
                % valid.
                if logFileObj.logFileVersion < 12
                    iMtAngle = find(dataTmp.mountingAngle, 1);
                    % some files don't have a mountingAngle so we use
                    % them from the beginning
                    if isempty(iMtAngle)
                        iMtAngle = 1;
                    end
                    iHubCon = find(dataTmp.hubConnection, 1);
                    % do some files really not have a HubConnection?
                    if isempty(iHubCon)
                        iHubCon = 1;
                    end
                    logFileObj.startSample = min(600, max(iHubCon, iMtAngle));
                    firstSample = logFileObj.startSample;
                else
                    firstSample = logFileObj.startSample;
                end

                data.AccSfX_mg = dataTmp.accX(firstSample:end-deltaToLastSample);
                data.AccSfY_mg = dataTmp.accY(firstSample:end-deltaToLastSample);
                data.AccSfZ_mg = dataTmp.accZ(firstSample:end-deltaToLastSample);

                % shift gyro signal if necessary
                bShiftGyro = logFileObj.syncImu;
                %bShiftGyro = true;
                %bShiftGyro = false;
                if bShiftGyro
                    [~, firstSampleGyro] = min(abs(dataTmp.gyrTime-dataTmp.accTime(firstSample)));
                    sampleShiftGyro = firstSampleGyro-firstSample;
                else
                    sampleShiftGyro = 0;
                end
                iGyro = (firstSample+sampleShiftGyro:length(dataTmp.gyrX)-deltaToLastSample+sampleShiftGyro)';
                data.GyrSfX_mdegs = interp1(dataTmp.gyrX, iGyro,'nearest',0);
                data.GyrSfY_mdegs = interp1(dataTmp.gyrY, iGyro,'nearest',0);
                data.GyrSfZ_mdegs = interp1(dataTmp.gyrZ, iGyro,'nearest',0);

                data.barometer_pa = dataTmp.pressure(firstSample:end-deltaToLastSample);

                data.accCounter = dataTmp.accCounter(firstSample:end-deltaToLastSample);
                data.gyrCounter = dataTmp.gyrCounter(firstSample:end-deltaToLastSample);

                data.speed_kmh = dataTmp.speed(firstSample:end-deltaToLastSample);

                % logfile version >= 11 accDu signals in mg
                data.DuAccX_mg = dataTmp.accDuX(firstSample:end-deltaToLastSample);            
                data.DuAccZ_mg = dataTmp.accDuZ(firstSample:end-deltaToLastSample);
                % some v9 files (cobiHubSetup == 1, i.e. Cobi v1)
                % contain NaNs in accDuX and accDuZ. So we set these to
                % zero, since they are anyway not needed (only needed
                % for cobiHubSetup == 2, i.e. SmartphoneHub).
                if headerTmp.cobiHubSetup ~= 2 && any(isnan(data.DuAccX_mg) | isnan(data.DuAccZ_mg))
                        data.DuAccX_mg = zeros(size(data.DuAccX_mg));
                        data.DuAccZ_mg = zeros(size(data.DuAccZ_mg));
                end
                
                data.timeStampsStepExec = dataTmp.execStepTime(1:end-deltaToLastSample);
                data.timeStampsStepExec(isnan(data.timeStampsStepExec)) = [];

                % start time vector after a few samples (e.g. 300) since at
                % the beginning time values might be 0
                if logFileObj.logFileVersion == 9.1
                    % time was stored in ns instead of s
                    dataTmp.accTime = dataTmp.accTime*1e-9;
                    dataTmp.gyrTime = dataTmp.gyrTime*1e-9;
                end

                %constant timeVectorIntervals as input breakpoints for simulink
                %lookuptables (deprecated since 7/22)
                data.timeVectorAcc = ((0:length(data.AccSfX_mg)-1)*0.01)';
                data.timeVectorGyr = ((0:length(data.AccSfX_mg)-1)*0.01)';

                %timeVector = timeStamps - timeStamps(1);

                data.hubConnection = dataTmp.hubConnection(firstSample:end-deltaToLastSample);
                data.mountingAngle = dataTmp.mountingAngle(firstSample:end-deltaToLastSample);
                data.manualCrashFire = dataTmp.manualCrashFire(firstSample:end-deltaToLastSample);
                data.crashFire = dataTmp.crashFire(firstSample:end-deltaToLastSample);
                data.crashClass = dataTmp.crashClass(firstSample:end-deltaToLastSample);            


                if strcmp(logFileObj.osType, 'iOs') || strcmp(logFileObj.osType, 'iOS')
                    data.osType = 1;
                elseif strcmp(logFileObj.osType, 'android')
                    data.osType = 2;
                else
                    data.osType = 0;
                end


                if logFileObj.logFileVersion >= 12
                    data.mountingSetup = headerTmp.mountingSetup*ones(length(data.crashFire),1);
                    % check if a header file is available and if the
                    % initMountingAngle is part of this header file.
                    % There were some v12 header files (e.g. January 2020: \\bosch.com\dfsrb\DfsDE\LOC\Rt\EBI\02_ENG\01_ENG1\01_System\23_CrashDetection\01_MeasurementData\01_ReutlingenTests\2020_01_23_GyroAnalysis\IMU_logFile_android_PRA-LX1_crcl1.1876_coca1.1315_2020-01-21T18_15_48.848+0100_v12.txt)
                    % where a header is present but initMountingAngle
                    % is not part of.
                    if isfield(headerTmp, 'initMountingAngle')
                        % when an angle is found in the header take
                        % this for the whole vector (only the first
                        % value is used in the simulation model)
                        if ~isnan(headerTmp.initMountingAngle) && headerTmp.initMountingAngle ~= 0
                            % take only the value from the headerfile
                            % if ~nan nor 0.0
                            data.mountingAngle = headerTmp.initMountingAngle*ones(length(data.crashFire),1);
                        end
                    else
                        % when no initMountingAngle can be found in the
                        % header (either no header available or no
                        % corresponding field in the header), do
                        % nothing (only the first value is used in the
                        % model).
                    end


                    data.cobiHubSetup = headerTmp.cobiHubSetup*ones(length(data.crashFire),1);
                    data.Header = headerTmp;
                    data.cadence_rpm = dataTmp.cadence(firstSample:end-deltaToLastSample);
                else
                    data.mountingSetup = dataTmp.mountingSetup(firstSample:end-deltaToLastSample);
                    data.manualSmartphoneLost = dataTmp.manualSmartphoneLost(firstSample:end-deltaToLastSample);
                    if logFileObj.logFileVersion >= 10
                        data.cobiHubSetup = dataTmp.CobiHubSetup(firstSample:end-deltaToLastSample);
                    else
                        data.cobiHubSetup = zeros(length(data.timeVectorAcc),1);
                    end
                    %for not calibrated datalogs, use mounting setup 2
                    data.mountingSetup = ones(length(data.crashFire),1)*2;
                    data.cadence_rpm = zeros(length(data.timeVectorAcc),1);
                    data.mountingAngle = ceil(abs(data.mountingAngle)).*sign(data.mountingAngle);
                end
            end
        else % logFileVersion < 9
            error('LogFiles with version < v9 are no longer supported.\n%s',logFileObj.filePath)

            logFileObj.startSample = 600;
            firstSampleOldV = logFileObj.startSample;
            % in version <v9 we have to distinguish betwen iOS and
            % android
            if  strcmp(logFileObj.osType, 'android')
                %% android                 
                if logFileObj.logFileVersion == 4
                    dataTmp = importfileCobiAndroid_v4(logFileObj.filePath);
                elseif logFileObj.logFileVersion == 5
                    dataTmp = importfileCobiAndroid_v5(logFileObj.filePath);
                    data.userFeedback = dataTmp.mark(firstSampleOldV:end-deltaToLastSample);
                else
                    error('For Android only v4,v5 and v9 are supported.')
                end
                dataTmp.AccX = dataTmp.accX;
                data.AccSfX_g = dataTmp.accX(firstSampleOldV:end-deltaToLastSample)./1000;
                data.AccSfY_g = dataTmp.accY(firstSampleOldV:end-deltaToLastSample)./1000;
                data.AccSfZ_g = dataTmp.accZ(firstSampleOldV:end-deltaToLastSample)./1000;

                data.GyrSfX_mdegs = dataTmp.gyroX(firstSampleOldV:end-deltaToLastSample);
                data.GyrSfY_mdegs = dataTmp.gyroY(firstSampleOldV:end-deltaToLastSample);
                data.GyrSfZ_mdegs = dataTmp.gyroZ(firstSampleOldV:end-deltaToLastSample);

                data.barometer_pa = dataTmp.pressure(firstSampleOldV:end-deltaToLastSample);

                data.accCounter = dataTmp.accCounter(firstSampleOldV:end-deltaToLastSample);
                data.gyrCounter = dataTmp.gyroCounter(firstSampleOldV:end-deltaToLastSample);

                data.speed_kmh = dataTmp.speed(firstSampleOldV:end-deltaToLastSample);

                data.timeStampsDebug = dataTmp.Time(firstSampleOldV:end-deltaToLastSample)./1000;
                data.timeVector = (0:length(data.AccSfX_g)-1)'*0.01;
                data.timeVectorAcc = (dataTmp.accTime(firstSampleOldV:end-deltaToLastSample)-dataTmp.accTime(firstSampleOldV))./10^9;
                data.timeVectorGyr = (dataTmp.gyroTime(firstSampleOldV:end-deltaToLastSample)-dataTmp.accTime(firstSampleOldV))./10^9;
                %timeVector = timeStamps - timeStamps(1);

                data.timeAccData = dataTmp.accTime(firstSampleOldV:end-deltaToLastSample);
                data.timeAccData = data.timeAccData-data.timeAccData(1);
                data.timeGyrData = dataTmp.gyroTime(firstSampleOldV:end-deltaToLastSample);
                data.timeGyrData = data.timeGyrData-data.timeGyrData(1);

                if ~isfield(data,'timeVector')
                    data.timeVector = (0:length(data.AccSfX_g)-1)'*0.01;
                end

                if ~isfield(data,'userFeedback')
                    data.userFeedback = zeros(length(data.AccSfX_g),1);
                end

                if ~isfield(data,'timeVectorAcc')
                    data.timeVectorAcc = (0:length(data.AccSfX_g))'*0.01;
                    data.timeVectorGyr = (0:length(data.AccSfX_g))'*0.01;
                end

                if ~isfield(data,'mountingAngle')
                    data.mountingAngle = zeros(length(data.AccSfX_g),1);
                end

                if ~isfield(data,'mountingSetup')
                    data.mountingSetup = zeros(length(data.AccSfX_g),1);
                end

                data.timeStampsStepExec = dataTmp.Time(1:end);

                if any(isnan(data.timeStampsStepExec))
                   data.timeStampsStepExec(isnan(data.timeStampsStepExec)) = [];
                end

                data.osType = 2;
                fprintf('logged time %g s\n', data.timeVectorAcc(end)/10^9);
                fprintf('samples/logged time %g Hz \n', 1/(mean(diff(data.timeVectorAcc)))*10^9);

            elseif strcmp(logFileObj.osType, 'iOS')
                if logFileObj.logFileVersion == 3
                    dataTmp = importfileCobi_v3(logFileObj.filePath);
                elseif logFileObj.logFileVersion == 4
                    dataTmp = importfileCobi_v4(logFileObj.filePath);
                    data.speed_kmh = dataTmp.speed(firstSampleOldV:end-deltaToLastSample);
                elseif logFileObj.logFileVersion == 5
                    dataTmp = importfileCobi_v5(logFileObj.filePath);
                    data.speed_kmh = dataTmp.speed(firstSampleOldV:end-deltaToLastSample);
                elseif logFileObj.logFileVersion == 6
                    dataTmp = importfileCobi_v6(logFileObj.filePath);
                    data.speed_kmh = dataTmp.speed(firstSampleOldV:end);
                elseif logFileObj.logFileVersion == 7
                    dataTmp = importfileCobi_v7(logFileObj.filePath);
                    data.speed_kmh = dataTmp.speed(firstSampleOldV:end-deltaToLastSample)./100;
                elseif logFileObj.logFileVersion == 8
                    dataTmp = importfileCobi_v8(logFileObj.filePath);
                    data.speed_kmh = dataTmp.speed(firstSampleOldV:end-deltaToLastSample)./100;
                    data.accCounter = dataTmp.counter(firstSampleOldV:end-deltaToLastSample);
                    data.gyrCounter = dataTmp.gyroCounter(firstSampleOldV:end-deltaToLastSample);
                    data.mountingSetup = dataTmp.setup(firstSampleOldV:end-deltaToLastSample);
                    data.mountingAngle = dataTmp.angleDeg(firstSampleOldV:end-deltaToLastSample);
                    data.timeVectorAcc = dataTmp.accTime(firstSampleOldV:end-deltaToLastSample)-dataTmp.accTime(firstSampleOldV);
                    for i=2:length(data.timeVectorAcc)
                        if data.timeVectorAcc(i) - data.timeVectorAcc(i-1) < 0
                            data.timeVectorAcc(i) = data.timeVectorAcc(i-1)+0.001;
                        elseif abs(data.timeVectorAcc(i) - data.timeVectorAcc(i-1)) >= 10
                            data.timeVectorAcc(i) = data.timeVectorAcc(i-1)+0.001;
                        end
                    end
                    data.timeVectorGyr = dataTmp.gyroTime(firstSampleOldV:end-deltaToLastSample)-dataTmp.accTime(firstSampleOldV);
                    for i=2:length(data.timeVectorGyr)
                        if data.timeVectorGyr(i) - data.timeVectorGyr(i-1) < 0
                            data.timeVectorGyr(i) = data.timeVectorGyr(i-1)+0.001;
                        elseif abs(data.timeVectorGyr(i) - data.timeVectorGyr(i-1)) >= 10
                            data.timeVectorGyr(i) = data.timeVectorGyr(i-1)+0.001;
                        end
                    end
                else
                    data.speed_kmh = [];
                end

                data.AccSfX_mg = dataTmp.AccX(firstSampleOldV:end-deltaToLastSample)*1000;
                data.AccSfY_mg = dataTmp.Y(firstSampleOldV:end-deltaToLastSample)*1000;
                data.AccSfZ_mg = dataTmp.Z(firstSampleOldV:end-deltaToLastSample)*1000;

                data.GyrSfX_mdegs = dataTmp.Gyrx(firstSampleOldV:end-deltaToLastSample).*(1000 * 180/pi);
                data.GyrSfY_mdegs = dataTmp.y(firstSampleOldV:end-deltaToLastSample).*(1000 * 180/pi);
                data.GyrSfZ_mdegs = dataTmp.z(firstSampleOldV:end-deltaToLastSample).*(1000 * 180/pi);

                data.barometer_pa = dataTmp.pressure(firstSampleOldV:end-deltaToLastSample);

%                 if logfileVersion >= 4
%                     if contains(PathName,'CobiAppIOS')
%                         speed_kmh = data.speed(startSample:end);
%                         if barometer_pa(end-100) > 85000 && barometer_pa(end-100) < 120000
%                         else
%                             barometer_pa = barometer_pa * 100;
%                         end
%                     elseif contains(PathName,'CoreMotion')
%                         speed_kmh = data.speed(startSample:end)./100;
%                         barometer_pa = barometer_pa * 1000;
%                     end
% %                     if logfileVersion == 6
% %                         timeVector = 
% %                     else
% %                     end
%                 else
%                     speed_kmh = zeros(length(AccSfX_g),1);
%                 end

                if data.barometer_pa(round(end/2)) < 50000
                    data.barometer_pa = data.barometer_pa *1000;
                end

                if ~isfield(dataTmp,'mountingAngle')
                    data.DuAccX_mg = zeros(length(data.AccSfX_mg),1);
                    data.DuAccZ_mg = zeros(length(data.AccSfX_mg),1);
                end

                if ~isfield(dataTmp,'cadence')
                    data.cadence_rpm = zeros(length(data.AccSfX_mg),1);
                end

                if ~isfield(dataTmp,'hubConnection')
                    data.hubConnection = ones(length(data.AccSfX_mg),1);
                end

                if ~isfield(dataTmp,'crashClass')
                    data.crashClass = zeros(length(data.AccSfX_mg),1);
                end

                if ~isfield(dataTmp,'CobiHubSetup')
                    data.cobiHubSetup = zeros(length(data.AccSfX_mg),1);
                end

                if ~isfield(dataTmp,'mountingAngle')
                    data.mountingAngle = zeros(length(data.AccSfX_mg),1);
                    data.mountingSetup = 2*ones(length(data.AccSfX_mg),1);
                end

                data.timeStampsStepExec = dataTmp.Time(1:end);



                if any(isnan(data.timeStampsStepExec))
                   data.timeStampsStepExec(isnan(data.timeStampsStepExec)) = [];
                end

                if ~isfield(data,'timeVector')
                    data.timeVector = (0:length(data.AccSfX_mg)-1)'*0.01;
                end

                data.timeAccData = dataTmp.accTime(firstSampleOldV:end-deltaToLastSample);
                data.timeAccData = data.timeAccData-data.timeAccData(1);
                data.timeGyrData = dataTmp.gyroTime(firstSampleOldV:end-deltaToLastSample);
                data.timeGyrData = data.timeGyrData-data.timeGyrData(1);

                if ~isfield(data,'timeVectorAcc')
                    data.timeVectorAcc = (0:length(data.AccSfX_mg)-1)'*0.01;
                    data.timeVectorGyr = (0:length(data.AccSfX_mg)-1)'*0.01;
                    %data.timeVectorAcc = data.timeAccData;
                    %data.timeVectorGyr = data.timeGyrData;
                end

                data.osType = 1;
                fprintf('logged time %g s\n', data.timeVectorAcc(end));
                fprintf('samples/logged time %g Hz \n', 1/mean(diff(data.timeVectorAcc)));
            else
                error('Only android and iOS are supported.')
            end
        end


        data.logfile = dataTmp;
        logFileObj.data = data;

    end

    function [logfile, logfileHeader, allLoggedRotMats, tRotMats] = readCobiCSV(logFileObj)
        logError = 0;
        % code comes mainly from matlab auto generated code
        allLoggedRotMats = [];    
        tRotMats = [];
        if logFileObj.logFileVersion >= 12

            %% Setup the Import Options
            %motorbike logfiles have rotationMatrix at the top of the
            %csv logfile
            if strcmp(logFileObj.vehicleType,logFileObj.vtMotorbike) 
                %open file with scanf() or textscan() because
                %readTable(), etc. removes first rotMat lines
                %automatically...
                fileId = fopen(logFileObj.filePath);
                fileCont = textscan(fileId, ':Time=%f;RotationMatrix=[%f, %f, %f, %f, %f, %f, %f, %f, %f]');
                fclose(fileId);
                % rotMat was stored in column-major format -> no transposition
                % https://de.mathworks.com/help/rtw/ug/code-generation-of-matrix-data-and-arrays.html
                allLoggedRotMats = reshape([fileCont{2:10}]', 3, 3, length(fileCont{1}));
                tRotMats = [fileCont{1}];
                numLinesHeaderCsv = length(allLoggedRotMats)+2; 
            else
                numLinesHeaderCsv = 2;
            end

            dataLines = [numLinesHeaderCsv, Inf];
            opts = delimitedTextImportOptions("NumVariables", 36);

            % Specify range and delimiter
            opts.DataLines = dataLines;
            opts.Delimiter = ";";

            % Specify column names and types
            opts.VariableNames = ["execStepTime", "accCounter", "accTime", "accX", "accY", "accZ", "gyrCounter", "gyrTime", "gyrX", "gyrY", "gyrZ", "speed", "cadence", "assistMode", "accDuX", "accDuZ", "pressure", "smartphoneAtmPressure", "hubConnection", "mountingAngle", "manualCrashFire", "crashFire", "crashClass", "rollDeg", "pitchDeg", "tipOverFeature", "groundHitFeature", "collisionFeature", "rideFeature", "standFeature", "riderlessRollOverFeature", "smartphoneDropOutFeature", "userCrashFeedback", "gpsLat", "gpsLong", "gpsAccuracy"];
            opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
            opts = setvaropts(opts, 36, "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
        else
            dataLines = [2, Inf];
            % Setup the Import Options
            dTypeHubConn = 'double';
            if logFileObj.logFileVersion >= 10
                N = 24;
            else
                N = 23;
                if logFileObj.logFileVersion == 9.1
                    dTypeHubConn = 'char';
                end
            end
            opts = delimitedTextImportOptions("NumVariables", N);

            % Specify range and delimiter
            opts.DataLines = dataLines;
            opts.Delimiter = ";";

            % Specify column names and types
            opts.VariableNames = ["execStepTime", "accCounter", "accTime", ...
                "accX", "accY", "accZ", ...
                "gyrCounter", "gyrTime", ...
                "gyrX", "gyrY", "gyrZ", ...
                "speed", "accDuX", "accDuZ", ...
                "pressure", "hubConnection", ... hubConnection in v9.1 is char ('true', 'false')
                "mountingAngle", "mountingSetup", ...
                "manualCrashFire", "crashFire", "crashClass", ...
                "manualSmartphoneLost", "ueberfluessig"];
            opts.VariableTypes = ["double", "double", "double", ...
                "double", "double", "double", ...
                "double", "double", ...
                "double", "double", "double", ...
                "double", "double", "double", ...
                "double", dTypeHubConn, ... hubConnection in v9.1 is char ('true', 'false')
                "double", "double", ...
                "double", "double", "double", ...
                "double", "string"];
            % in v10 the field CobiHubSetup was added
            if logFileObj.logFileVersion >= 10
                opts.VariableNames = [opts.VariableNames(1:15), ...
                    "CobiHubSetup", opts.VariableNames(16:end)];
                opts.VariableTypes{end} = 'string'; 
                opts.VariableTypes{end-1} = 'double'; 
            end

            if logFileObj.logFileVersion >= 11
                opts.VariableNames{end} = 'userCrashFeedback';
                opts.VariableTypes{end} = 'double'; 
            end


            %opts = setvaropts(opts, N, "WhitespaceRule", "preserve");
            opts = setvaropts(opts, N, "EmptyFieldRule", "auto");
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
        end

        % read the info from the header file
        logfileHeader = logFileObj.readHeaderFile();

        % Import the data
        logfile = readtable(logFileObj.filePath, opts);

        if logFileObj.logFileVersion == 9.1
            % in v9.1 hubConnection was stored as 'true'/'false'
            % instead of 1/0 ((e.g.
            % \\rt01fs23.DE.bosch.com\23_CrashDetection$\01_MeasurementData\07_automaticSimulationCobiSubset\01_allCobiTestFiles\100.1_18kmh_Trek_android-2019-09-11T15_22_22.584+0200_crcl1.1563_coca1.13_SM-G950F_v9.1.csv)
            hubConChar = logfile.hubConnection;
            logfile.hubConnection = zeros(size(hubConChar));
            logfile.hubConnection(logical(~cellfun(@(x) isempty(regexp(x, 'true', 'once')), hubConChar))) = 1;

        end

        %check logfile

        % check for invalid data in the first 10 ACC samples
        if height(logfile) == 0 || any(isnan(logfile.accX(1:10)))
            logError = 1;
        else
            %remove last lines of logfile (due to corruption -> nans)
            iNan = find(isnan(logfile.accZ), 1);
            % make sure that no more than 10 samples at the end are corrupt
            if ~isempty(iNan)
                if height(logfile)-iNan < 50
                    logfile(iNan:end,:) = [];
                else
                    logError = 1;
                end
            end
        end
        
        % check for NaNs in speed signal
        bNaN = isnan(logfile.speed);
        if sum(bNaN) < 10
            % 10 NaNs in the whole file can be considered as ok; set these anyway to zero.
            logfile.speed(bNaN) = 0;
        else
            logError = 1;
        end

        logFileObj.logfileEmptyOrCorrupt = logError;

    end

    function logfileHeader = readHeaderFile(logFileObj)
        % Setup the Import Options for LogFileHeader
            dataLinesHeader = [1, Inf];
            optsHeader = delimitedTextImportOptions("NumVariables", 2);

            % Specify range and delimiter
            optsHeader.DataLines = dataLinesHeader;
            optsHeader.Delimiter = ":";

            % Specify column names and types
            optsHeader.VariableNames = ["key", "value"];
            optsHeader.VariableTypes = ["string", "string"];
            optsHeader = setvaropts(optsHeader, 1, "WhitespaceRule", "preserve");
            optsHeader = setvaropts(optsHeader, 1, "EmptyFieldRule", "auto");
            optsHeader.ExtraColumnsRule = "ignore";
            optsHeader.EmptyLineRule = "read";

            % Import data from Header
            [filepathHeader,nameHeader,~] = fileparts(logFileObj.filePath);
            filenameHeader = fullfile(filepathHeader,strcat(nameHeader,'.txt'));

            if logFileObj.logFileVersion >= 12 && ...
                    logFileObj.logFileVersion ~= 12.1  && ...
                    logFileObj.logFileVersion ~= 13 && ...
                    ~strcmp(logFileObj.vehicleType,logFileObj.vtMotorbike)
                % normal case for bicycle and logFile v >=12

                % read the header to a table
                logfileHeaderTab = readtable(filenameHeader, optsHeader);
                % Field names must apply to the rules.
                key = cellfun(@(x) {strrep(x, '-', '_')}, logfileHeaderTab.key);
                value = cellstr(logfileHeaderTab.value);
                % convert the header to a struct: every line is a
                % field.
                logfileHeader = cell2struct(value, key);
                % convert numeric fields to numbers. To avoid errors
                % when a field is not available in a certain version,
                % use intersect here.
                fnames = intersect(key, {'timeStamp', 'mountingSetup', ...
                    'initMountingAngle', 'cobiHubSetup', ...
                    'temperature', 'age', 'coca', 'crcl'});
                for i=1:length(fnames)
                    logfileHeader.(fnames{i}) = str2double(logfileHeader.(fnames{i})); 
                end
            else
                % workaround for Calimoto
                logfileHeader.mountingSetup = -1; % mounting setup
                logfileHeader.initMountingAngle = -1; % init mounting angle
                logfileHeader.cobiHubSetup = 1;
            end

            % get the version of calibration (COCA) and crash
            % classification (CRCL)
            if logFileObj.logFileVersion >= 14

                % read versions from header file
                if isfield(logfileHeader,'crcl') 
                    %some v14 android logs did not have the algo version in the header included!
                    % this was caused by some development app versions
                    % (probably only existing in less than 10 files)
                    logFileObj.vCal = logfileHeader.coca;
                    logFileObj.vCRCL = logfileHeader.crcl;
                else
                    logFileObj.vCal = 'unknown'; %-> unknown (should be a number, not a string!)
                    logFileObj.vCRCL = 'unknown'; %-> unknown (should be a number, not a string!)
                end

                % get the build name of the app: look in e.g.
                % 'IMU_logFile_iOS_iPhone 11_1.17.2-alpha2_2021-01-05T16_11_44_340+0200_v14.csv'
                % for '1.17.2-alpha2'
                logFileObj.appVersionName = regexp(logFileObj.filePath, ...
                    '\d+\.\d+\.\d+-\w+(?=_\d{4})','match','once');
            else
                % read versions from file name
                logFileObj.vCRCL = str2double(regexp(logFileObj.filePath, ...
                    '(?<=crcl)\d\.\d*', 'match','once'));
                logFileObj.vCal = str2double(regexp(logFileObj.filePath, ...
                    '(?<=(mcal|coca))\d\.\d*', 'match','once'));

                % in this log file versions the build name of the app
                % was not yet available
                logFileObj.appVersionName = 'unknown';
            end
            if ~strcmp(logFileObj.vehicleType,logFileObj.vtMotorbike) ...
                    && logFileObj.logFileVersion >= 12
                logFileObj.deviceID = value{contains(key,'deviceID')};
            else
                logFileObj.deviceID = '';
            end
    end

    function plotRawData(logFileObj, varargin)
        % display all the raw data in some plots and command line info
        % text

        % check input parameter
        p = inputParser();
        p.addParameter('plot',true,@(x)isscalar(x) && islogical(x));
        p.parse(varargin{:})

        % shall the plots be visible or are they just checked as
        % regression test?
        if p.Results.plot
            vis = 'on';
        else
            vis = 'off';
        end

        plotData = logFileObj.getFileContent();

        hf(1) = figure('visible', vis);
        ax1 = subplot(4,1,1);

        plot(plotData.logfile.gyrTime-plotData.logfile.gyrTime(1));
        hold on
        plot(plotData.logfile.accTime-plotData.logfile.accTime(1));
        plot(plotData.logfile.gyrTime-plotData.logfile.accTime);
        grid on
        ylabel('time / s')
        xlabel('samples / -')
        title('sensor sampling time')
        legend('gyro','acc','diff');
        axis([0 length(plotData.timeVectorAcc) 0 inf])

        ax2 = subplot(4,1,2);
        if length(plotData.timeStampsStepExec) >= length(plotData.timeVectorAcc)
            plot(diff(plotData.logfile.execStepTime));
        else
            plot((0:length(plotData.logfile.execStepTime)-2)'.*100+1,diff(plotData.logfile.execStepTime));
        end
        grid on
        title('time diff between execution of step function')
        xlabel('samples')
        ylabel('time / s')
        axis([0 length(plotData.timeVectorAcc) 0 inf])

        ax3 = subplot(4,1,3);
        [nAcc,~] = histcounts(plotData.accCounter,0:length(plotData.accCounter));
        plot(nAcc);
        hold on;
        [nGyro,~] = histcounts(plotData.gyrCounter,0:length(plotData.gyrCounter));
        plot(nGyro);
        grid on
        legend('acc','gyro');
        title('step iterations without update of sensor imu data')
        xlabel('sample / -')
        ylabel('number of step iterations per sample')
        axis([0 length(plotData.timeVectorAcc) 0 10])

        ax4 = subplot(4,1,4);
        plot(diff(plotData.timeVectorGyr),'.');
        hold on;
        plot(diff(plotData.timeVectorAcc),'.');
        grid on;

        legend('gyro','acc');
        title('time diff IMU sampling')
        xlabel('sample / -')
        if logFileObj.logFileVersion >= 9
            ylabel('time / s')
        elseif plotData.osType == 1
            ylabel('time / s')
        elseif plotData.osType == 2
            ylabel('time / ns')
        end

        %axis([0 inf -0 0.2])
        %axis([0 length(data.accTime) -1.5 1.5])

        linkaxes([ax1,ax2,ax3,ax4], 'x');

        hf(2) = figure('visible', vis);
        bx1 = subplot(3,1,1);
        %plot(plotData.timeVectorAcc,plotData.AccSfX_g);
        plot(plotData.timeVectorAcc, plotData.AccSfX_mg);
        title('AccSfX');
        grid on;

        bx2 = subplot(3,1,2);
        %plot(plotData.timeVectorAcc,plotData.speed_kmh)
        plot(plotData.timeVectorAcc, plotData.speed_kmh)
        title('speed');
        grid on;

        bx3 = subplot(3,1,3);
        %plot(plotData.timeVectorAcc,plotData.speed_kmh)
        plot(plotData.timeVectorAcc, plotData.GyrSfX_mdegs)
        hold on;
        plot(plotData.timeVectorAcc, plotData.GyrSfY_mdegs)
        plot(plotData.timeVectorAcc, plotData.GyrSfZ_mdegs)
        xlabel('t / s');
        title('gyroSf');
        grid on;

        linkaxes([bx1,bx2, bx3], 'x');

        % acceleration and angular rates over time / s
        hf(3) = figure('visible', vis);
        cx1 = subplot(2,1,1);
        plot(plotData.timeVectorAcc, plotData.AccSfX_mg);
        hold on
        plot(plotData.timeVectorAcc, plotData.AccSfY_mg);
        plot(plotData.timeVectorAcc, plotData.AccSfZ_mg);
        grid on
        title('acc');
        xlabel('t / s');

        cx2 = subplot(2,1,2);
        plot(plotData.timeVectorGyr, plotData.GyrSfX_mdegs);
        hold on
        plot(plotData.timeVectorGyr, plotData.GyrSfY_mdegs);
        plot(plotData.timeVectorGyr, plotData.GyrSfZ_mdegs);
        grid on
        title('gyro');
        xlabel('t [s]');

        linkaxes([cx1,cx2], 'x');

        % raw data
        hf(4) = figure('visible', vis);
        ex1 = subplot(2,1,1);
        plot(plotData.logfile.accTime, plotData.logfile.accX);
        hold on
        plot(plotData.logfile.accTime, plotData.logfile.accY);
        plot(plotData.logfile.accTime, plotData.logfile.accZ);
        grid on
        title('acc direct import of logfile');
        xlabel('time / s');
        ylabel('acc / mg');

        ex2 = subplot(2,1,2);
        plot(plotData.logfile.gyrTime, plotData.logfile.gyrX);
        hold on
        plot(plotData.logfile.gyrTime, plotData.logfile.gyrY);
        plot(plotData.logfile.gyrTime, plotData.logfile.gyrZ);
        grid on
        title('gyro direct import of logfile');
        xlabel('time / s');
        ylabel('rotational rate / mdeg/s');

        linkaxes([ex1,ex2], 'x');

        % if figures were created invisibly, close them.
        if ~p.Results.plot
            for j=1:4; close(hf(j)); end
        end
    end

    function simulationData = getSimulationData(logFileObj)
        % get data for simulation environment

        %evalin('base','clearvars -except proj ans')

        %assignin('base','datasource', 7);
        %assignin('base','numSamples', 7);
        %assignin('base','numSamplesShortTerm', 5);

        % add paths for simulation environment
%             baseVariables = evalin('base','whos'); %or 'base'
%             doesExist = ismember('proj',{baseVariables(:).name});
%             gitSim = ismember('git_dir_simulation',{baseVariables(:).name});
%             %gitSim = evalin('base', 'git_dir_simulation');
%             %if ~(exist('proj') && strcmp(proj.Name,'MATLAB_BDU3XX'))
%             
%             [~,computername] = dos('ECHO %COMPUTERNAME%');
%             if ~doesExist && strcmp(strcat(computername),'RT-Z0HDW') && ~gitSim
%                 projTmp = simulinkproject('D:\SVN\BDU4xx_1.0.0.0_MagGyrAccMeasure\');
%                 assignin('base','proj',projTmp);
%                 cd('L:\EBI\02_ENG\01_ENG1\10_UserOffice\Schnee\04_Algos\05_CrashAlgo\01_model\');
%                 addpath('D:\SVN\BDU4xx_1.0.0.0_MagGyrAccMeasure\04_SW\DriveUnit\ApplicationLayer\CrashClassification\Mdl\');
%             end

        simulationData = logFileObj.getFileContent();

        % convert corresponding fields to timetables
        fnames = {'AccSfX_mg', 'AccSfY_mg', 'AccSfZ_mg', ...
            'GyrSfX_mdegs', 'GyrSfY_mdegs', 'GyrSfZ_mdegs', ...
            'speed_kmh', 'barometer_pa','crashClass',...
            ... Cobi signals
            'hubConnection','DuAccX_mg','DuAccZ_mg','cadence_rpm'};
        for i=1:length(fnames)
            simulationData.(fnames{i})=timetable(simulationData.(fnames{i}), 'SampleRate', 100, 'VariableNames', fnames(i));
        end
        % set constants
        % test: cobiHubSetup (v9, v10, v12), mountingAngle, mountingSetup
        simulationData.cobiHubSetup = simulationData.cobiHubSetup(1);
        simulationData.mountingAngle = simulationData.mountingAngle(1);
        simulationData.mountingSetup = simulationData.mountingSetup(1);
        simulationData.t = simulationData.AccSfX_mg.Time;
    end

    function [errorFlag, errorMsg] = checkLogfilePlausibility(logFileObj,varargin)
    %%
    % %% regressionTest
    % % regression test of class Cobi_CrashAlgo_Logfile
    %
    % %% Syntax
    % %   logFile = Cobi_CrashAlgo_Logfile(filePath);
    %
    % %% Description
    % % The regression test should be run every time the Cobi App is
    % % updated and new measurement files are created. It checks for some
    % % issues and for plausibility.
    %
    % %% Input Arguments
    % %
    % %%
    % % |-|: -
    % %%
    %
    % %% Output:
    % % |errorFlag| indicated if an error occurred
    % %
    % % |errorMsg| gives information about the errorFlag
    %
    % %% Example:
    % %%
    % %    logFile = Cobi_CrashAlgo_Logfile('\\bosch.com\dfsrb\DfsDE\LOC\Rt\EBI\02_ENG\01_ENG1\01_System\23_CrashDetection\01_MeasurementData\2019_10_23_WiegetrittStoppie\IMU-logFile-iOS-2019-10-23T15_23_55_929+0200_crcl1.175_coca1.1304_iPhone 7_v11.csv')
    %
    % %% See also
    % % Cobi_CrashAlgo_Logfile

        % check input parameter
        p = inputParser();
        p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
        p.addParameter('plot',true,@(x)isscalar(x) && islogical(x));
        p.parse(varargin{:})
        verbose = p.Results.verbose;

        errorFlag = false;
        errorMsg = {};

        % software version is no more checked from 7/2022 on since this
        % check is very deprecated (introduced in 9/2019 due to cobi app
        % integration problems, ask Eric or Nils :) )
%         [efSW, em] = logFileObj.checkSWVersion('verb',verbose);
%         errorFlag = errorFlag | efSW;
%         errorMsg = [errorMsg, em];

        [efPlaus, em] = logFileObj.checkPlausSensorData('plot',p.Results.plot,'verb',verbose);
        errorFlag = errorFlag | efPlaus;
        errorMsg = [errorMsg, em];

        [efTiming, em] = logFileObj.checkSampleTiming('plot',p.Results.plot,'verb',verbose);
        errorMsg = [errorMsg, em];
        errorFlag = errorFlag | efTiming;

%             % print error messages as warnings
%             for i=1:length(errorMsg)
%                 verb(verbose,4,errorMsg{i})
%             end
    end

    function [errorFlag, errorMsg] = checkSWVersion(logFileObj,varargin)

        % check input parameter
        p = inputParser();
        p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
        p.parse(varargin{:})
        verbose = p.Results.verbose;

        errorFlag = false;
        errorMsg = {};

%TODO: change the check for calibration and CRCL version check it only if
%the measurement file is more recent than 2 weeks ago.

        % check for CRCL (Crash algo): which is the current SW version
        % of the c version of the algo? A recent measurement file
        % should show this lates version in the file name.
        dircontent = dir(fullfile(mfilename('fullpath'), '../../GeneratedCrashAlgo/CRCL.c'));
        fid = fopen(fullfile(dircontent.folder, dircontent.name));
        fcontent = fscanf(fid, '%c');
        fclose(fid);
        % get the CRCL version number out of the generated C file (e.g.
        % ' * Model version                        : 4.0013' or 
        % ' * Model version                        : 1.2'    or
        % ' * Model version                        : 1.1973'
        currentCRCL = str2double(regexp(fcontent, ...
            '(?<=crashAlgoVersion \= )\d\.\d{1,4}(?=F)', 'match','once'));
        if ~(currentCRCL == logFileObj.vCRCL)
            errorFlag = true;
            errorMsg{end+1} = sprintf('CRCL don''t match. Current CRCL: %.4f. Logged CRCL: %.4f', ...
                currentCRCL, logFileObj.vCRCL);
        % print error messages as warnings
            verb(verbose,5,errorMsg{end})
        end

        % check for COCA (Cobi calibration): which is the current SW
        % version of the c version of the calibration module? A recent
        % measurement file should show this lates version in the file
        % name.
        switch logFileObj.vehicleType
            case logFileObj.vtBicycle
                dircontent = dir(fullfile(mfilename('fullpath'), '../../Calibration/CobiCalibration.c'));
                calText = 'calibrationAlgoVersion';
            case logFileObj.vtMotorbike
                dircontent = dir(fullfile(mfilename('fullpath'), '../../../../mbikeCalibration/CalibrationMotorbike_v2/CalibrationMotorbike_v2.c'));
                calText = 'calibrationModuleVersion';
            otherwise
                error(['Vehicle type ''%s'' is not supported. Only ', ...
                    logFileObj.vtBicycle, ' or ', ...
                    logFileObj.vtMotorbike, ' are allowed.'], ...
                    logFileObj.vehicleType);
        end

        if ~isempty(dircontent)
            fid = fopen(fullfile(dircontent.folder, dircontent.name));
            fcontent = fscanf(fid, '%c');
            fclose(fid);
            % get the CAL version number out of the generated C file
            currentCal = str2double(regexp(fcontent, ...
                ['(?<=' calText ' \= )\d\.\d{1,4}(?=F)'], 'match','once'));
        else
            % when the calibration version can't be determined (e.g.
            % the framework is running at EB but the calibration
            % version of mbike is needed) a dummy version number is set
            % here
            currentCal = -1;
        end

        if ~(currentCal == logFileObj.vCal)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Calibration doesn''t match. Current Cal: %.4f. Logged Cal: %.4f', ...
                currentCal, logFileObj.vCal);
            % print error messages as warnings
            verb(verbose,5,errorMsg{end})
        end
    end

    function [errorFlag, errorMsg] = checkPlausSensorData(logFileObj,varargin)

        % check input parameter
        p = inputParser();
        p.addParameter('plot',true,@(x)isscalar(x) && islogical(x));
        p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
        p.parse(varargin{:})

        plotFlag = p.Results.plot;
        verbose = p.Results.verbose;

        errorFlag = false;
        errorMsg = {};

        d = logFileObj.data;

        % check acc range
        maxRangeAcc = 16; % g

        if ~ (-maxRangeAcc-1 <= min(d.AccSfX_mg*1e-3) && max(d.AccSfX_mg*1e-3) <= maxRangeAcc+1 ...
           && -maxRangeAcc-1 <= min(d.AccSfY_mg*1e-3) && max(d.AccSfY_mg*1e-3) <= maxRangeAcc+1 ...
           && -maxRangeAcc-1 <= min(d.AccSfZ_mg*1e-3) && max(d.AccSfZ_mg*1e-3) <= maxRangeAcc+1)
            errorMsg{end+1} = sprintf('Acc values of at least one axis don''t lie between +-%g', maxRangeAcc/1000);
            % print error messages as warnings
            verb(verbose,4,errorMsg{end})
            errorFlag = true;
            if plotFlag == 1
                figure
                plot(d.timeVectorAcc, [d.AccSfX_mg*1e-3, d.AccSfY_mg*1e-3, d.AccSfZ_mg*1e-3])
                xlabel('time / s'), ylabel('acc / g'), title('Acceleration')
            end
        end

        % check median of abs value of acceleration: should be around
        % 1g
        absAcc = sqrt(d.AccSfX_mg.^2+d.AccSfY_mg.^2+d.AccSfZ_mg.^2);
        if ~ (abs(median(absAcc)/1000-1) < 0.05)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Median of absolute value of acc is no at 1g but at %g instead.', median(absAcc)/1000);
            verb(verbose,4,errorMsg{end})
            if plotFlag == 1
                figure
                plot(d.timeVectorAcc, absAcc)
                xlabel('time / s'), ylabel('|acc| / mg'), title('Absolute value of acceleration')
            end
        end

        % check gyro range
        maxmDegS = 3000;
        if ~ (abs(median(d.GyrSfX_mdegs)) < maxmDegS ...
           && abs(median(d.GyrSfY_mdegs)) < maxmDegS ...
           && abs(median(d.GyrSfZ_mdegs)) < maxmDegS)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Median of gyro values lie at %g, %g and %g instead of %g deg/s', ...
                median(d.GyrSfX_mdegs)*1e-3, ...
                median(d.GyrSfY_mdegs)*1e-3, ...
                median(d.GyrSfZ_mdegs)*1e-3, maxmDegS*1e-3);
            verb(verbose,4,errorMsg{end})
            if plotFlag == 1
                figure
                plot(d.timeVectorAcc, [d.GyrSfX_mdegs, d.GyrSfY_mdegs, d.GyrSfZ_mdegs])
                xlabel('time / s'), ylabel('angular rate / mdeg/s'), title('Angular rates')
            end
        end

        % check plausibility of speed signal: not just zeros? between 0
        % and 160 km/h? -> consider motorbike use case!
        speedLimit = 160; % km/h
        if ~ (any(d.speed_kmh) ...
                && 0 <= min(d.speed_kmh) && max(d.speed_kmh) <= speedLimit)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Speed is implausible. Min: %.2f km/h, Max %.2f km/h', min(d.speed_kmh), max(d.speed_kmh));
            verb(verbose,4,errorMsg{end})
            if plotFlag == 1
                figure
                plot(d.timeVectorAcc, d.speed_kmh)
                xlabel('time / s'), ylabel('velocity / km/h'), title('Speed')
            end
        end

        % check pressure for plausibility check cobiHubSetup befor ->
        % cobiAir (=hubSetup == 2 for logFile >= v10) has no pressure
        % sensor. Pressure should be always in between 800 and 1100hPa.
        if ~ (800*100 < min(d.barometer_pa) && max(d.barometer_pa) < 1100*100) ...
                && ~(logFileObj.logFileVersion >= 10 && any(d.cobiHubSetup == 2))
            errorFlag = true;
            errorMsg{end+1} = sprintf('Air pressure is implausible.');
            verb(verbose,4,errorMsg{end})
            if plotFlag == 1
                figure
                plot(d.timeVectorAcc, d.barometer_pa)
                xlabel('time / s'), ylabel('air pressure / Pa'), title('Air pressure')
            end
        end

        if ~any(d.hubConnection)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Hub connection is not available');
            verb(verbose,4,errorMsg{end})
        end

        if ~any(d.mountingAngle)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Calibration seems to be not working. Mounting angle is always zero.');
            verb(verbose,4,errorMsg{end})
        end

        if ~any(d.mountingSetup)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Calibration seems to be not working. Mounting setup is always zero.');
            verb(verbose,4,errorMsg{end})
        end

        if ~ (min(unique(d.manualCrashFire)) >= 0 ...
           && max(unique(d.manualCrashFire)) <= 1)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Manual crash fire contains values other than 0 and 1');
            verb(verbose,4,errorMsg{end})
        end

        if ~ (min(unique(d.crashFire)) >= 0 ...
           && max(unique(d.crashFire)) <= 1)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Crash fire contains values other than 0 and 1');
            verb(verbose,4,errorMsg{end})
        end

        if ~ (min(unique(d.crashClass)) >= 0 ...
           && max(unique(d.crashClass)) <= 100)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Crash class contains values other than (0, 100)');
            verb(verbose,4,errorMsg{end})
        end

        logFileObj.regFlag = errorFlag;
    end

    function [errorFlag, errorMsg] = checkSampleTiming(logFileObj,varargin)

        % check input parameter
        p = inputParser();
        p.addParameter('plot',true,@(x)isscalar(x) && islogical(x));
        %p.addParameter('plot',false,@(x)isscalar(x) && islogical(x));
        p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
        p.parse(varargin{:})

        plotFlag = p.Results.plot;
        verbose = p.Results.verbose;

        % check the log file for issues in the timing of sampling 

        errorFlag = false;
        errorMsg = {};

        d = logFileObj.data;

        % check for time consistency:
        % mean of sampling interval must not deviate more than 1% of
        % 100Hz
        accTimeLog = d.logfile.accTime(logFileObj.startSample:end-logFileObj.endSampleDelta);
        T_acc = median(diff(accTimeLog));
        f_acc = 1/T_acc;
        if ~(abs(f_acc / 100 -1) < 0.03)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Acc Sampling interval has %gHz instead of 100.\nlogfile: %s', f_acc, logFileObj.filePath);
            verb(verbose,4,errorMsg{end})
        end

        %check if there are outliers inbetween the sampling times (if
        %diff is zero for 0.05% of all logfile samples-> generic data
        %for synchronization)
        if sum(abs(diff(accTimeLog) - 0.01) > 0.005 == (diff(accTimeLog) ~= 0)) / length(accTimeLog) >= 0.005 ...
                || any(diff(accTimeLog) > 5) % diff > 5s?
            errorFlag = true;
            errorMsg{end+1} = sprintf('Outliers in sampling time of acc detected.');
            verb(verbose,4,errorMsg{end})
            if plotFlag
                %%
                figure
                ax(1) = subplot(211);
%                     plot(d.timeVectorAcc(100:end), '.')
                plot(d.logfile.accTime,'.')
                title({'Acc timing',strrep(logFileObj.filePath, '\', '\\')});
                ylabel('t_{Acc}')
                ax(2) = subplot(212);
%                     plot(diff(d.timeVectorAcc(100:end)),'.')
                plot(diff(d.logfile.accTime),'.')
                ylabel('\Delta t_{Acc}')
                xlabel('Sample')
                linkaxes(ax,'x')
            end
        end


        %check gyro sampling rate
        gyrTimeLog = d.logfile.gyrTime(logFileObj.startSample:end-logFileObj.endSampleDelta);
        T_gyr = median(diff(gyrTimeLog));
        f_gyr = 1/T_gyr;
        if ~(abs(f_gyr / 100 -1) < 0.02)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Gyr Sampling interval has %gHz instead of 100.', f_gyr);
            verb(verbose,4,errorMsg{end})
        end

        %check if there are outliers inbetween the sampling times (if
        %diff is zero for 0.05% of all logfile samples -> generic data for synchronization)
        if sum(abs(diff(gyrTimeLog) - 0.01) > 0.005 == (diff(gyrTimeLog) ~= 0)) / length(gyrTimeLog) >= 0.005
            % example file:
            % logFile = Cobi_CrashAlgo_Logfile('\\bosch.com\dfsrb\DfsDE\LOC\Rt\EBI\02_ENG\01_ENG1\01_System\23_CrashDetection\01_MeasurementData\2019_10_30_Regression_iOS_CobiPro\IMU-logFile-iOS-2019-10-30T16_20_56_614+0100_crcl1.1832_coca1.1304_iPhone 7_v11.csv')
            errorFlag = true;
            errorMsg{end+1} = sprintf('Outliers in sampling time of gyro detected.');
            verb(verbose,4,errorMsg{end})
            if plotFlag
                %%
                figure
                ax(1) = subplot(211);
%                     plot(d.timeVectorGyr(100:end), '.')
                plot(d.logfile.gyrTime, '.')
                title({'Gyro timing',strrep(logFileObj.filePath, '\', '\\')});
                ylabel('t_{Gyro}')
                ax(2) = subplot(212);
%                     plot(diff(d.timeVectorGyr(100:end)),'.')
                plot(diff(d.logfile.gyrTime),'.')
                ylabel('\Delta t_{Gyro}')
                xlabel('Sample')
                linkaxes(ax,'x')
            end
        end

        % check general time diff of acc and gyro timeStamps. Older log
        % files are allowed to have a deviation of 70ms, newer ones
        % (v12 and above) have only 20ms (i.e. 2 samples) allowed.
        if (abs(median(accTimeLog-gyrTimeLog)) >= 0.07 && logFileObj.logFileVersion < 12) || ...
                (abs(median(accTimeLog-gyrTimeLog)) >= 0.02 && logFileObj.logFileVersion >= 12)
            errorMsg{end+1} = sprintf('Acc and Gyro are not logged synchronously.');
            verb(verbose,4,errorMsg{end})
            errorFlag = true;
            if plotFlag
                %%
                figure;
                plot(accTimeLog-gyrTimeLog);
                grid on
                title({'accTime-gyrTime',strrep(strrep(logFileObj.filePath,'\','\\'), '_', '\_')});
                ylabel('\Delta t in s');
                xlabel('Sample');
            end
        end

        %check execution timing for android devices:
        % hna3si, 7.4.2020: in older file versions timeStampsStepExec
        % was only once every second. This vector had a new entry only
        % when the os triggered a batch run of algorithm steps, i.e.
        % every 100 samples. So the diff needed to be 1s. In newer log
        % file versions this value is set every execution of the step
        % function. That means every 100 entries it shold be increased
        % by around 1s. The rest of the time the step is executed as
        % fast as possible, i.e. the signal increases several ms or
        % even 0. The mean value, however, should be at around 10ms
        if d.osType == 2 && ...
                (logFileObj.getLogFileVersion >=12 ...
                    && abs(10e-3 - mean(diff(d.timeStampsStepExec ))) > 2e-3) ...
                || (logFileObj.getLogFileVersion < 12 ...
                    && abs(1 - mean(diff(d.timeStampsStepExec ))) > 10e-3)
            errorFlag = true;
            errorMsg{end+1} = sprintf('Execution timing for Android devices is corrupt.');
            verb(verbose,4,errorMsg{end})
            if plotFlag
                %%
                if logFileObj.getLogFileVersion >= 12
                    DeltaTsExpected = zeros(size(d.timeStampsStepExec));
                    DeltaTsExpected(1:100:end) = 1;
                else
                    DeltaTsExpected = ones(size(d.timeStampsStepExec));
                end
                figure;
                plot(DeltaTsExpected, 'o')
                hold on
                plot(diff(d.timeStampsStepExec), '.')
                legend('expected','actual')
                title('Execution time step')
                xlabel('Sample')
                ylabel('\Delta t in s');
            end
        end
    end

    function crashType = checkCrashFire(logFileObj)
        % in case no crash was fired (automatically or manually) the
        % return value is 0. If a auto crash fire was found, 1 is
        % returned. If only a manual crash fire was found, a 2 is
        % returned. If both a manual and an automatic crash were fired
        % the 1 OR 2 (i.e. 3) is returned.

        d = logFileObj.data;
        % 0000
        crashType = int32(0);
        if any(d.crashFire)
            % 0001
            crashType = bitor(crashType, 1);
        end
        % 
        if any(d.manualCrashFire)
            % 0010
            crashType = bitor(crashType, 2);
        end

    end

    function pathExtendedLogFile = createExtendedLogfile(logFileObj, simOutput, unitTestPath)
        % create an extended logfile: combination of standard logfile 
        % from smartphone and simulated output signals
        %
        % Input:
        % simOutput of type Simulink.SimulationOutput
        % unitTestPath for EB is: \\bosch.com\dfsrb\DfsDE\LOC\Rt\EBI\02_ENG\01_ENG1\01_System\23_CrashDetection\02_unitTests
        % unitTestPath for MBCD is: \\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\001_refData\unitTestSet

        firstSample = logFileObj.startSample;
        deltaToLastSample = logFileObj.endSampleDelta;

        logfileTable = logFileObj.data.logfile;

        % Simulink has assigned the results of the algorithm to the
        % caller workspace so. We get them from there and store them
        % in local variables to be able to pass them to the results
        % table.
        simCrashFire = [zeros(firstSample-1,1);simOutput.crashFire];
        simCrashScenario = [zeros(firstSample-1,1);simOutput.crashScenario];
        simRoll_deg = [zeros(firstSample-1,1); simOutput.rollAngle_deg];
        simPitch_deg = [zeros(firstSample-1,1); simOutput.pitchAngle_deg];
        simRideFire = [zeros(firstSample-1,1); simOutput.rdFire];
        simCollisionFire = [zeros(firstSample-1,1); simOutput.collisionFire];
        simTipOverFire = [zeros(firstSample-1,1); simOutput.toFire];
        simGroundHitFire = [zeros(firstSample-1,1); simOutput.groundHitFire];
        simRroFire = [zeros(firstSample-1,1); simOutput.rroFire];
        simSdoFire = [zeros(firstSample-1,1); simOutput.sdoFire];
        simStandFire = [zeros(firstSample-1,1); simOutput.sdFire];
        simSDMstate = [zeros(firstSample-1,1); simOutput.SDM_out];

        simTime = (0:0.01:(length(simCrashFire)-1)/100)';
        logfileTable = logfileTable(1:end-deltaToLastSample,:);

        extendedLogFileTable = [logfileTable, table(simCrashFire), ...
            table(simCrashScenario), table(simRoll_deg), ...
            table(simPitch_deg), table(simRideFire), ...
            table(simCollisionFire), table(simTipOverFire), ...
            table(simGroundHitFire), table(simRroFire), ...
            table(simSdoFire), table(simStandFire), table(simTime), table(simSDMstate)];

        % get model version of CRCL and COCA
        modelInfoCrcl = Simulink.MDLInfo('CRCL.slx');
        modelInfoSdm = Simulink.MDLInfo('SensorDataMonitor.slx');
        switch logFileObj.vehicleType
            case logFileObj.vtBicycle
                modelInfoCal = Simulink.MDLInfo('CobiCalibration.slx');
                strExtFiles = '02_extendedFiles';
                strCal = '_COCA_';
            case logFileObj.vtMotorbike
                modelInfoCal = Simulink.MDLInfo('CalibrationMotorbike_v2.slx');
                strExtFiles = '04_extFilesMBike';
                strCal = '_MCAL_';
            otherwise
                error(['Vehicle type ''%s'' is not supported. Only ', ...
                    logFileObj.vtBicycle, ' or ', ...
                    logFileObj.vtMotorbike, ' are allowed.'], ...
                    logFileObj.vehicleType);
        end

        extvCRCL = regexp(modelInfoCrcl.ModelVersion, '\d+', 'match');
        extvCal = regexp(modelInfoCal.ModelVersion, '\d+', 'match');
        extvSDM = regexp(modelInfoSdm.ModelVersion, '\d+', 'match');
        pathExtendedLogFile = sprintf([strrep( ...
            unitTestPath, '\', '\\'), ...
            '\\%s\\CRCL_%s.%04s%s%s.%04s_SDM_%s.%04s'], strExtFiles, ...
            extvCRCL{1}, extvCRCL{2}, ...
            strCal, extvCal{1}, extvCal{2},...
            extvSDM{1}, extvSDM{2});

        % write extended csvFile
        [~, fileName, ~] = fileparts(logFileObj.filePath);
        extLogFileFullPath = strcat(pathExtendedLogFile,'\', ...
            'ext_', ...
            ... 'simCRCL',modelInfoCrcl.ModelVersion, ...
            ... strSimCal,modelInfoCal.ModelVersion, ...
            ... '_simSDM',modelInfoSdm.ModelVersion, ...
            ... '_', ...
            fileName,'.csv');

        if length(extLogFileFullPath) >= 256
            verb(5, 3, sprintf('Path to extended logfile has more than 256 characters. This leads to problems in unit test in Visual Studio.\n%s', extLogFileFullPath))
        end

        %check if directory with CRCL version exists
        if ~exist(pathExtendedLogFile, 'dir')
            mkdir(pathExtendedLogFile)
        end

        % it is much faster (0.8s vs. 8s) to write the file to the local
        % file system and copy it to a network drive instead of directly
        % writing to a network drive
        writetable(extendedLogFileTable,'logFileTmp.csv','Delimiter',';')
        copyfile('logFileTmp.csv',extLogFileFullPath)
        delete logFileTmp.csv % cleanup the previously created temp file
        

        % copy header if logfile version is >= v12 and bicycle
        if logFileObj.getLogFileVersion >=12 && strcmp(logFileObj.vehicleType, logFileObj.vtBicycle) 
            [filepathHeader,nameHeader,~] = fileparts(logFileObj.filePath);
            filenameHeader = fullfile(filepathHeader,strcat(nameHeader,'.txt'));
            copyfile(filenameHeader, strcat(pathExtendedLogFile, ...
                '\','ext_', ...
                ... 'simCRCL',modelInfoCrcl.ModelVersion, ...
                ... '_simCOCA',modelInfoCal.ModelVersion, ...
                ... '_simSDM',modelInfoSdm.ModelVersion,'_', ...
                nameHeader,'.txt'));
        end

    end
end

methods (Static = true)
    function success = regressionTest()
        plotFlag = false;
        verb = 4;
        success = true;
        infoText = {};
        filePath = {};
%             sampleOfInterest = {};
        expectedResult = {};
        regressionTestFilePath = '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\001_refData\regressionTestSet';

        infoText{end+1} = 'Checking Cobi logfile from iOS release test (30.06.2020)';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU-logFile-iOS-iPhone 7_crcl1.1941_coca1.1328_2020-06-30T16_52_32_981+0200_v12.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash,  vCal,      vCRCL,   DeviceID
            17123,          1,      1.1328,     1.1941, 'B7CDC60A-7BB0-4182-9D85-0EC937222621'};

        infoText{end+1} = 'Checking Cobi logfile from Android release test (30.06.2020)';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_android_SM-G973F_crcl1.1941_coca1.1328_2020-06-30T15_44_53.306+0200_v12.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash
            6000,          1,      1.1328,     1.1941, 'db6282ae-c9e4-4822-b5c2-7b581b2fa404'};

        infoText{end+1} = 'Checking motorbike logfile from Dekra POC (Android, 21.11.2019). Warnings for sample timing (acc and gyro) and execution timing are expected.';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_android_mb_2019-11-21T114328.646+0100_crcl1.1829_coca1.1304_SM-G950F_v11.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash
            59783,          1,      1.1304,     1.1829, ''};

        infoText{end+1} = 'Checking motorbike logfile from verification test for Android (23.06.2020)';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_android_mb_Google-Pixel-3_crcl1.1941_mcal1.1414_2020-06-23T12-39-07.786+0200_v13.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash
            42781,          1,      1.1414,     1.1941, ''};

        infoText{end+1} = 'Checking motorbike logfile from verification test for iOS (23.06.2020). Warning for scc sampling interval and acc sample timing are expected.';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_iOS_mb_iPhone6S_1.0_crcl1.1941_mcal1.1414_2020-06-23T123922+0200_v13.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash
            46677,          1,      1.1414,     1.1941, ''};

        infoText{end+1} = 'Checking motorbike logfile from Android beta1 test (Nino road bike, 25.06.2020). Warning for median(acc) and for crashClass is expected (missing column ''manualCrashFire'' in this logFile version).';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_mb_android_samsung-SM-G973F_crcl1.1941_mcal1.1436_2020-06-25T18-43-14.867+0200_v13.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash
            63582,          0,      1.1436,     1.1941, ''};

        infoText{end+1} = 'Checking Cobi logfile with just one calibration step inside and a manual crash report (Android, 5.11.2020)';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_android_SM-G973F_crcl1.1941_coca1.1328_2020-11-05T17_13_16.529+0100_v12.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash (here: manual crash!)
            6000,           2,      1.1328,     1.1941, '42625300-ce9c-45a8-b3ed-a1d12105bb84'};

        infoText{end+1} = 'Checking Cobi logFile v14 that had a FP in versions before CRCL 1.1969 due to missing hub connection. This warning is expected.';
        filePath{end+1} = fullfile(regressionTestFilePath, ...
            'IMU_logFile_iOS_iPhone XR_1.17.2-alpha9_2021-02-12T11_25_01_117+0100_v14.csv');
        expectedResult{end+1} = {...
        ... length(acc),    crash (in logfile, not in sim!),  vCal,      vCRCL,  deviceID
            30000,          1,                                1.1332,    1.1969, '029635E7-A805-4EDD-965F-A7B680B1C42D'};

        for i=1:length(filePath)
            disp(infoText{i})
            sVec = 0;
            try
                logFileObj = Cobi_CrashAlgo_Logfile(filePath{i},'verbose',verb,'plot',plotFlag);

                % to put special tests here:
                % check for file length
                logFileObj.getFileContent();
                sVec(1) = length(logFileObj.data.AccSfX_mg) == expectedResult{i}{1};

                % check for crash
                sVec(2) = logFileObj.checkCrashFire() == expectedResult{i}{2};

                % check for calibration version
                sVec(3) = logFileObj.vCal == expectedResult{i}{3};

                % check for CRCL version
                sVec(4) = logFileObj.vCRCL == expectedResult{i}{4};

                % check for device ID
                sVec(5) = strcmp(logFileObj.deviceID, expectedResult{i}{5});

                % plot raw data (plots shall be created invisibly)
                logFileObj.plotRawData('plot', plotFlag);

                % get simulation data
                logFileObj.getSimulationData();

                if all(sVec) % < 1% deviation
                    success = success & true;
                    fprintf('\tSuccess!\n\n')
                else
                    % this test failed, so the whole unit test has failed
                    success = success & false;
                    fprintf(2,'\tFailed! Calculated value not in range.\n\n');
                end
            catch me
                % this test failed, so the whole unit test has failed
                success = success & false;
                fprintf(2,'\tFailed! Program abort with the following message:\n%s\n\n', me.getReport);
            end
        end

        if ~success
            warning('There were errors in the regression test.')
        else
            fprintf('All tests passed without errors.\n')
        end
    end
end
end