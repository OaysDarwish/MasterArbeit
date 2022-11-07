classdef HC_crashDatabase < handle
    % %******************************************************************************
    % %
    % % (C) All rights reserved by BOSCH.IO GMBH, WAIBLINGEN
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
    % % @ File Name: HC_crashDatabase.m
    % % @ URL: http://www.bosch.io/
    % % @ Author: Haeberlen Nino (IOC/PAC2) <Nino.Haeberlen@bosch.io>
    % % @ Date: 2021-05-31
    % %
    % % $Revision: $
    % % $LastChangedBy: $
    % % $LastChangedDate: $
    % %
    % % -----------------------------------------------------------------------
    % % DESCRIPTION:
    % %  Class to handle crash events to the database and get data from
    % %  this database
    % %
    % % -----------------------------------------------------------------------
    % % -----------------------------------------------------------------------
    % %
    % %
    % % Detailed information see:
    % %
    % %                         !!!<a href="matlab:open(which('HC_crashDatabase.html'))">HC_crashDatabase</a>!!!
    % %
    % %
    
    properties
        % database connection
        dbCon
        % table with events from SO backend
        eventTable
        % list with the event objects
        eventList = {};
        % list with the logfiles available on disk
        logFileList
        % folder where the decrypted and unzipped logfiles are stored
        decryptedFolder = 'C:\data\testdata\calimoto\20201125_Livebetrieb_decrypted';
        % parent folder where the matched logfiles are copied to
        logFileParent = '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\010_CrashDatabase';
        % folder name for files with aborted crash triggers
        abortedLogFileFolder = '020_abortedTriggers';
        % flag if for matching logfiles was already searches
        bSearchedForMatchingLogfiles = false;
        % events for which no logfile was found
        eventWOLogfiles
        % logfile for which no event was found
        crashTriggersWOevents
        % list that maps time stamps of logfile to events
        mappingList
    end
    
    methods
        function dbObj = HC_crashDatabase()
            %%
%             dbObj.dbCon = database('HC crash db','','');
%             dbObj.dbCon = database('HC eventsDB','',''); % wrong driver
            dbObj.dbCon = database('HC eventsDB ODBC','','');
        end
        
        function loadEvents(dbObj, varargin)
            %loadEvents   Load the event table from the csv list and create
            %a list of HC_crashEvent objects
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('csvPath',['\\sites.inside-share3.bosch.com@SSL\'...
                'DavWWWRoot\sites\150120\Documents\001_HC_Service_Reporting\'...
                'SO Data Export Semi.csv'],...
                @(x) ischar(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            csvPath = p.Results.csvPath;
            
            dbObj.loadEventCSV('csvPath',csvPath);
            dbObj.createEventList('verbose', v);
        end
        
        function mappingList = exportEventsToDB(dbObj, varargin)
            
            % make sure that the events to export are loaded
            if isempty(dbObj.eventList)
                dbObj.loadEvents();
            end
            
            % try to find matching logfiles for all entries in the event
            % list
            if ~dbObj.bSearchedForMatchingLogfiles
                mappingList = dbObj.findMatchingLogfiles();
            else
                mappingList = dbObj.mappingList;
            end
            
            % export the event to the DB
            arrayfun(@(x) x.exportToDatabase(), dbObj.eventList)
            
        end
        
        function getDetailsFromDatabase(dbObj, varargin)
            %getDetailsFromDatabase   Get the details of the events in the
            %list from the database, not from the logfiles on disk
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            % make sure that the events are loaded
            if isempty(dbObj.eventList)
                fprintf('Loading events from csv and creating event list\n')
                dbObj.loadEvents();
                fprintf('Done.\n')
            end
            
            verb(v,5,sprintf('Getting details from database...'))
            iEvList = length(dbObj.eventList);
            nbytes = fprintf('Processing event 0 of %d', iEvList);
            for i=1:iEvList
                nbytes = fprintf([repmat('\b',1,nbytes) 'Processing event %d of %d\n'], i, iEvList)-nbytes;
                dbObj.eventList(i).getDetailsFromDatabase();
            end
            verb(v,5,sprintf('Done.'))
        end
        
        function updateEventsInDB(dbObj, parNames, varargin)
            %updateEventsInDB overwrites in the DB all data of all loaded
            %events
            
            p = inputParser();
            % parNames must be a 1-by-n cell array, e.g.
            % {'documentation','trigger_type'}
            p.addRequired('parNames',@(x) iscell(x) && all(cellfun(@ischar, x)) && size(x,1) == 1);
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('overwrite',false,@(x) isscalar(x) && islogical(x));
            p.parse(parNames, varargin{:})
            v = p.Results.verbose;
            bOverwrite = p.Results.overwrite;
            
            % make sure that the events to export are loaded
            if isempty(dbObj.eventList)
                dbObj.loadEvents();
            end
            
            % try to find matching logfiles for all entries in the event
            % list
            if ~dbObj.bSearchedForMatchingLogfiles
                dbObj.findMatchingLogfiles();
            end
            
            % update the events in the DB
            arrayfun(@(x) x.updateInDatabase(parNames, 'verbose', v,'overwrite',bOverwrite), ...
                dbObj.eventList)
            
        end
        
        function updateLogFileData(dbObj)
            % updateLogFileData gets a list of events, loads the
            % corresponding logFiles and updates all logfile related data
            % (i.e. not the event data) in the DB.
            
%TODO: Write new method 'updateEventData' that updates event data in
%database, e.g.:
%             dbObj.createEvent(...) % creates an additional event to dbObj.eventList
%             eventObj.updateInDatabase(dbCon,{'elapsedGPStime_s','movedGPSdist_m','meanGPSspeed_kmh'},'overwrite',true)
            

            % get the list of event IDs that are in between the named time
            % stamps and that have a logFilePath
            a = select(dbObj.dbCon, ['SELECT ID from HC_events '...
                'WHERE creation_TS BETWEEN {ts ''2021-09-01 00:00:00''} AND {ts ''2022-02-10 00:00:00''}' ...
                'AND logFilePath IS NOT NULL']);
            
            % do the update for all received event-IDs
            for i=1:height(a)
                disp(i)
                try
                    eventObj = HC_crashEvent(dbObj.dbCon, a.ID(i));
                    eventObj.updateLogFileDataInDatabase();
                catch me
                    warning(me.getReport)
                end
            end
        end
        
        function mappingList = findMatchingLogfiles(dbObj, varargin)
            %findMatchingLogfile   Try to match events and calimoto
            %logfiles via the time stamp
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('timeSpanToLoad','lastMonth',@(x) ~isempty(intersect(x, ...
                {'all','lastMonth','2021-1','2021-2','2021-3'})))
            p.parse(varargin{:})
            v = p.Results.verbose;
            timeSpanToLoad = p.Results.timeSpanToLoad;
            
            % load all logfiles
            if isempty(dbObj.logFileList)
                % ***********************************
                % (this needs pretty much time!!!!!!)
                % ***********************************
                dbObj.loadLogFileList('timeSpanToLoad',timeSpanToLoad);
            end
            lfList = dbObj.logFileList;
            
            % get a vector containing all time stamps of the algo crash
            % triggers
            for i=1:size(lfList,1)
                if ~isempty(lfList.dtPlausCrash{i})
                    %TODO: 
                    ts_crashTrigger(i,1) = lfList.dtPlausCrash{i}(end);
                end
            end
            [ts_crashTrigger, idxCT] = sort(ts_crashTrigger);
            
            % make sure that the events to export are loaded
            if isempty(dbObj.eventList)
                dbObj.loadEvents();
            end
            % create a vector containing all creation time stamps of HC
            % events, take only 'BSOCM' and 'auto' events
            for i=1:length(dbObj.eventList)
                if strcmp(dbObj.eventList(i).tenant, 'BSOCM') % ...
                        % && strcmp(dbObj.eventList(i).trigger_type, 'auto')
                    ts_event(i,1)=dbObj.eventList(i).creation_TS;
                end
            end
            
            [ts_event, idxEV] = sort(ts_event);
            idxEV(isnat(ts_event)) = [];
            ts_event(isnat(ts_event)) = [];
            
            % vector containing indices of event list of events with
            % matching logfile
            idxEventsWLogfile = [];
            % vector containing indices of logfile list of logfiles with
            % matching event
            idxLogfilesWEvent = [];
            iCrashTrigger = 0;
            mappingList = datetime.empty(0,2);
            mappingList.TimeZone = 'Europe/Berlin';
            
            for iEvent=1:length(ts_event)
                
                eventObj = dbObj.eventList(idxEV(iEvent));
                tsString = eventObj.creation_TS;
                tsString.Format = 'yyyy-MM-dd''T''HH-mm-ss';
                
                deltaList = eventObj.creation_TS - ts_crashTrigger(iCrashTrigger+1:end);
                % find the time stamp of the last crash that happened
                % before this event was created
                [minDelta, idxMin] = min(deltaList(deltaList>0));
                if isempty(idxMin)
                    % when no minimun was found (i.e. we are either at the
                    % end of the list or all triggers are in the future)
                    % set the index to 0 to not mess iCrashTrigger and to
                    % keep filling mappingList
                    idxMin = 0;
                end
                iCrashTrigger=iCrashTrigger+idxMin; % to start next search after this one
                if minDelta < duration(0,10,0) % max 10 minutes before event
                    %%
                    % add indices of logfiles with a matching event
                    idxLogfilesWEvent = [idxLogfilesWEvent, iCrashTrigger];%#ok
                    
                    idxLfList = idxCT(iCrashTrigger);
                    % add indices of events with a matching logfile
                    idxEventsWLogfile = [idxEventsWLogfile, idxEV(iEvent)];%#ok
                    verb(v, 5, sprintf(['Correct file found. dt(crash trigger to event in BE):\t'...
                        '%2gs (should be within (0, 60)s), file was written %gs after crash trigger.'], ...
                        seconds(minDelta), seconds(lfList.creationTimeStamp(idxLfList)-ts_crashTrigger(iCrashTrigger)) ));
                    
                    % fill eventually lone logfile time stamps ...
                    mappingList(end+1:end+idxMin-1,1) = ts_crashTrigger(iCrashTrigger-idxMin+1:iCrashTrigger-1);
                    % ... and logfile time stamp and event creation_TS into
                    % the next line of the mapping list
                    mappingList(end+1,:) = [ts_crashTrigger(iCrashTrigger),eventObj.creation_TS]; %#ok
                    
                    eventObj.logFile = lfList.logFile{idxLfList};
                    % get the file and check if it really is the right
                    % one
                    logFilePath = fullfile(lfList.folder{idxLfList}, lfList.name{idxLfList});
                    
                    
                    newPath = fullfile(dbObj.logFileParent, char(tsString), lfList.name{idxLfList});

                    % check if the new path is either new (i.e. no path was
                    % set before) or identical to the one revealed by the
                    % old search method
                    if ~isempty(eventObj.logFilePath)
                        if ~strcmp(eventObj.logFilePath, newPath)
                            verb(v, 4, sprintf('For %s the new search method revealed a different logfile.', tsString))
                        else
                            % same file was found as with old method
                        end
                    else
                        % now a file was found, with the old method none
                        % was found.
                    end
                    % change the log file path to the new one in the
                    % logFile object and in the crash event object.
                    eventObj.logFile.filePath = newPath;
                    eventObj.logFilePath = newPath;

                    eventObj.setLogFileMetadata();
                    
                    close all
                    if exist(newPath, 'file') ~= 2
                        if exist(fileparts(newPath),'file') ~= 7
                            mkdir(fileparts(newPath))
                        end
                        copyfile(logFilePath, newPath)
                    end
                else
                    if isempty(minDelta)
                        verb(v,5,sprintf(['No crash log found for event on %s. '...
                            'Latest crash was already assigned to an event '...
                            'before or no crash log could be assigned to an event at all.'], tsString))
                    else
                        verb(v,5,sprintf(['No crash log found for event on %s. '...
                            'Latest crash was %s h before this event.'], tsString, minDelta))
                        % add time stamps of logfiles to mapping list
                        % (logfile = first column) ...
                        mappingList(end+1:end+idxMin,1) = ts_crashTrigger(iCrashTrigger-idxMin+1:iCrashTrigger);
                    end
                    % add time stamp of this event to the mapping list
                    mappingList(end+1,2) = eventObj.creation_TS; %#ok
                    
                    if ~isempty(eventObj.logFilePath)
                        verb(v,4,sprintf(['For this event %s a logfile path '...
                            'that now is no more valid was written to the database.'], tsString))
                    end
                    % delete logfile and derived metadata
                    eventObj.logFile = [];
                    eventObj.logFilePath = '';
                    eventObj.os_type = '';
                    eventObj.dtCrash2Logfile_s = [];
                    eventObj.dtCrashTrigger2Event_s = [];
                    eventObj.crashClass = [];
                    eventObj.sumSquareMeanAngles = [];
                    eventObj.numCFfire = [];
                    continue
                end
            end
            idxLogfilesWOEvent = setdiff((1:length(ts_crashTrigger)), idxLogfilesWEvent);
            idxEventsWOLogfile = setdiff(idxEV', idxEventsWLogfile);
            
            dbObj.bSearchedForMatchingLogfiles = true;
            
            dbObj.eventWOLogfiles = sort(arrayfun(@(x) x.creation_TS, dbObj.eventList(idxEventsWOLogfile)))';
            dbObj.crashTriggersWOevents = sortrows(lfList(idxCT(idxLogfilesWOEvent),:),'creationTimeStamp','ascend');
            fprintf('\n\nFor %g/%g events no logfile was found and for %g/%g logfiles no event was found.\n\n', ...
                length(idxEventsWOLogfile), length(ts_event), length(idxLogfilesWOEvent), size(lfList,1))
            dbObj.mappingList = mappingList;
            
            % copy all logfiles without a corresponding event to a seperate
            % folder on the share
            for i=1:length(idxLogfilesWOEvent)
                lfLine = lfList(idxLogfilesWOEvent(i),:);
                logFilePath = fullfile(lfLine.folder{:}, lfLine.name{:});
                tsCreationString = lfLine.creationTimeStamp;
                tsCreationString.Format = 'yyyy-MM-dd''T''HH-mm-ss';
                newPath = fullfile(dbObj.logFileParent, '../', dbObj.abortedLogFileFolder, char(tsCreationString), lfLine.name{:});
                if exist(newPath, 'file') ~= 2
                    fprintf('Copying logfile without event to share. Creation TS: %s.\n', char(tsCreationString))
                    if exist(fileparts(newPath),'file') ~= 7
                        mkdir(fileparts(newPath))
                    end
                    copyfile(logFilePath, newPath)
                end
            end
        end
        
        function a = simulateAllMbikeEvents(dbObj, varargin)
            % This method runs the current algo version on all mbike events
            % and compares the algo result with the event_cause label in
            % the database
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            % get a list of all paths of interest including the labels from
            % the database
            a = select(dbObj.dbCon, ['SELECT HC_events.creation_TS, tenant.tenant, HC_events.logFilePath, event_cause.event_cause, HC_events.crashClass, HC_events.documentation '...
                'FROM (HC_events LEFT JOIN event_cause ON HC_events.event_cause_id = event_cause.ID ) '...
                'INNER JOIN tenant on HC_events.tenant_id = tenant.id '...
                'WHERE HC_events.logFilePath IS NOT NULL AND tenant.tenant = ''BSOCM'' '...
                'ORDER BY HC_events.creation_TS']);
            % add a column for the simulated crash class
%             a.simCrashClass = zeros(height(a),1);
            a.simCrashClass = repmat({''},height(a),1); % empty cell column
            
            modelName = 'CrashAlgo_TestEnvironment_Motorrad_v2.slx';
            load_system(modelName)
            tic
            for i=1:height(a)
                try
                    logFileObj = Cobi_CrashAlgo_Logfile(a.logFilePath{i},'plot',false,'verbose',v-2);
                    data = logFileObj.getSimulationData();
                    assignin('base','data',data);
                    
                    simOut = sim(modelName);
                    
%             buildObj = Cobi_buildAndTestCrashAlgo('git', 'vehicleType', 'motorbike');
% 
%             % run algo on historic data...
%             buildObj.simulateTestSubset;
                    
                    if any(simOut.simoutCrash.signals.values(:,9)) % CF_fire
                        %crash_fire    --> >=1 if crash, number refers to estimated crash class
                        crashClassesTmp = unique(simOut.simoutCrash.signals.values(:,10)); % CF_scenario
                        a.simCrashClass{i} = mat2str(crashClassesTmp(2:end));
                    else
                        % no crash
                        a.simCrashClass{i} = 'no crash';
                    end
                catch me
                    a.simCrashClass{i} = 'error';
                    verb(v,5,me.getReport)
                end
            end
            toc
            modelInfoCrcl = Simulink.MDLInfo('CRCL.slx');
            modelInfoSdm = Simulink.MDLInfo('SensorDataMonitor.slx');
            modelInfoCal = Simulink.MDLInfo('CalibrationMotorbike_v2.slx');
            close_system(modelName)
            
            extvCRCL = regexp(modelInfoCrcl.ModelVersion, '\d+', 'match');
            extvCal = regexp(modelInfoCal.ModelVersion, '\d+', 'match');
            extvSDM = regexp(modelInfoSdm.ModelVersion, '\d+', 'match');
            resultFileName = sprintf('%s_result_algo_sim_CRCL_%s.%04s_MCAL_%s.%04s_SDM_%s.%04s.csv', ...
                datestr(now,'YYYY-MM-DD'), ...
                extvCRCL{1}, extvCRCL{2}, ...
                extvCal{1}, extvCal{2},...
                extvSDM{1}, extvSDM{2});
            writetable(a, resultFileName,'Delimiter',';')
        end
        
    end
    
    methods (Access = private, Hidden = true)
        
        function createEventList(dbObj, varargin)
            %createEventList   Create a list of HC_crashEvent objects and
            %set thir properties according to the data from SO backend.
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            evList = HC_crashEvent.empty;
            for i=1:size(dbObj.eventTable,1)
                
                eventObjTmp = HC_crashEvent(dbObj.dbCon, dbObj.eventTable.creation_TS{i}(1:19));
                % take only events after 1.1.2021
                if eventObjTmp.creation_TS < datetime(2021,1,1,'TimeZone','Europe/Berlin')
                    continue
                end
                eventObjTmp.setSeverity(dbObj.eventTable.severity(i));
                eventObjTmp.setDocumentation(dbObj.eventTable.documentation{i});
                eventObjTmp.setTypeOfService(char(dbObj.eventTable.type_of_service(i)));
                eventObjTmp.setTenant(char(dbObj.eventTable.tenant(i)));
                % get GPS movement for all tenants where users are able to
                % move (i.e. not for HOME)
                if ~isempty(intersect(eventObjTmp.tenant, {'BSOCM', 'BSOEB', 'BSOTC'}))
                    [dt_s, ds_m] = calcGPSmovement(dbObj, i, 'verbose', v);
    %                     v_kmh = ds_m./(dt_s/3600);
                    if sum(dt_s)>0
                        eventObjTmp.setGPSmovement(1e3*sum(ds_m), sum(dt_s));
                    else
                        % no GPS points (i.e. no time elapsed): set distance to
                        % -1 (speed is set to -1 in setGPSmovement() )
                        eventObjTmp.setGPSmovement(-1,0);
                    end
                else % for HOME there is no timestamp and no velocity
                    eventObjTmp.setGPSmovement(0,0);
                end
                
                
                msd_test_flag = char(dbObj.eventTable.msd_test_flag(i));
                
                % take only these events from Calimoto, EB, Tocsen and Home
% TODO: Get tentant list from DB
                if ~isempty(intersect(eventObjTmp.tenant, {'BSOCM', 'BSOEB', 'BSOTC', 'BSOHO'}))
                    
                    % do some plausibilisation check
                    
                    % is trigger_type valid?
                    trigger_type = char(dbObj.eventTable.trigger_type(i));
                    if contains(trigger_type, 'auto', 'IgnoreCase', true)
                        eventObjTmp.setTriggerType('auto');
                    elseif contains(trigger_type, 'manual', 'IgnoreCase', true)
                        eventObjTmp.setTriggerType('manual');
                    else
                        % maybe print the warning only for events of the latest
                        % x weeks?
                        verb(v, 4, sprintf('''trigger_type'' is %s, which is not supported. Skipping event from %s.', ...
                            trigger_type, eventObjTmp.creation_TS))
                        continue
                    end
                    
                    % is severity valid?
                    if isnan(eventObjTmp.severity)
                        if strcmp(eventObjTmp.trigger_type, 'manual')
                            % manual calls don't have a severity
                            eventObjTmp.severity = -1;
                        else
                            verb(v, 4, sprintf('severity is missing! Skipping event from %s.', eventObjTmp.creation_TS))
                            continue
                        end
                    end
                    if eventObjTmp.severity == 0
                        if strcmpi(eventObjTmp.trigger_type, 'manual')
                            % manual calls don't have a severity, so we
                            % replace the 0 by -1 (means in database: no
                            % severity)
                            eventObjTmp.severity = -1;
                        else
                            verb(v, 4, sprintf('severity is zero! Skipping event from %s.', eventObjTmp.creation_TS))
                            continue
                        end
                    end
                    
                    % is msd_test_flag valid?
                    if strcmp(msd_test_flag, 'true')
                        eventObjTmp.msd_test_flag = true;
                    elseif strcmp(msd_test_flag, 'false')
                        eventObjTmp.msd_test_flag = false;
                    else
                        verb(v, 4, sprintf('For ''msd_test_flag'' is %s, which is not supported. Only true or false is allowed. Skipping event from %s.', ...
                            msd_test_flag, eventObjTmp.creation_TS))
                        continue
                    end
                    
                    % now take this event and append it to the list.
                    evList(end+1) = eventObjTmp; %#ok
                end
            end
            dbObj.eventList = evList;
            
            dbObj.bSearchedForMatchingLogfiles = false;
        end
        
        function [dt_s, ds_m] = calcGPSmovement(dbObj, i, varargin)
        %calcGPSmovement calculates distance and time moved via GPS points
        % of the i-th element in the eventTable
        
            % check input parameter
            p = inputParser();
            p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            dt_s = 0;
            ds_m = 0;
            
            % 'position_hisotry' only contains the latest few
            % points. The first GPS position is stored in 'LatLng'
            % with the corresponding time stamp in 'init_TS'. The
            % latest position is also not part of
            % 'position_history' but rather stored in
            % 'latest_position'
            init_pos = textscan(dbObj.eventTable.LatLng(i), '%f','Delimiter',',');
            init_pos = [init_pos{:}];
            
            % the event #2719 from "2021-11-29T06:52:38.633" has no data. Skip
            % these with a warning
            if isempty(init_pos)
                verb(v, 4, sprintf('The event from %s (tenant: %s) has no GPS position.', ...
                    dbObj.eventTable.creation_TS(i), char(dbObj.eventTable.tenant(i))))
                return
            end
            
            % when a position history is available, calculate also the
            % distances in between these locations
            if ~isempty(char(dbObj.eventTable.position_history(i)))
                try
                    pos_hist = jsondecode(dbObj.eventTable.position_history(i));
                catch
                    verb(v, 4, sprintf('The event from %s (tenant: %s) has an invalid JSON string. Please check:\n%s', ...
                        dbObj.eventTable.creation_TS(i), char(dbObj.eventTable.tenant(i)), dbObj.eventTable.position_history(i)))
                    return
                end
                pos_list = zeros(size(pos_hist,1)+2, 4);
                % fill the succeeding lines in reverse order with
                % 'position_history' data
                if isfield(pos_hist, 'timestamp')
                    % new SO export file (2022, 'timestamp' is posix timestamp,
                    % 'locationPrecision')
                    for k = length(pos_hist):-1:1
                        pos_list(length(pos_hist)-k+2,:) = ...
                            [pos_hist(k).timestamp, ...
                            pos_hist(k).latitude, pos_hist(k).longitude, pos_hist(k).locationPrecision];
                    end
                elseif isfield(pos_hist, 'timeStamp')
                    % old SO export file (<= 2021, 'timeStamp' is a string, 'accuracy')
                    for k = length(pos_hist):-1:1
                        pos_list(length(pos_hist)-k+2,:) = ...
                            [1e3*posixtime(datetime(pos_hist(k).timeStamp, ...
                                'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z''', 'TimeZone','Etc/GMT')), ...
                            pos_hist(k).latitude, pos_hist(k).longitude, pos_hist(k).accuracy];
                    end
                else
                    error('Unknown json string. Please check:\n%s', dbObj.eventTable.position_history(i))
                end
                    
            else
                % no history available, but init and latest should
                % be available
                pos_list = zeros(2, 4);
            end
            % fill the last line with 'latest_position'
            latest_pos = jsondecode(dbObj.eventTable.latest_position(i));
            % fill 'init_TS', 'LatLng' and locationPrecision = 0 (=highest)
            % into the first and last line
            if isfield(latest_pos, 'timestamp')
                % new SO export file (2022, 'timestamp' is posix timestamp,
                % 'locationPrecision')
                pos_list(1,:) = [dbObj.eventTable.init_TS(i), ...
                    init_pos(1), init_pos(2), 0];
                pos_list(end,:) = [latest_pos.timestamp, latest_pos.latitude, ...
                    latest_pos.longitude, latest_pos.locationPrecision];
            elseif  isfield(latest_pos, 'timeStamp')
                % old SO export file (<= 2021, 'timeStamp' is a string, 'accuracy')
                pos_list(1,:) = [1e3*posixtime(datetime(dbObj.eventTable.init_TS(i), ...
                        'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z''', 'TimeZone','Etc/GMT')), ...
                    init_pos(1), init_pos(2), 0];
                pos_list(end,:) = [1e3*posixtime(datetime(latest_pos.timeStamp, ...
                        'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z''', 'TimeZone','Etc/GMT')), ...
                    latest_pos.latitude, latest_pos.longitude, latest_pos.accuracy];
            else
                error('Unknown json string. Please check:\n%s', dbObj.eventTable.latest_position(i))
            end
            % delete position entries with locationPrecision >= 100
            pos_list(pos_list(:,4)>=100,:) = [];

            % get the travelled time and distance
            dt_s = seconds(abs(diff(datetime(pos_list(:,1)*1e-3,'convertfrom','posixtime'))));
            ds_m = zeros(size(dt_s));
            for k = 1:size(pos_list,1)-1
                ds_m(k) = deg2km(distance(pos_list(k,2), pos_list(k,3), ...
                    pos_list(k+1,2), pos_list(k+1,3)));
            end
            
        end
        
        function loadEventCSV(dbObj, varargin)
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('csvPath',['\\sites.inside-share2.bosch.com@SSL\'...
                'DavWWWRoot\sites\150120\Documents\001_HC_Service_Reporting\'...
                'SO Data Export Semi.csv'],...
                @(x) ischar(x));
            p.parse(varargin{:})
%             v = p.Results.verbose;
            
            csvPath = p.Results.csvPath;
            %loadEvents   Load the csv table from the SO backend and create
            %a list of the corresponding HC_crashEvent objects

            % get first line to get column names
            fid = fopen(csvPath);
            varNames = textscan(fgetl(fid), '%s', 'Delimiter',';');
            fclose(fid);
            varNames = varNames{1}';
            
            opts = delimitedTextImportOptions("NumVariables", size(varNames,2));

            % Specify range and delimiter
            opts.DataLines = [2, Inf];
            opts.Delimiter = ";";
            
            % do we have the new csv data format from the SO epxport after
            % 12/2021? This does not contain the column
            % 'ticket_post_processing' (column 19), so we remove it from
            % the columns to be imported
            if size(varNames,2) < 43
                % new format (after 12/2021)
                
                % Specify column names and types
                opts.VariableNames = ["ID", "creation_TS", "closed_TS", "lang", ...
"with_outb_call", "msd_vs", "event_type", "event_cause","voice_flag", ...
"type_of_service", "type_of_service_TS", "userInvolvement", "documentation", ...
"no_of_casualities", "no_of_injured", "no_of_infants", "position_history", ...
"country",                          "tenant", "reporting_id", "trigger_type", ...
"severity", "vehicle_type", "trigger_TS", "init_TS", "LatLng", "accuracy", ...
"zipcode", "LatLngN1", "LatLngN2", "LatLngN3", "LatLngN4", "LatLngN5", "LatLngN6", ...
"LatLngN7", "LatLngN8", "LatLngN9", "number_callbacks", "latest_position", ...
"authorization_state", "msd_test_flag", "msisdn"];
                opts.VariableTypes = ["string", "string", "string", "categorical", ...
"categorical", "double", "double", "double", "categorical", ...
"categorical", "string", "double", "string", ...
"double", "double", "double", "string", ...
"string",                           "categorical", "categorical", "categorical", ...
"double", "double", "double", "double", "string", "string", ...
"string", "string", "string", "string", "string", "string", "string", ...
"double", "double", "double", "double", "string", ...
"categorical", "categorical", "double"];

                % Specify variable properties
                opts = setvaropts(opts, ["ID", "creation_TS", "closed_TS", ...
"type_of_service_TS", "documentation", "position_history", "country", "LatLng", ...
"accuracy", "zipcode", "LatLngN1", "LatLngN2", "LatLngN3", "LatLngN4", "LatLngN5", ...
"LatLngN6", "latest_position"], "WhitespaceRule", "preserve");
                opts = setvaropts(opts, ["ID", "creation_TS", "closed_TS", ...
"lang", "with_outb_call", "voice_flag", "type_of_service", "type_of_service_TS", ...
"documentation", "position_history", "country", "tenant", "reporting_id", ...
"trigger_type", "LatLng", "accuracy", "zipcode", "LatLngN1", "LatLngN2", ...
"LatLngN3", "LatLngN4", "LatLngN5", "LatLngN6", "latest_position", ...
"authorization_state", "msd_test_flag"], "EmptyFieldRule", "auto");
                opts = setvaropts(opts, ["init_TS", "LatLngN7", "LatLngN8", "LatLngN9"], "TrimNonNumeric", true);
                opts = setvaropts(opts, ["init_TS", "LatLngN7", "LatLngN8", "LatLngN9"], "ThousandsSeparator", ",");

            else
                % old format (before 12/2021)
                
                % Specify column names and types
                opts.VariableNames = ["ID", "creation_TS", "closed_TS", "lang", ...
"with_outb_call", "msd_vs", "event_type", "event_cause", "voice_flag", ...
"type_of_service", "type_of_service_TS", "userinvolvement", "documentation", ...
"no_of_casualities", "no_of_injured", "no_of_infants", "position_history", ...
"country", "ticket_post_processing", "tenant", "reporting_id", "trigger_type", ...
"severity", "vehicle_type", "trigger_TS", "init_TS", "LatLng", "accuracy", ...
"zipcode", "LatLngN1", "LatLngN2", "LatLngN3", "LatLngN4", "LatLngN5", "LatLngN6", ...
"LatLngN7", "LatLngN8", "LatLngN9", "number_callbacks", "latest_position", ...
"authorization_state", "msd_test_flag", "msisdn"];
                opts.VariableTypes = ["string", "string", "string", "categorical", ...
"categorical", "double", "double", "double", "categorical", ...
"categorical", "string", "double", "string", ...
"double", "double", "double", "string", ...
"categorical", "string", "categorical", "string", "categorical", ...
"double", "double", "string", "string", "string", "double", ...
"double", "string", "string", "string", "string", "string", "string", ...
"double", "double", "double", "double", "string", ...
"categorical", "categorical", "double"];
                
                % Specify variable properties
                opts = setvaropts(opts, [1, 2, 3, 11, 13, 17, 19, 21, 25, 26, 27, 30, 31, 32, 33, 34, 35, 40], "WhitespaceRule", "preserve");
                opts = setvaropts(opts, [36, 37, 38], "TrimNonNumeric", true);
                opts = setvaropts(opts, [36, 37, 38], "ThousandsSeparator", ",");
                opts = setvaropts(opts, [1, 2, 3, 4, 5, 9, 10, 11, 13, 17, 18, 19, 20, 21, 22, 25, 26, 27, 30, 31, 32, 33, 34, 35, 40, 41, 42], ...
                    "EmptyFieldRule", "auto");
            end
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";

            % Import the data from the csv file
            dbObj.eventTable = readtable(csvPath, opts);
        end
        
        function logFileList = loadLogFileList(dbObj, varargin)
            %Load available logfiles and determine time stamp of algo
            %trigger
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('timeSpanToLoad','lastMonth',@(x) ~isempty(intersect(x, ...
                {'all','lastMonth','2021-1','2021-2','2021-3'})))
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            uiwait(msgbox('Logfiles downloaded from SFTP and decrypted?','Download finished?','modal'))
            
            % decrypt the stuff
%             javaObject = BoschDataDecryption_Livebetrieb;
%             javaMethod('main', javaObject);

            % unzip all .gz files
            logFileList = dir(dbObj.decryptedFolder);
            % remove empty zip files
            logFileList([logFileList.bytes]<1000) = [];
            filesGZ = {logFileList(~cellfun(@isempty, regexp({logFileList.name}, '\.gz$'))).name}';
            % remove file extension
            filesGZ = cellfun(@(x) {x(1:end-3)}, filesGZ);
            filesCSV = {logFileList(~cellfun(@isempty, regexp({logFileList.name}, '\.csv$'))).name}';
            files2Unzip = setdiff(filesGZ, filesCSV);
            verb(v, 5, sprintf('Unpacking the following new files (Android):\n%s\n', sprintf('\t\t%s\n',files2Unzip{:})));
            cellfun(@(x) gunzip(fullfile(dbObj.decryptedFolder, [x, '.gz'])), files2Unzip);
            
            filesUnrecognizedIphone = {logFileList(~cellfun(@isempty, regexp({logFileList.name}, 'unrecognized.+\.zip$'))).name}';
            % remove file extension
            filesUnrecognizedIphone = cellfun(@(x) {x(1:end-4)}, filesUnrecognizedIphone);
            % zip file contain %3F (=?) or %3A (=:) which is not allowed in
            % file names
            [~, ia] = setdiff(regexprep(filesUnrecognizedIphone, '%3(F|A)', '_'), cellfun(@(x) {x(1:end-4)}, filesCSV));
            files2Unzip = filesUnrecognizedIphone(ia);
            verb(v, 5, sprintf('Unpacking the following new files (iOS):\n%s\n', sprintf('\t\t%s\n',files2Unzip{:})));
            curDir = cd;
            cd(dbObj.decryptedFolder)
            cellfun(@(x) system(['unzip ' (fullfile(dbObj.decryptedFolder, [x, '.zip']))]), files2Unzip);
            cd(curDir);
            
            logFileList = dir(dbObj.decryptedFolder);
            % remove zip packages from list (iOS is already unzipped,
            % Android is gzipped)
            logFileList(~cellfun(@isempty, regexp({logFileList.name}, '\.(zip|gz)'))) = [];
            % remove . and ..
            logFileList(~cellfun(@isempty, regexp({logFileList.name}, '^\.{1,2}$'))) = [];
            % for better handling now convert struct to table
            logFileList = struct2table(logFileList);
            % read the string of the logFile creation time stamp, including
            % time zone
            logFileList.creationTimeStamp = HC_crashEvent.logFileName2datetime(logFileList.name);
            
            switch p.Results.timeSpanToLoad
                case 'all'
                    % remove all files older than 1.1.2021
                    m = 1;
                    y = 2021;
                case 'lastMonth'
                    % remove all files older than the first of the last
                    % month
                    y = year(now);
                    m = month(now)-1;
                    if m==0
                        % handle year overflow
                        m = 12;
                        y = y-1;
                    end
                case '2021-1'
                    % similar to 'all': remove all files older than 1.1.2021
                    m = 1;
                    y = 2021;
                    % but do the acutal cropping here: Crop all after
                    % 1.9.2021
                    logFileList(logFileList.creationTimeStamp >= datetime(2021,9,1,'TimeZone','Europe/Berlin'),:) = [];
                case '2021-2'
                    % similar to 'all': remove all files older than 1.1.2021
                    m = 1;
                    y = 2021;
                    % but do the acutal cropping here: Crop all before
                    % 1.9.2021 and after 1.10.2021
                    logFileList(logFileList.creationTimeStamp < datetime(2021,9,1,'TimeZone','Europe/Berlin'),:) = [];
                    logFileList(logFileList.creationTimeStamp >= datetime(2021,10,1,'TimeZone','Europe/Berlin'),:) = [];
                case '2021-3'
                    % similar to 'all': remove all files older than 1.1.2021
                    m = 1;
                    y = 2021;
                    % but do the acutal cropping here: Crop all before
                    % 1.10.2021
                    logFileList(logFileList.creationTimeStamp < datetime(2021,10,1,'TimeZone','Europe/Berlin'),:) = [];
                otherwise
                    verb(v,3,'Only ''lastMonth'' and ''all'' allowed for TimeSpanToLoad')
                    % fill dummy values
                    m = 0;
                    y = 0;
            end
            logFileList(logFileList.creationTimeStamp < datetime(y,m,1,'TimeZone','Europe/Berlin'),:) = [];
            
            nbytes = fprintf('Processing logfile 0 of %d', size(logFileList,1));
            for i=1:size(logFileList,1)
                nbytes = fprintf([repmat('\b',1,nbytes), 'Processing logfile %d of %d\n'], i, size(logFileList,1))-nbytes;
                
                logFilePath = fullfile(logFileList.folder{i}, logFileList.name{i});
                logFile = Cobi_CrashAlgo_Logfile(logFilePath,'verbose',v-2,'plot',false);
                if ~isempty(logFile.data.logfile)
                    logFileList.logFile{i} = logFile;
                    logFileList.dtPlausCrash{i} = dbObj.getCrashTriggerFromLogfile(logFile);
                else
                    continue
                end
            end
            fprintf('Done.\n')
            dbObj.logFileList = logFileList;
        end
        
        function dtPlausCrash = getCrashTriggerFromLogfile(~, logFile, varargin)
            
            p = inputParser();
            p.addRequired('logFile', @(x) isscalar(x) && isa(x, 'Cobi_CrashAlgo_Logfile'))
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(logFile, varargin{:})
%             v = p.Results.verbose;
            
            
            data = logFile.getFileContent();
            
            % find falling edge of crash trigger
            cf = data.crashFire;
            cfShift = circshift(cf,1);
            cf(end) = 0; cfShift(1) = 0;
            tsPlausibleCrash_s = data.timeStampsStepExec(~cf & cfShift);
            % Check if a crash trigger is available. If not, the logfile
            % was triggered manually and the dtPlausCrash can be set to the
            % timestamp of the logfile.
            dtPlausCrash = datetime(tsPlausibleCrash_s, 'ConvertFrom', 'epochtime', ...
                'TicksPerSecond', 1, 'Format', 'dd-MMM-yyyy HH:mm:ss.SSS','TimeZone','UTC');
        end
    end
    
    methods (Static = true)
        function a = queryDatabase(varargin)
        % %%queryDatabase() static method. Read data from the DB and draw
        % % a graph.
        %
        % %% Syntax
        % %   resultTable = HC_crashDatabase.queryDatabase();
        % %
        % %   resultTable = HC_crashDatabase.queryDatabase('usageRatio', true, 'showReasons', 'all');
        % %
        % %% Input arguments
        % %  -
        % %
        % %% Optional arguments
        % %
        % % *key:* |'timeQuantization'|
        % % *value:* character array describing the quantization on the x-axis
        % % of the plot.
        % % Supported values: (|'week'|, {|'month'|})
        % %
        % % *key:* |'usageRatio'|
        % % *value:* logical value. Sets the y axis in relation to the
        % % usage metric (|true|, i.e. distance in km or time in hours) or
        % % just the plain numbers ({|false|}).
        % %
        % % *key:* |'showReasons'|
        % % *value:* character array describing which reasons should be
        % % shown. Supported values: (|'all'|, {|'some'|}, |'none'|).
        % %
        % %% Output
        % %
        % % |resultTable| contains the result of the SQL query, formatted
        % % as a table.
        
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('timeQuantization','month',@(x) ~isempty(intersect(x, {'week','month'})))
            p.addParameter('usageRatio',false, @(x) isscalar(x) && islogical(x));
            p.addParameter('showReasons','some', @(x) ~isempty(intersect(x, {'all','some','none'})));
            p.parse(varargin{:})
%             v = p.Results.verbose;
            bPerUnit = p.Results.usageRatio;
            sShowReasons = p.Results.showReasons;
            
            % get the database connection
            dbObj = HC_crashDatabase();
            dbCon = dbObj.dbCon;
            
            % some sample queries:
            %% extend table HC_events by type_of_service and get all columns:
%             a = select(dbCon, ['SELECT * FROM HC_events INNER JOIN type_of_service '...
%             'ON HC_events.type_of_service_id=type_of_service.ID WHERE HC_events.ID<20'])
            
            %% get the timestamps and the according severity description of the event
%             a = select(dbCon, ['SELECT HC_events.creation_TS, severity.description '...
%                 'FROM HC_events '...
%                 'INNER JOIN severity ON HC_events.severity_id=severity.ID '...
%                 'WHERE HC_events.ID<20'])
            
            %% same, but only from BSOCM:
%             a = select(dbCon, ['SELECT HC_events.ID, HC_events.creation_TS, severity.description, tenant.tenant '...
%                 'FROM ((HC_events INNER JOIN severity ON HC_events.severity_id=severity.ID) '...
%                 'INNER JOIN tenant ON HC_events.tenant_id=tenant.ID) WHERE HC_events.ID<20 AND tenant.tenant=''BSOCM''' ...
%                 'ORDER BY HC_events.creation_TS'])
            %% same, but for automatic calls only:
            tenant = {'BSOCM', 'BSOEB'};
            startYear = 2021;
            switch p.Results.timeQuantization
                case 'week'
                    % all weeks from 1.1.2021 until last week
                    lastWeek = weeknum(now,2,true)-1;
                    weeksPerYear = [weeknum(datetime(startYear:year(now)-1,12,31),2,true) lastWeek];
                    cumWeeksPerYear = [0 cumsum(weeksPerYear)];
                    timeAxis = (1: sum(weeksPerYear));
                    weeks2subtract = [];
                    for i=1:length(weeksPerYear)
                            weeks2subtract = [weeks2subtract, repmat(sum(weeksPerYear(1:i-1)),1,weeksPerYear(i))]; %#ok
                    end
                    labels = num2str(timeAxis-weeks2subtract);
                case 'month'
                    % all months from 1.1.2021 until the last entry in the
                    % DB
                    a = select(dbCon, 'SELECT due_date FROM monthly_usage ORDER BY due_date');
                    
%                     timeAxis = (1:(year(now)-startYear)*12+month(a.due_date(end)))';
                    timeAxis = unique(cellfun(@datetime, a.due_date));
                    timeAxis = timeAxis+days(1)-calmonths(1); % take the first of every month, not the last. Otherwise time axis in plot is wrong.
                    % 'month' doens't overflow but continues counting: 2021,13,1 is January 2022
%                     [~, labels] = month(datenum(2021,timeAxis,1));
            end
            for i=1:length(tenant)
                a = select(dbCon, ['SELECT HC_events.ID, HC_events.creation_TS, '...
                    'severity.description, tenant.description, trigger_type.trigger_type, '...
                    'event_cause.event_cause '...
                    'FROM ((((HC_events '...
                    'INNER JOIN trigger_type ON HC_events.trigger_type_id=trigger_type.ID) '...
                    'INNER JOIN severity ON HC_events.severity_id=severity.ID) '...
                    'INNER JOIN tenant ON HC_events.tenant_id=tenant.ID) '...
                    'LEFT OUTER JOIN event_cause ON HC_events.event_cause_id   =event_cause.ID) '...
                    'WHERE tenant.tenant=''', tenant{i}, ''' AND trigger_type.trigger_type=''auto''' ...
                    'ORDER BY HC_events.creation_TS']);
                tenantName{i} = a.description_1{1};%#ok
                
                if bPerUnit
                    % usage{i}.amount is only on monthly basis, not on
                    % weekly!
                    if strcmp(p.Results.timeQuantization, 'week')
                        error('on weekly level no ratio plot per ridden time/distance (''usageRatio == true'') is possible')
                    end
                    
                    % get the numbers for ridden distance/time
                    usage{i} = select(dbCon, ['SELECT '...
                        'tenant.description, monthly_usage.due_date, monthly_usage.amount, unit.unit '...
                        'FROM (monthly_usage '...
                        'INNER JOIN unit ON monthly_usage.unit_id=unit.ID) '...
                        'INNER JOIN tenant ON monthly_usage.tenant_id=tenant.ID '...
                        'WHERE tenant.tenant=''', tenant{i}, ''' ' ...
                        'ORDER BY monthly_usage.due_date']);%#ok
                end
                
                
                switch sShowReasons
                    case 'some'
                        % summarize some categories
                        a.event_cause(strcmp('realCrashNoPSAP', a.event_cause)) =   {'realCrash'};
                        a.event_cause(strcmp('wrongCal', a.event_cause)) =          {'bug fixed'};
                        a.event_cause(strcmp('resetAfterPause', a.event_cause)) =   {'bug fixed'};
                        a.event_cause(strcmp('noHubConnection', a.event_cause)) =   {'bug fixed'};
                        a.event_cause(strcmp('vibFixedByAbort', a.event_cause)) =  {'bug fixed'};
                        a.event_cause(strcmp('walking', a.event_cause)) =           {'misuse'};
                        a.event_cause(strcmp('phoneRemoved', a.event_cause)) =      {'misuse'};
                        a.event_cause(strcmp('phoneDown', a.event_cause)) =            {'misuse'};
                        a.event_cause(strcmp('bikeDown', a.event_cause)) =          {'misuse'};
                        a.event_cause(strcmp('phoneMountTilt', a.event_cause)) =    {'misuse'}; % this might be handled in the calibration module
                        a.event_cause(strcmp('noRide', a.event_cause)) =            {'misuse'};
                        a.event_cause(strcmp('rideNotEnded', a.event_cause)) =      {'misuse'};
                        a.event_cause(strcmp('', a.event_cause)) =                  {'unknown'};
                        a.event_cause(strcmp('unassessed', a.event_cause)) =        {'unknown'};
                        a.event_cause(strcmp('unassessible', a.event_cause)) =      {'unknown'};
                        a.event_cause(strcmp('speedSignalHangs', a.event_cause)) =  {'known bug'};
                        a.event_cause(strcmp('fastSpeedChange', a.event_cause)) =   {'known bug'};
                
                        eventCauseList = union({'realCrash','unknown','misuse',...
                            'vibrations','repeatedTrigger','known bug','bug fixed',...
                            'algoTest'}, unique(a.event_cause)', 'stable');
                    otherwise % 'all' and 'none'
                        a.event_cause(strcmp('', a.event_cause)) =                  {'unknown'};
                        eventCauseList = unique(a.event_cause);
                end
                ctsPerCat{i} = zeros(length(timeAxis), length(eventCauseList)); %#ok
                for j=1:length(eventCauseList)
                    idx = strcmp(eventCauseList{j},a.event_cause);
                    % is there any event of this type (eventCauseList{j})
                    % for this tenant?
                    if any(idx)
                        switch p.Results.timeQuantization
                            case 'week'
                                % get the calendar week number (the week
                                % starting on mondays (,2) and week
                                % numbering is european standard (, true))
                                % of the timestamps and match these the
                                % corresponding timestamps. Handle also
                                % weeknum overflow after change of year.
                                % Some years have 53 weeks, although most
                                % do have 53 (e.g. 2028)
                                % weeknum(datetime(2026:2029-1,12,31)) = [53 53 54]
                                error('Quantization by week does not work currently. Problem is that 02.01.2022 is CW 52 and not 1')
                                [timeCategory,~,ix] = unique(weeknum(a.creation_TS(idx),2,true) + cumWeeksPerYear(year(a.creation_TS(idx))-startYear+1)); 
                            case 'month'
                                % get month number since 1.1. of startYear
                                [timeCategory,~,ix] = unique(month(a.creation_TS(idx)) + (year(a.creation_TS(idx))-startYear)*12);
                        end
                    else
                        timeCategory = double.empty(0,1);
                        ix = double.empty(0,1);
                    end
                    cts = accumarray(ix, 1);
                    ctsPerCat{i}(timeCategory,j) = cts;
                end
                
                figure
                if bPerUnit
                    switch sShowReasons
                        case 'none'
                            % usage{i}.amount is only on monthly basis, not on
                            % weekly!
                            bar(timeAxis, sum(ctsPerCat{i},2)./double(usage{i}.amount)*1000)
                        case 'some'
                            hb = bar(timeAxis, ctsPerCat{i}./double(usage{i}.amount)*1000,'stacked');
                        case 'all'
                            % Create a bar chart that uses colormap colors
                            % by setting the FaceColor property to 'flat'.
                            % Then set the CData property for each Bar
                            % object to an integer.
                            hb = bar(timeAxis, ctsPerCat{i}./double(usage{i}.amount)*1000,'stacked','FaceColor','flat');
                            for j=1:length(hb),hb(j).CData=j;end
                    end
                    ylabel(['Events per 1000 ', usage{i}.unit{1}])
                else
                    switch sShowReasons
                        case 'none'
                            % usage{i}.amount is only on monthly basis, not on
                            % weekly!
                            bar(timeAxis, sum(ctsPerCat{i},2))
                        otherwise % 'all' and 'some'
                            hb = bar(timeAxis, ctsPerCat{i},'stacked');
                    end
                    ylabel('Number of Events')
                end
%                 xticks(timeAxis)
%                 xticklabels(labels);
                switch p.Results.timeQuantization
                    case 'week'
                        title(['Crash events per calendar week: ', tenantName{i}])
                        xlabel('Calendar week')
                    case 'month'
                        title(['Crash events per month: ', tenantName{i}])
                        xlabel('Month')
                    otherwise
                        error('Only ''month'' and ''week'' are supported')
                end
                switch sShowReasons
                    case 'some'
                        hb(1).FaceColor = [0.2 0.8 0.2]; % real crash: green
                        hb(5).FaceColor = [1 1 0]; % repeatedTrigger: yellow
                        legend(flip(hb), flip(eventCauseList),'location','best')
                    case 'all'
                        legend(flip(hb), flip(eventCauseList),'location','best')
                    otherwise % 'none'
                        
                end
            end
            
            %%
            
            % weitere Ideen: Farbig markieren nach root_cause, nach
            % severity, nach 'classification_IO' (bzw. besserem Namen...)
            % Auswertung: Folgeauslösungen detektieren, damit dort manuell
            % genauer nachgesehen werden kann.
            
            close(dbCon)
        end
        
        function success = regressionTest()
            success = true;
            dbObj =  HC_crashDatabase();
            % define tests as function handles:
            
            % check that dbCon is a valid connection
            testCase{1} = @() checkDBCon(dbObj);
            function success = checkDBCon(dbObj)
                success = isa(dbObj.dbCon, 'database.odbc.connection');
            end
            
            % check if events in eventList are of class HC_crashEvent
            testCase{2} = @() checkLoadEvents(dbObj);
            function success = checkLoadEvents(dbObj)
                % disable warnings to keep screen clear
                s=warning;
                warning('off')
                dbObj.loadEvents(); % calls loadEventCSV() and createEventList()
                warning(s)
                success = isa(dbObj.eventList(1), 'HC_crashEvent');
            end
            
            % check if database query works
            testCase{3} = @() checkGetDetailsFromDatabase(dbObj);
            function success = checkGetDetailsFromDatabase(dbObj)
                success = false;
                % for time reasons: take only two events
                event(1) = datetime(2022,6,19,11,13,25,'TimeZone','Europe/Berlin');
                event(2) = datetime(2022,5,28,16,03,24,'TimeZone','Europe/Berlin');
                dbObj.eventList(~(arrayfun(@isequal, [dbObj.eventList.creation_TS], repmat(event(1), 1,length(dbObj.eventList))) ...
                    | arrayfun(@isequal, [dbObj.eventList.creation_TS], repmat(event(2), 1,length(dbObj.eventList))))) = [];
                dbObj.getDetailsFromDatabase();
                %check event_cause of the first event and meanSpeed_kmh for
                %the second
                if strcmp(dbObj.eventList(1).event_cause, 'phoneRemoved') ...
                        && abs(dbObj.eventList(2).meanSpeed_kmh-46.8) < 0.5
                    success = true;
                end
            end
            
            
            % to be tested:
%                 mappingList = exportEventsToDB(dbObj, varargin)
%
%                 updateEventsInDB(dbObj, parNames, varargin)
% 
%                 updateLogFileData(dbObj)
% 
%                 mappingList = findMatchingLogfiles(dbObj, varargin); % contains loadLogfileList(), getCrashTriggerFromLogfile
% 
%                 a = simulateAllMbikeEvents(dbObj, varargin);

            try
                % run all the tests
                for i=1:length(testCase)
                    %%
                    if testCase{i}()
                        success = success & true;
                        fprintf('Test %g passed.\n', i)
                    else
                        % this test failed, so the whole unit test has failed
                        success = success & false;
                        fprintf(2,'\tTest %g failed: %s\n\n', i, char(testCase{i}));
                    end
                end
            catch me
                % this test failed, so the whole unit test has failed
                success = success & false;
                fprintf(2,'\tFailed! Program abort with the following message:\n%s\n\n', me.getReport);
            end
            
            if ~success
                warning('There were errors in the regression test.')
            else
                fprintf('All tests passed without errors.\n')
            end
        end
    end
end