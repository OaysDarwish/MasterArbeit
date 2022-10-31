classdef HC_crashEvent < handle
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
    % % @ File Name: HC_crashEvent.m
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
    % %                         !!!<a href="matlab:open(which('HC_crashEvent.html'))">HC_crashEvent</a>!!!
    % %
    % %
    
    properties
        % database connection
        dbCon
        % time stamp in 'Europe/Berlin' when the MSD was received at the backend 
        creation_TS
        % ID in the database
        ID
        % documentation of the agent what kind of service was delivered
        type_of_service
        % specified if this was a test event or not
        msd_test_flag
        % text documentation of the agent
        documentation
        % tenant of the HC system (i.e. ID of B2B customer)
        tenant
        % manual or automatic trigger
        trigger_type
        % severity of the event (1-marginal, 2-low, 3-moderate, 4-high)
        severity
        % path to the logfile
        logFilePath = ''
        % link to the logfile object
        logFile
        % type of operating system where the event was triggered
        % (iOS/Android)
        os_type
        % number of crash triggers in the logfile
        numCFfire
        % time stamp of the falling edge of plausible crash flag
        plausCrash_TS
        % Delta t from crash trigger in log file to event creation in
        % backend
        dtCrashTrigger2Event_s
        % Delta t from crash trigger to creation of logfile
        dtCrash2Logfile_s
        % root cause of of the event (real crash of cause of FP)
        event_cause
        % crash classification of crash algo
        crashClass
        % Sum of square mean angles (during v>10km/h?)
        sumSquareMeanAngles
        % length of logfile content (number of samples)
        logFileLength_s
        % logged time interval
        logFileDuration_s
        % sampling frequency
        samplingFreq_Hz
        % mean velocity
        meanSpeed_kmh
        % elapsed time in seconds between first and last GPS location
        elapsedGPStime_s
        % moved distance in metres after trigger (calculated via GPS location)
        movedGPSdist_m
        % mean velocity in km/h after trigger (calculated via GPS location)
        meanGPSspeed_kmh
        % version of motorbike calibration module (MCAL)
        vMCAL
        % version of crash algo (CRCL)
        vCRCL
        % list of tables that have constraints so the key values must be
        % fetched
        constraintList = {'severity','type_of_service','tenant', ...
                'trigger_type','event_cause','os_type'};
    end
    
    methods
        function eventObj = HC_crashEvent(dbCon, identifier, varargin)
            % %%HC_crashEvent   Create a Help Connect crash event object
            % % This object can export itself to the crash database (run
            % % HC_crashEvent.exportToDatabase() ) or the logfile can be
            % % simulated via Simulink (run HC_crashEvent.simulateEvent() ).
            %
            % %% Syntax
            % %   dbObj = HC_crashDatabase();
            % %   dbCon = dbObj.dbCon;
            % %   eventObj = HC_crashEvent(2598, dbCon) % gets the event via its
            % ID
            % %
            % %   eventObj = HC_crashEvent('2021-05-12T15:58:10') % gets
            % the event via its timestamp
            % %
            % %% Input arguments
            % % 
            % % |identifier| contains either an ID (in digits) or a
            % % timestamp (as character array)
            % %
            % %% Output
            % %
            % % |eventObj| is an object containing the event properties.
            
            
            % check input parameter
            p = inputParser();
            p.addParameter('verbose',5,@(x)isscalar(x) && isnumeric(x));
            p.addRequired('dbCon',@(x) isscalar(x) && isa(x, 'database.odbc.connection'));
            p.addRequired('identifier',@(x)(ischar(x) && isa(datetime(x, ...
                'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss', 'TimeZone','Etc/GMT'), 'datetime')) ...
                || (isscalar(x) && isnumeric(x)));
            p.parse(dbCon, identifier, varargin{:})
%             v = p.Results.verbose;
            eventObj.dbCon = dbCon;

            if ischar(identifier)
                timeStamp = identifier;
                eventObj.creation_TS = datetime(timeStamp, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss', 'TimeZone','Etc/GMT');
            else
                res = select(dbCon, ['SELECT creation_TS from HC_events WHERE ID=', num2mstr(identifier)]);
                timeStamp = res.creation_TS{1};
                eventObj.creation_TS = datetime(timeStamp, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSSSSSS', 'TimeZone','Europe/Berlin');
            end

            eventObj.creation_TS.TimeZone = 'Europe/Berlin';
        end
        
        function setTypeOfService(eventObj, serviceType)
            % Set the service_type of the event
            
            eventObj.type_of_service = serviceType;
        end
        
        function setDocumentation(eventObj, docText)
            % Set the agent documentation of the event
            
            eventObj.documentation = docText;
        end
        
        function setTriggerType(eventObj, trigger)
            % Set the trigger_type of the event
            
            eventObj.trigger_type = trigger;
        end
        
        function setSeverity(eventObj, severity)
            % Set the severity of the event
            
            eventObj.severity = severity;
        end
        
        function setTenant(eventObj, tenant)
            % Sets the tenant of the event
            
            eventObj.tenant = tenant;
        end
        
        function setGPSmovement(eventObj, dist_m, dt_s)
            %setGPSmovement stores travelled distance and calculates
            % travelled velocity
            
            eventObj.elapsedGPStime_s = dt_s;
            eventObj.movedGPSdist_m = dist_m;
            if dt_s ~= 0
                eventObj.meanGPSspeed_kmh = eventObj.movedGPSdist_m/dt_s*3.6;
            else
                if dist_m < 0
                    % this means no GPS location was found, so speed is
                    % invalid
                    eventObj.meanGPSspeed_kmh = -1;
                else
                    % when dt = 0 and ds >= 0 velocity is hard set to zero
                    eventObj.meanGPSspeed_kmh = 0;
                end
            end
        end
        
        function id = existsInDatabase(eventObj, varargin)
            % Checks if an event with the same time stamp is already in the
            % database
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
%             v = p.Results.verbose;
            
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            % check if this event is already in the database
            sqlquery = sprintf('SELECT ID FROM HC_events WHERE creation_TS = {ts ''%s''}', ...
                ds);
            data = table2cell(select(eventObj.dbCon,sqlquery));
            if isempty(data)
                id = 0;
            else
                id = data{1};
            end
            
            eventObj.ID = id;
        end
        
        function eventObj = getDetailsFromDatabase(eventObj, varargin)
            %gets the event, based on the timestamp, from the database
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            
            if eventObj.existsInDatabase()
a = select(eventObj.dbCon, ['SELECT type_of_service.type_of_service, HC_events.documentation, '...
    'tenant.tenant, trigger_type.trigger_type, severity.severity, '...
    'event_cause.event_cause, os_type.os_type, HC_events.numCFfire, '...
    'HC_events.dtCrashTrigger2Event_s, HC_events.crashClass, HC_events.logFilePath, '...
    'HC_events.sumSquareMeanAngles, HC_events.msd_test_flag, '...
    'HC_events.logFileLength_s, HC_events.logFileDuration_s, HC_events.samplingFreq_Hz, '...
    'HC_events.meanSpeed_kmh, HC_events.vMCAL, HC_events.vCRCL, HC_events.dtCrash2Logfile_s, '...
    'HC_events.plausCrash_TS, '...
    'HC_events.movedGPSdist_m, HC_events.meanGPSspeed_kmh, elapsedGPStime_s '...
    'FROM ((((((HC_events '...
    'INNER JOIN trigger_type       ON HC_events.trigger_type_id    =trigger_type.ID) '...
    'INNER JOIN severity           ON HC_events.severity_id        =severity.ID) '...
    'INNER JOIN tenant             ON HC_events.tenant_id          =tenant.ID) '...
    'LEFT OUTER JOIN event_cause ON HC_events.event_cause_id   =event_cause.ID) '... % OUTER JOIN since event_cause might not be filled, so no record would be returned with a INNER JOIN
    'LEFT OUTER JOIN os_type       ON HC_events.os_type_id         =os_type.ID) '...
    'INNER JOIN type_of_service    ON HC_events.type_of_service_id =type_of_service.ID) '...
    'WHERE creation_TS = {ts ''', ds, '''}']);
                colNames = a.Properties.VariableNames';
                for i=1:size(a,2)
                    if iscell(a.(colNames{i}))
                        eventObj.(colNames{i}) = a.(colNames{i}){1};
                    else
                        eventObj.(colNames{i}) = a.(colNames{i})(1);
                    end
                end
            else
                verb(v, 5, sprintf('The module with the time stamp %s was not found in the database.', ds))
            end
        end
        
        function eventObj = getLogfile(eventObj, varargin)
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            if ~isempty(eventObj.logFilePath)
                eventObj.logFile = Cobi_CrashAlgo_Logfile(eventObj.logFilePath,'verbose',v-2);
                eventObj.setLogFileMetadata();
            end
        end
        
        function updateInDatabase(eventObj, parNames, varargin)
            % Update specific fields of an event that is already in the
            % database
            %
            % Syntax example (just fill in new values into empty fields):
            % eventObj.updateInDatabase({'logFilePath','os_type','crashClass','dtCrashTrigger2Event_s','sumSquareMeanAngles','numCFfire','logFileLength_s','logFileDuration_s','samplingFreq_Hz','meanSpeed_kmh','vMCAL','vCRCL','dtCrash2Logfile_s'})
            %
            % Syntax example (overwrite existing filled values):
            % eventObj.updateInDatabase({'logFilePath','os_type','crashClass','dtCrashTrigger2Event_s','sumSquareMeanAngles','numCFfire','logFileLength_s','logFileDuration_s','samplingFreq_Hz','meanSpeed_kmh','vMCAL','vCRCL','dtCrash2Logfile_s'},'overwrite',true)
            
            
            
            
            % TODO: Add default option to update all fields related to a
            % changed logFile
            % e.g.:
% eventObj.updateInDatabase({'os_type','crashClass','dtCrashTrigger2Event_s','sumSquareMeanAngles','numCFfire','logFileLength_s','logFileDuration_s','samplingFreq_Hz','meanSpeed_kmh','vMCAL','vCRCL','dtCrash2Logfile_s'},'overwrite',true)
            
            p = inputParser();
            % parNames must be a 1-by-n cell array, e.g.
            % {'documentation','trigger_type'}
            p.addRequired('parNames',@(x) iscell(x) && all(cellfun(@ischar, x)) && size(x,1) == 1);
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.addParameter('overwrite',false,@(x) isscalar(x) && islogical(x));
            p.parse(parNames, varargin{:})
            v = p.Results.verbose;
            bOverwrite = p.Results.overwrite;
            
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            % check if this event is already in the database
            id = eventObj.existsInDatabase();
            
            % when the event is not yet in the database, we want to store
            % it there
            if id
                
                % check if the fiels subject to change are already filled
                fieldsNot2Touch = {};
                if ~bOverwrite
                    % store data that might be changed in this object for
                    % later use
                    for i=1:length(parNames)
                        newData.(parNames{i}) = eventObj.(parNames{i});
                    end
                    
                    % here all object data is overwritten by data from the
                    % database
                    eventObj.getDetailsFromDatabase();
                    
                    for i=1:length(parNames)
                        % don't overwrite data in the database if there is
                        % already something (not NaN) in or if the new
                        % value is identical with the already stored one
                        if (~isempty(eventObj.(parNames{i})) && any(~isnan(eventObj.(parNames{i})))) || isequaln(eventObj.(parNames{i}), newData.(parNames{i}))
                            fieldsNot2Touch{end+1} = parNames{i}; %#ok
                        end
                        
                        % re-store the new data in the event object
                        % (was overwritten by DB-data with
                        % getDetailsFromDatabase()) so it doesn't get
                        % lost
                        eventObj.(parNames{i}) = newData.(parNames{i});
                    end
                    if ~isempty(fieldsNot2Touch)
                        verb(v, 5, sprintf(['The field(s) %salready '...
                            'contain data in the database or there is no change for event %s. They will not '...
                            'be overwritten.'], sprintf('''%s'' ', fieldsNot2Touch{:}), ds));
                    end
                end
                
                % write only data for fields that are allowed to touch
                parNames = setdiff(parNames, fieldsNot2Touch);
                
                if ~isempty(parNames)
                    % convert the struct to a cell that can directly written
                    % to the database (if the column names are valid db-column
                    % identifiers)
                    m = eventObj.getTableKeys(parNames, 'verbose', v);
                    payload = struct2cell(m)';
                    colNames = fieldnames(m)';
                    try
                        %write the new data to the event in database
                        update(eventObj.dbCon, 'HC_events', colNames, payload, ['WHERE creation_TS = {ts ''', ds, '''}']);
                        verb(v, 5, sprintf('Updated field(s) %sof event %s.', sprintf('''%s'' ', colNames{:}), ds));
                    catch me
                        verb(v, 4, sprintf(['\nUpdating data for event from'...
                            ' %s to the database FAILED. The following '...
                            'problem ocurred: \n%s '], ds, me.message));
                    end
                end
            else
                verb(v, 5, sprintf('The module with the time stamp %s was not found in the database.', ds))
            end
        end
        
        function updateLogFileDataInDatabase(eventObj)
            % updateLogFileDataInDatabase gets the content of the logFile,
            % calculates all derived values freshly via
            % setLogFileMetadata() (called in getLogFile()) and updates
            % these values in the database
            
            eventObj.getDetailsFromDatabase(); % getting mainly the logFilePath
            eventObj.getLogfile();   % loading logfile and calculating metadata (!!!)
            close all
            eventObj.updateInDatabase({'os_type','crashClass','dtCrashTrigger2Event_s','sumSquareMeanAngles','numCFfire','logFileLength_s','logFileDuration_s','samplingFreq_Hz','meanSpeed_kmh','vMCAL','vCRCL','dtCrash2Logfile_s'},'overwrite',true)
        end
        
        function m = getTableKeys(eventObj,keyList, varargin)
            %getTableKeys   Get the key values of relational connected
            % tables.
            % 
            % Syntax:
            % m = eventObj.getTableKeys(eventObj.constraintList);
            
            p = inputParser();
            % parNames must be a 1-by-n cell array, e.g.
            % {'documentation','trigger_type'}
            p.addRequired('keyList',@(x) iscell(x) && all(cellfun(@ischar, x)) && size(x,1) == 1);
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(keyList, varargin{:})
            v = p.Results.verbose;
            
            for i=1:length(keyList)
                if ~isempty(intersect(keyList{i}, eventObj.constraintList))
                    % these tables are relationally connected so for
                    % writing the element into the database the
                    % corresponding key from the foreign table mus be
                    % written
                    m.([keyList{i}, '_id']) = double(getKey(eventObj, keyList{i}, v));
                else
                    % a key is not necessary, so the original value can be
                    % returned
                    m.(keyList{i}) = eventObj.(keyList{i});
                end
            end
                
            function key = getKey(eventObj, keyName, v)
                if ~isempty(eventObj.(keyName))
                    % get the ID for the severity from the Database
                    if isnumeric(eventObj.(keyName)),f='%g'; else, f='''%s''';end
                    key = eventObj.retrieveDBdata(eventObj.dbCon, ...
                        sprintf(['SELECT ID FROM %s WHERE %s = ', f], ...
                            keyName, keyName, eventObj.(keyName)), v, 3, ...
                            sprintf('The %s ''%s'' is currently not supported in the DB.', ...
                                keyName, eventObj.(keyName)));
                    key = key{:};
                else
                    % (keyName) is not set, so it can't be retrieved from
                    % DB, so the value from the object is returned
                    key = eventObj.(keyName);
                end
            end
        end
        
        function exportToDatabase(eventObj, varargin)
            % Export all important data of the event to the database
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            % check if this event is already in the database
            id = eventObj.existsInDatabase();
            
            % when the event is not yet in the database, we want to store
            % it there
            if ~id
                m = eventObj.getTableKeys(eventObj.constraintList);
                
                % set the creation timestamp
                m.creation_TS = ds;
                % set the documentation
                m.documentation = eventObj.documentation;
                % set the path to the logfile
                m.logFilePath = eventObj.logFilePath;
                % test flag
                m.msd_test_flag = eventObj.msd_test_flag;
                % set number of crash triggers in logfile
                m.numCFfire = eventObj.numCFfire;
                % set crash class
                m.crashClass = eventObj.crashClass;
                % set Delta t from crash trigger in log file to event
                % creation in backend
                m.dtCrashTrigger2Event_s = eventObj.dtCrashTrigger2Event_s;
                % Delta t from crash trigger to creation of logfile
                m.dtCrash2Logfile_s = eventObj.dtCrash2Logfile_s;
                % set sum of square mean angles (during v>10km/h?)
                m.sumSquareMeanAngles = eventObj.sumSquareMeanAngles;
                % Sum of square mean angles (during v>10km/h?)
                m.sumSquareMeanAngles = eventObj.sumSquareMeanAngles;
                % length of logfile content (number of samples)
                m.logFileLength_s = eventObj.logFileLength_s;
                % logged time interval
                m.logFileDuration_s = eventObj.logFileDuration_s;
                % sampling frequency
                m.samplingFreq_Hz = eventObj.samplingFreq_Hz;
                % mean velocity
                m.meanSpeed_kmh = eventObj.meanSpeed_kmh;
                % elapsed GPS time
                m.elapsedGPStime_s = eventObj.elapsedGPStime_s;
                % moved distance via GPS locations
                m.movedGPSdist_m = eventObj.movedGPSdist_m;
                % mean speed via GPS locations
                m.meanGPSspeed_kmh = eventObj.meanGPSspeed_kmh;
                % version of calibration module
                m.vMCAL = eventObj.vMCAL;
                % version of crash algorithm
                m.vCRCL = eventObj.vCRCL;
                % add the time of inserting
                m.insertingTimestamp = datestr(datetime('now'), ...
                    'yyyy-mm-dd HH:MM:ss');
                    
                % convert the struct to a table that can directly written
                % to the database (if the column names are valid db-column
                % identifiers)
                payload = struct2table(m,'AsArray',true);
                % write the new event into the database
                try
                    %insert the new event into database
                    sqlwrite(eventObj.dbCon, 'HC_events', payload);
                    verb(v, 5, sprintf(['New event from %s was '...
                        'added to the Database.'], ds));
                catch me
                    verb(v, 4, sprintf(['\nAdding new event from'...
                        ' %s to the database FAILED. The following '...
                        'problem ocurred: \n%s '], ds, me.message));
                end
            else
                verb(v, 5, sprintf('The module with the time stamp %s is already in the DB with ID %g.', ...
                    ds, id))
            end
        end
        
        function deleteFromDatabase(eventObj, varargin)
            % Delete the event with this time stamp from the DB.
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            % check if event is in the database
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            % check if this event is already in the database
            sqlqueryCheck = sprintf('SELECT ID FROM HC_events WHERE creation_TS = {ts ''%s''}', ...
                ds);
            curs = exec(eventObj.dbCon,sqlqueryCheck);
            % get the data
            curs = fetch(curs);
            
            % when the event is not yet in the database, we want to store
            % it there
            if strcmp(curs.Data, 'No Data')
                verb(v,5, 'The event is not in the database and, hence, can''t be deleted.')
            else
                sqlqueryDelete = sprintf('DELETE FROM HC_events WHERE creation_TS = {ts ''%s''}', ...
                    ds);
                exec(eventObj.dbCon,sqlqueryDelete);
                
                curs = exec(eventObj.dbCon,sqlqueryCheck);
                %save the message in case the next statement gives an error
                %(this changes also the cursor and the original error messge is
                %gone).
                cMsg = curs.Message;
                % get the data
                curs = fetch(curs);
                if strcmp(curs.Data, 'No Data')
                    verb(v, 5, 'Sucessfully deleted event from database.')
                else
                    verb(v, 3, sprintf('Someting went wrong while deleting the event:\n%s', cMsg))
                end
            end
        end
        
        function plotOverview(eventObj, varargin)
            
            p = inputParser();
            p.addParameter('verbose',5,@(x) isscalar(x) && isnumeric(x));
            p.parse(varargin{:})
            v = p.Results.verbose;
            
            ds = datestr(eventObj.creation_TS, 'yyyy-mm-dd HH:MM:ss');
            if isempty(eventObj.logFilePath)
                % in this case maybe getDetailsFromDatabase was not yet
                % called so we call it and check if the path still is
                % empty. Only in that case re return.
                eventObj.getDetailsFromDatabase();
                if isempty(eventObj.logFilePath)
                    verb(v,5,sprintf('No logfilepath for this event: %s', ds))
                    return
                end
            end
            
            if isempty(eventObj.logFile)
                eventObj.getLogfile();
            end
            
            d = eventObj.logFile.data;
            
%             figure
            fh = gcf;
            fh.Name = sprintf('ID: %g (%s)', eventObj.ID, eventObj.creation_TS);
            %%
            dRaw = d.logfile;
            
            ax = subplot(231);
            plot(d.timeVectorAcc, d.speed_kmh);
            ylabel('speed / km/h')
            title('Velocity')
            grid on
            
            ax(2)=subplot(233);
            plot(d.timeVectorAcc, d.crashClass)
            title('Crash Class')
            ylabel('t / s')
            grid on
            
            ax(3)=subplot(232);
            plot(d.timeVectorAcc, [d.AccSfX_mg, d.AccSfY_mg, d.AccSfZ_mg])
            legend('x','y','z')
            ylabel('acc / mg')
            title('Acceleration')
            grid on
            
            ax(end+1)=subplot(235);
            plot(d.timeVectorAcc, [d.GyrSfX_mdegs, d.GyrSfY_mdegs, d.GyrSfZ_mdegs])
            legend('x','y','z')
            ylabel('angular rate / mdeg/s')
            title('Gyro')
            xlabel('t / s')
            grid on
            
            if length(d.timeStampsStepExec) == length(d.timeVectorAcc)
                ax(end+1) = subplot(234);
    %             plot(datetime(dRaw.accTime,'ConvertFrom', 'epochtime'), '.');
                tEx = datetime(d.timeStampsStepExec,'ConvertFrom', 'epochtime','TimeZone','Etc/GMT');
                tEx.TimeZone = 'Europe/Berlin';
                plot(d.timeVectorAcc, tEx, '.');
    %             hold on
    %             plot(dRaw.accTime-dRaw.accTime(1));
    %             plot(dRaw.gyrTime-dRaw.accTime);
                grid on
                ylabel('t_{exec}')
                xlabel('t / s')
                title('algo execution time stamp')
            end
            
            isTableCol = @(t, colName) ismember(colName, t.Properties.VariableNames);
            if isTableCol(dRaw, 'rollDeg')
                ax(end+1)=subplot(236);
                plot(d.timeVectorAcc, [dRaw.rollDeg, dRaw.pitchDeg]);
                legend('roll', 'pitch','location','best')
                title('Euler Angles')
                xlabel('t / s')
                grid on
            end
            
            linkaxes(ax, 'x')
            
            zoom on
            %%
            % get a dwopdown and fill it with the root causes
            eventCauseList = select(eventObj.dbCon, 'SELECT ID, event_cause, description FROM event_cause ORDER BY ID');
            eventData = select(eventObj.dbCon, ['SELECT event_cause_id, documentation FROM HC_events WHERE ID = ', num2str(eventObj.ID)]);
            eventCause = eventData.event_cause_id(1);
            c = uicontrol(fh, 'Style','popupmenu','String',eventCauseList.event_cause);
            if eventCause > 0
                c.Value = find(eventCauseList.ID == eventCause, 1);
            else
                c.Value = 1;
            end
            c.Position = [20 20 120 20];
            c.Callback = {@selection, c, eventObj};
            
            uicontrol(fh, 'Style', 'text', 'String', 'HC assistant docu:', 'Position', [20 200 120 20]);
            uicontrol(fh, 'Style', 'text', 'String', eventData.documentation{1}, 'Position', [20 40 120 150]);
            
            pb = uicontrol(fh, 'Style', 'pushbutton', 'String', 'Simulate event', 'Position', [160 20 120 20]);
            pb.Callback = {@cbSimEvent, eventObj};
            
            function selection(~, ~, c, eventObj)
                val = c.Value;
                str = c.String;
%                 str{val};
                eventObj.event_cause = str{val};
                eventObj.updateInDatabase({'event_cause'},'overwrite', true);
                disp(['Set event_cause to: ' str{val}]);
            end
            
            function cbSimEvent(~, ~, eventObj)
                eventObj.simulateEvent;
                open('SDI_crashOverview.mldatx')
            end
        end
        
        function simulateEvent(eventObj)
            %simulateEvent   Run the simulink model on the logfile of this
            %event
            
            
            if isempty(eventObj.logFile)
                % get metadata from DB
                eventObj.getDetailsFromDatabase();
            end
            
            if isempty(eventObj.logFile)
                % get data from logfile
                eventObj.getLogfile();
            end
            
            if ~isempty(eventObj.logFile)
                % 'data' is needed for simulation
                data = eventObj.logFile.getSimulationData();
                assignin('base', 'data', data)

                sim('CrashAlgo_TestEnvironment_Motorrad_v2')
            end
        end
    end
    
    methods (Hidden = true)
        
        function setLogFileMetadata(eventObj)
        %setLogFileMetadata sets all metadata related to the crash algo
        % logfile. The eventObj needs an already loaded logfile
        % (eventObj.logFile)
            
            if ~isempty(eventObj.logFile)
                % find the sample before falling edge of crash trigger
                data = eventObj.logFile.getFileContent();
                cf = data.crashFire;
                cfShift = circshift(cf,-1);
                cf(1) = 0; cfShift(end) = 0;
                eventObj.crashClass = data.crashClass(cf & ~cfShift);
                if numel(eventObj.crashClass) > 1
                    eventObj.crashClass = eventObj.crashClass(1);
                end

                idxCrashTrigger = find(cf & ~cfShift)+1;
                idxCrashTrigger(idxCrashTrigger>length(cf)) = length(cf);
                dtPlausCrash = data.timeStampsStepExec(idxCrashTrigger);
                if dtPlausCrash ~= 0
                    dtPlausCrash = datetime(dtPlausCrash, 'ConvertFrom', 'epochtime', ...
                        'TicksPerSecond', 1, 'Format', 'dd-MMM-yyyy HH:mm:ss.SSS','TimeZone','UTC');
                else
                    % we might have a cobi iPhone logfile where
                    % timeStampsStepExec is empy. In this case the time
                    % stamp of the logfile is the time where the first
                    % sample was recorded
                    dtPlausCrash = HC_crashEvent.logFileName2datetime(eventObj.logFile.filePath) + seconds(idxCrashTrigger/100);
                end
                eventObj.numCFfire = length(dtPlausCrash);
% TODO: Der Crash ist nicht unbedingt der letzte in der Liste! Beispiel: ...?
                eventObj.plausCrash_TS = dtPlausCrash(end);
                eventObj.dtCrashTrigger2Event_s = seconds(eventObj.creation_TS-eventObj.plausCrash_TS);
                eventObj.dtCrash2Logfile_s = seconds(HC_crashEvent.logFileName2datetime(eventObj.logFile.filePath)-eventObj.plausCrash_TS);
                eventObj.os_type = eventObj.logFile.osType;

                % Sum of square mean angles (during v>10km/h?)
    %             a = sqrt(mean(data.logfile.rollDeg)^2+mean(data.logfile.pitchDeg)^2);
                b = sqrt(mean(data.logfile.rollDeg(data.speed_kmh>10))^2+mean(data.logfile.pitchDeg(data.speed_kmh>10))^2);
                eventObj.sumSquareMeanAngles = b;
                % logged time interval
                eventObj.logFileDuration_s = data.logfile.execStepTime(end)-data.logfile.execStepTime(1);
                % sampling frequency (code copied from
                % Cobi_CrashAlgo_Logfile.checkSampleTiming()
                accTimeLog = data.logfile.accTime(eventObj.logFile.startSample:end-eventObj.logFile.endSampleDelta);
                T_acc = median(diff(accTimeLog));
                eventObj.samplingFreq_Hz = 1/T_acc;
                % length of logfile content (number of samples)
                eventObj.logFileLength_s = length(data.logfile.accX)*T_acc;
                % mean velocity
                eventObj.meanSpeed_kmh = mean(data.speed_kmh);
                % version of motorbike calibration module (MCAL)
                eventObj.vMCAL = eventObj.logFile.vCal;
                % version of crash algo (CRCL)
                eventObj.vCRCL = eventObj.logFile.vCRCL;
            end
        end
    end
    
    methods (Static = true, Access = private)
        function data = retrieveDBdata(dbCon, sqlquery, verbosity, severity, msg)
            % Tries to get and return queried data from DB.
            
            tmp = select(dbCon, sqlquery);
            data = table2cell(tmp);
            if isempty(data)
                verb(verbosity, severity, msg)
            end
        end
    end
    
    methods (Static = true)
        function ts = logFileName2datetime(logFileName)
            
            % read the string of the logFile creation time stamp, including
            % time zone. Example:
            % 'IMU_logFile_mb_android_Google-Pixel-6-Pro_lib1.1.1_crcl1.1973_mcal1.2005_2022-01-02T17-07-01.390+0100_v13.csv'
            % 'IMU_logFile_iOS_mb_iPhone 11 Pro_lib1.1.1_crcl1.1973_mcal1.2005_2021-12-28T15_12_48+01_00_v13.csv'
            % Cobi iPhone (note the '_' before the miliseconds):
            % 'IMU_logFile_iOS_iPhone X_1.19.1_2022-02-05T15_58_56_913+0100_v15.csv'
            % MBCD-lib via Reference App:
            % 'IMU_logFile_iOS_mb_iPhone 7_lib1.1.2_crcl4.0003_mcal1.2005_2022-07-01T104348+0200_v13.csv'
            dateStrings = regexp(logFileName, '\d{4}-\d{2}-\d{2}T\d{2}[-_]?\d{2}[-_]?\d{2}([\._]\d{3})?\+(\d{2})','match','once');
            % remove miliseconds from strings
            dateStrings = regexprep(dateStrings, '[\._]\d{3}', '');
            % remove underscores (in time of iOS files)
            dateStrings = regexprep(dateStrings, '_', '');
            % remove dashes
            dateStrings = regexprep(dateStrings, '-', '');
            % convert the creation time strings into a datetime vector: '20220701T104348+02'
            ts = datetime(dateStrings, 'InputFormat', 'yyyyMMdd''T''HHmmssX','TimeZone','Europe/Berlin'); 
        end
        
        function success = regressionTest()
            success = true;
            %%
            dbObj = HC_crashDatabase();
            dbCon = dbObj.dbCon;
%             dbCon = database('HC crash db','',''); % old database
            
            eventObj = HC_crashEvent(dbCon,'2021-05-12T15:58:10');
            eventObj.setTypeOfService('FalseAlert');
            eventObj.setDocumentation('Nino Testeintrag fuer Datenbanktestzwecke. Kann geloescht werden.');
            eventObj.logFilePath = '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\050_DevelopmentData\calimoto\AnalyseFelddaten\20210512_FP_KommYoutube\IMU_logFile_mb_android_samsung-SM-N960F_lib1.0.0_crcl1.1949_mcal1.2_2021-05-12T17-58-05.302+0200_v13.csv';
            eventObj.setTriggerType('auto');
            eventObj.setSeverity(2);
            eventObj.setTenant('BSOCM');
            eventObj.msd_test_flag = true;
            
            v = 6;
            
            % Checking database functionality
            disp('Does the event exist in database?')
            eventObj.existsInDatabase('verbose', v)
            disp(' ')
            
            disp('Trying to delete event from the database')
            eventObj.deleteFromDatabase('verbose', v);
            disp(' ')
            disp('Trying to add test event to the database')
            eventObj.exportToDatabase('verbose', v);
            disp(' ')
            
            disp('Showing event object details')
            eventObj %#ok
            disp('Getting details from the database')
            eventObj.getDetailsFromDatabase('verbose', v)
            disp('Showing event details after getting them from database')
            eventObj %#ok
            
            disp('Getting logFile for this event')
            eventObj.logFile = Cobi_CrashAlgo_Logfile(eventObj.logFilePath,'verbose',3);
            eventObj.setLogFileMetadata();
            disp('')
            
            disp('Plotting overview for this event')
            fh = figure;
            eventObj.plotOverview();
            disp('')
            close(fh)
            
            %%
            disp('Trying to add it a second time to the database')
            eventObj.exportToDatabase('verbose', v);
            eventObj %#ok
            disp(' ')
            disp('Modifying ''documentation'', ''trigger_type'' and ''dtCrashTrigger2Event_s'' of this event')
            eventObj.setDocumentation('Test Nino modifiziert');
            eventObj.setTriggerType('manual');
            eventObj.dtCrashTrigger2Event_s = 1.111;
            eventObj.updateInDatabase({'documentation','trigger_type','dtCrashTrigger2Event_s'},'verbose', v);
            disp(' ')
            
            disp('Trying to delete event from the database...')
            eventObj.deleteFromDatabase();
            disp(' ')
            disp('Trying to delete it again...')
            eventObj.deleteFromDatabase();
            disp(' ')
            
            close(dbCon)
            
%             disp('Simulating logFile')
%             eventObj.simulateEvent()
%             disp(' ')
        end
    end
end