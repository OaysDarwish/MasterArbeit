classdef mountingOrientation < handle  
% mountingOrientation is estimated mounting Orientation of the Smartphone
% it equals the CONFIRMED Gravity-vector and Yaw-Angle of the calibration
% It will update on each STABLE identified situations with reliable information
% but it is almost constant as soon as valid calibrated
% A change of smartphone orientation must re-start mounitngOrientation
% 
% the mounting Orientation is finally used to calculate the rotation-Matrix
% 
      properties (Constant)
        SITUATION_UNKNOWN           = 0;    %any situation which cannot be assigned any known Situation
        SITUATION_NONRELEVANT       = 1;    %Most likely not attached to Motorbike (e.g. no Speed and no Engine etc.)
        %SITUATION_STATIONARY        = 2;    %Stable orientation recognized (but unknown if already mounted to mBike) -> currently not used anymore
        SITUATION_BEFORESTARTRIDE   = 3;    %Stable orientation recognized used as baseline (right before start the ride -> so Smartphone assumed to be in postion of the ride)
        SITUATION_RIDECURVE         = 10;   %Riding but currently in a curve 
        SITUATION_RIDESPEEDDOWN     = 20;   %Ride with distinct acceleration/break segments (contains reliable Yaw-Direction)        
        SITUATION_RIDECONST         = 23;   %Const Ride (driving but without cureve nor accel/break) (contains reliable Gravity)
        SITUATION_RIDESPEEDUP       = 26;   %Ride with distinct acceleration/break segments (contains reliable Yaw-Direction)
        
        STATUS_WRONGCALIBRATION     = -1; % Error during calibration e.g. Smartphone moved
        STATUS_INIT                 = 0; % Init/Start Phase no calibration Info availible 
        STATUS_PRELIMINARY_GRAVITY  = 1; % Init/Learning Phase Preliminary Gravity availble but not confirmed yet
        STATUS_PRELIMINARY_YAW      = 2; % Init/Learning Phase Preliminary Yaw +Gravity availble but not confirmed yet
        STATUS_PRELIMINARY_VERIFY   = 3; % All Info availible, smoothen over several cycles and wait to be confirmed 
        STATUS_FORCED_CONFIRMED     = 10; %Status Offset added during Forced Mode (Status_nonForced) = Status_Forced-STATUS_FORCED_CONFIRMED
        STATUS_CALIBRATION_CONFIRMED= 20;% All Info confirmed
      end %end Constant
      
      properties
        % Mounting Info -> final confirmed Mounitng Orientation 
        mountGravity            = single([0 0 1000]);        
        mountYaw                = single(0);
        mountStatus             = single(0);
        mountUpdateCnt          = single(0);

        % mounting info currently assumed (e.g. from forced mode) will be checked for validity in Pocketmode
        assumedGravity            = single([0 0 1000]);                
        assumedYaw                = single(0);
        confirmedGravity          = single([0 0 1000]);                
        confirmedYaw              = single(0);

        
        % Segments (=sequence within same situation)
        Segment_Situation = 0;
        SegmentGravitySum = single([0 0 1000]);
        SegmentYawSum     = single(0);
        Segment_n         = 0;
        SEGMENT_MAX_N     = 250; %Maximum size of a Segment to force an Update
        
        % Mountng Info´s seperated into different situations
        standingGravity         = single([0 0 1000]);
        standingYaw             = single(0);
        standing_n              = single(0);
        RideConstGravity        = single([0 0 1000]);
        RideConstYaw            = single(0);
        RideConst_n             = single(0);
        RideSpeedUpGravity      = single([0 0 1000]);
        RideSpeedUpYaw          = single(0);
        RideSpeedUp_n           = single(0);
        RideSpeedDownGravity    = single([0 0 1000]);
        RideSpeedDownYaw        = single(0);
        RideSpeedDown_n         = single(0);
        
        
        

        
      end %end properties
      
      
      
    methods
        % ****************************************************************************
        % FUNCTION: init
        %
        % Initialize mountingOrientation
        function [obj] = init(obj) 
            obj.mountGravity            = single([0 0 1000]);        
            obj.mountYaw                = single(0);
            obj.mountStatus             = single(0); %current Status of mounting Estimation
            obj.mountUpdateCnt          = single(0);
        
            obj.assumedGravity           = single([0 0 1000]);                
            obj.assumedYaw               = single(0);
            
            obj.confirmedGravity         = single([0 0 1000]);                
            obj.confirmedYaw             = single(0);
        
            obj.standingGravity         = single([0 0 1000]);
            obj.standingYaw             = single(0);
            obj.standing_n              = single(0);
            obj.RideConstGravity        = single([0 0 1000]);
            obj.RideConstYaw            = single(0);
            obj.RideConst_n             = single(0);
            obj.RideSpeedUpGravity      = single([0 0 1000]);
            obj.RideSpeedUpYaw          = single(0);
            obj.RideSpeedUp_n           = single(0);
            obj.RideSpeedDownGravity    = single([0 0 1000]);
            obj.RideSpeedDownYaw        = single(0);
            obj.RideSpeedDown_n         = single(0);

            obj.Segment_Situation       = single(0);
            obj.SegmentGravitySum       = single([0 0 1000]);
            obj.SegmentYawSum           = single(0);
            obj.Segment_n               = single(0);
        end

        % ****************************************************************************
        % FUNCTION: forceInit
        %           Same as Init but forces to be calibrated with given Vector
        %           Force-Vector will be confirmed (same as non-forced)
        %
        % Initialize mountingOrientation
        function [obj] = forceInit(obj, gravityIN, yawIN) 
            obj.init();
            obj.mountStatus = obj.mountStatus + obj.STATUS_FORCED_CONFIRMED;
            
            obj.mountGravity = gravityIN;
            obj.mountYaw     = yawIN;
            
            obj.assumedGravity  = gravityIN;                
            obj.assumedYaw      = yawIN;           
            
            obj.confirmedGravity = gravityIN;
            obj.confirmedYaw     = yawIN;              
        end
        
        % ****************************************************************************
        % FUNCTION: update
        %
        % This method is called every sample to update the
        % mountingOrientation 
        % it also requires knowledge about current identiefied driving
        % situation
        % depending on driving situation different paramters can be updated
        % e.g. 
        % - yaw during accel/break sequences of the bike
        % - gravity during const-ride (without curve) of the bike
        % - basile-gravity during stand-still (preferable short term before starting to ride)
        function [status] = update(obj, gravityIN, yawIN, situationIn)               
            %Update Values as long as same Situation (Segment = succeedingSamples within same sitation)
            if ((situationIn == obj.Segment_Situation) && (obj.Segment_n < obj.SEGMENT_MAX_N))
                obj.SegmentGravitySum    = obj.SegmentGravitySum + gravityIN;
                obj.SegmentYawSum        = obj.SegmentYawSum     + yawIN;
                obj.Segment_n            = obj.Segment_n +1;
            else         
                
            % current Segemnt closed 
                %calculate mean value of segment:
                SegmentGravity    = obj.SegmentGravitySum/obj.Segment_n;
                SegmentYaw        = obj.SegmentYawSum/obj.Segment_n;                
            
                % -> update Estimations closed Segment a
                switch obj.Segment_Situation
                    case obj.SITUATION_BEFORESTARTRIDE                           
                        k = getKbyN(obj.standing_n);
                        if (k < 0.5) k = 0.5;  end; %during Stand never slow k
                        obj.standingGravity = (1-k) * obj.standingGravity + k * SegmentGravity;
                        obj.standingYaw     = (1-k) * obj.standingYaw + k * SegmentYaw;
                        if (obj.standing_n<0xFFFF) obj.standing_n = obj.standing_n +1; end
                    case obj.SITUATION_RIDECONST                                             
                        k = getKbyN(obj.RideConst_n);
                        obj.RideConstGravity = (1-k) * obj.RideConstGravity + k * SegmentGravity;
                        obj.RideConstYaw     = (1-k) * obj.RideConstYaw + k * SegmentYaw;                    
                        if (obj.RideConst_n<0xFFFF) obj.RideConst_n = obj.RideConst_n +1; end                        
                    case obj.SITUATION_RIDESPEEDUP                                             
                        k = getKbyN(obj.RideSpeedUp_n);
                        obj.RideSpeedUpGravity = (1-k) * obj.RideSpeedUpGravity + k * SegmentGravity;
                        obj.RideSpeedUpYaw     = (1-k) * obj.RideSpeedUpYaw + k * SegmentYaw;
                        if (obj.RideSpeedUp_n<0xFFFF) obj.RideSpeedUp_n = obj.RideSpeedUp_n +1; end
                    case obj.SITUATION_RIDESPEEDDOWN                                             
                        k = getKbyN(obj.RideSpeedDown_n);
                        obj.RideSpeedDownGravity = (1-k) * obj.RideSpeedDownGravity + k * SegmentGravity;
                        obj.RideSpeedDownYaw     = (1-k) * obj.RideSpeedDownYaw + k * SegmentYaw;                                            
                        if (obj.RideSpeedDown_n<0xFFFF) obj.RideSpeedDown_n = obj.RideSpeedDown_n +1; end
                    otherwise    
                        %ignore all other cases (don´t contain confirmed Info about mounting)                        
                end %End Switch(situationIn)                

                
                %remove Offset when in forced Mode
                isForced = false;
                if ((obj.mountStatus >= obj.STATUS_FORCED_CONFIRMED) && (obj.mountStatus < obj.STATUS_CALIBRATION_CONFIRMED))                    
                    obj.mountStatus = obj.mountStatus - obj.STATUS_FORCED_CONFIRMED;
                    isForced = true;
                end
                switch(obj.mountStatus)
                    case obj.STATUS_WRONGCALIBRATION % -------- -1 ---------
                            %obj.init();    %Reset all because it cannot be assumed that any Segment is valid
                                            % Update: ReInit will be called at StartTrip -> so exisiting Segments most likely can be used
                            obj.assumedGravity            = single([0 0 1000]);                
                            obj.assumedYaw                = single(0);
                            isForced = false;
                            obj.mountStatus             = single(obj.STATUS_INIT);                            
                    case obj.STATUS_INIT % -------- 0 ---------
                        %No information availibe wait for 1st Gravity
                            obj.mountUpdateCnt          = single(0);
                            if (obj.standing_n > 2)
                                obj.mountGravity            = obj.standingGravity;        
                                obj.mountYaw                = obj.standingYaw; %Yaw very unreliable
                                obj.mountStatus             = single(obj.STATUS_PRELIMINARY_GRAVITY);                                
                                obj.mountUpdateCnt          = single(1);
                            end
                            if (obj.RideConst_n > 2)
                                obj.mountGravity            = obj.RideConstGravity;        
                                obj.mountYaw                = obj.RideConstYaw; %Yaw very unreliable
                                obj.mountStatus             = single(obj.STATUS_PRELIMINARY_GRAVITY);                                
                                obj.mountUpdateCnt          = single(1);
                            end   
                            
                    case obj.STATUS_PRELIMINARY_GRAVITY % ------- 1 ----------
                            % At least Gravity availible wait for 1st Yaw-Angle info (e.g. SpeedUp OR SpeedDown)                           
                            k = 0.5;
                            obj.mountGravity            = obj.standingGravity;
                            %  update Gravity during const ride
                            if (obj.Segment_Situation == obj.SITUATION_RIDECONST)
                                k = getKbyN(obj.RideConst_n);
                                obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideConstGravity; %obj.RideConstGravity;        
                                obj.mountGravity = obj.RideConstGravity;
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end   

                            if (obj.RideSpeedDown_n >= 1)
                                k = getKbyN(obj.RideSpeedDown_n);
                                %obj.mountGravity            = obj.RideSpeedDownGravity;       % speedDown Gravity less accurate than const ride
                                obj.mountYaw                = obj.RideSpeedDownYaw;
                                obj.mountStatus             = single(obj.STATUS_PRELIMINARY_YAW);
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end

                            if (obj.RideSpeedUp_n >= 1)
                                k = getKbyN(obj.RideSpeedUp_n);
                                %obj.mountGravity            = obj.RideSpeedUpGravity;       % speedDown Gravity less accurate than const ride
                                obj.mountYaw                = obj.RideSpeedUpYaw;
                                obj.mountStatus             = single(obj.STATUS_PRELIMINARY_YAW);
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                    case obj.STATUS_PRELIMINARY_YAW % ------- 2 ----------
                            % Preliminary info availibe wait for all Situations occured (e.g. SpeedUp AND SpeedDown)
                            k = getKbyN(obj.mountUpdateCnt);
                            %  update Gravity during situations
                            if (obj.Segment_Situation == obj.SITUATION_RIDECONST)                                
                                obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideConstGravity; %obj.RideConstGravity;        
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            if (obj.Segment_Situation == obj.SITUATION_RIDESPEEDUP)                                
                                k = getKbyN(obj.RideSpeedUp_n);
                                %obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideSpeedUpGravity;
                                obj.mountYaw                = (1-k) * obj.mountYaw + k * obj.RideSpeedUpYaw;
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            if (obj.Segment_Situation == obj.SITUATION_RIDESPEEDDOWN)                                
                                k = getKbyN(obj.RideSpeedDown_n);
                                %obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideSpeedDownGravity;
                                obj.mountYaw                = (1-k) * obj.mountYaw + k * obj.RideSpeedDownYaw;
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            %Check for next Status
                            if (obj.RideSpeedDown_n >= 1) && (obj.RideSpeedUp_n >= 1) && (obj.RideConst_n > 2)
                                obj.mountStatus             = single(obj.STATUS_PRELIMINARY_VERIFY);
                                obj.mountYaw                = ((obj.RideSpeedUpYaw+obj.RideSpeedDownYaw)/2);
                            end                        
                    case obj.STATUS_PRELIMINARY_VERIFY % ------- 3 ----------
                            %  update Gravity during situations
                            k = getKbyN(obj.mountUpdateCnt);
                            if (obj.Segment_Situation == obj.SITUATION_RIDECONST)
                                obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideConstGravity; %obj.RideConstGravity;        
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            if ((obj.Segment_Situation == obj.SITUATION_RIDESPEEDUP) || (obj.Segment_Situation == obj.SITUATION_RIDESPEEDDOWN))
                                %obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideSpeedUpGravity;
                                obj.mountYaw                = (1-k) * obj.mountYaw + k * ((obj.RideSpeedUpYaw+obj.RideSpeedDownYaw)/2);
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            
                            %Check for next Status
                            if (obj.mountUpdateCnt > 10)
                                obj.mountStatus             = single(obj.STATUS_CALIBRATION_CONFIRMED);
                                obj.assumedGravity  = obj.mountGravity;                
                                obj.assumedYaw      = obj.mountYaw;   
                            end                        
                    case obj.STATUS_CALIBRATION_CONFIRMED % -----------------
                            %  update Gravity during situations
                            k = getKbyN(obj.mountUpdateCnt);
                            if (obj.Segment_Situation == obj.SITUATION_RIDECONST)
                                obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideConstGravity; %obj.RideConstGravity;        
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                            if ((obj.Segment_Situation == obj.SITUATION_RIDESPEEDUP) || (obj.Segment_Situation == obj.SITUATION_RIDESPEEDDOWN))
                                %obj.mountGravity            = (1-k) * obj.mountGravity + k * obj.RideSpeedUpGravity;
                                obj.mountYaw                = (1-k) * obj.mountYaw + k * ((obj.RideSpeedUpYaw+obj.RideSpeedDownYaw)/2);
                                if (obj.mountUpdateCnt<0xFFFF) obj.mountUpdateCnt = obj.mountUpdateCnt+1;end
                            end
                         
                    otherwise
                        
                end %End switch(obj.mountStatus)
                
                
                % Calibration WATCHDOG
                % Verify current assumption of Calibration
                verfiyOK=true;
                
                %Checks using assumedGravity only verify when 1st assumption availible
                if ((obj.mountStatus >= obj.STATUS_CALIBRATION_CONFIRMED)  || (isForced && (obj.mountStatus >= obj.STATUS_PRELIMINARY_VERIFY)))                    
                    magnitude = sqrt(obj.mountGravity(1)^2 + obj.mountGravity(2)^2 + obj.mountGravity(3)^2 );                                        
                    if ((magnitude < 900) || (magnitude > 1100))                    
                        % WATCHDOG-Check: Gravity must be equal 1g (with tolerance)                    
                        verfiyOK=false;    
                        %disp('magnitude Error')                    
                    elseif  max(abs(obj.mountGravity-obj.assumedGravity))>100
                    % WATCHDOG-Check: Gravity_now must be in range of assumedGravity
                        verfiyOK=false;
                        %disp('assumedGravity Error')
                    elseif  abs(obj.mountYaw-obj.assumedYaw)>20
                    % WATCHDOG-Check: Yaw_now must be in range of assumedYaw
                        verfiyOK=false;
                        %disp('assumedYaw Error')
                    end
                end
                
                %Rought-Checks already feasible during Stand etc. 
                if obj.mountStatus >= obj.STATUS_PRELIMINARY_GRAVITY
                    if  ((obj.standing_n > 1) &&  (max(abs(obj.mountGravity-obj.standingGravity))>150))
                    % WATCHDOG-Check: Gravity_now must be in range of standingGravity
                        verfiyOK=false;
                        %disp('standingGravity Error')                        
                    end
                    if  ((obj.RideConst_n > 1) &&  (max(abs(obj.mountGravity-obj.RideConstGravity))>150))
                    % WATCHDOG-Check: Gravity_now must be in range of RideConstGravity
                        verfiyOK=false;
                        %disp('RideConstGravity Error')                        
                    end                    
                end
                
                
                if verfiyOK == true
                    %Add Forced Offset if still not calibrated
                    if ((isForced) && (obj.mountStatus < obj.STATUS_CALIBRATION_CONFIRMED))                 
                        obj.mountStatus = obj.mountStatus + obj.STATUS_FORCED_CONFIRMED;
                    end                
                    k=0.001; % Slowly update assumed Gravity
                    obj.assumedGravity            = (1-k) * obj.assumedGravity + k * obj.mountGravity;
                    obj.assumedYaw                = (1-k) * obj.assumedYaw + k * obj.mountYaw;
                else
                    %Verfification failed Full Restart!!!                    
                    obj.mountStatus = single(obj.STATUS_WRONGCALIBRATION);
                    obj.assumedGravity            = single([0 0 1000]);                
                    obj.assumedYaw                = single(0);
                    isForced = false;
                end


                
                if (obj.mountStatus >= obj.STATUS_CALIBRATION_CONFIRMED)
                    obj.confirmedGravity = obj.mountGravity;
                    obj.confirmedYaw     = obj.mountYaw;
                elseif (isForced)
                    obj.confirmedGravity = obj.assumedGravity;
                    obj.confirmedYaw     = obj.assumedYaw;
                end
          
    
   
                
                %Start New Segment:
                obj.Segment_Situation = situationIn;
                obj.SegmentGravitySum = gravityIN;
                obj.SegmentYawSum     = yawIN;
                obj.Segment_n         = single(1);
            end
            
            status = obj.mountStatus;

        end
        
       
    end %end methods
end


% ****************************************************************************
% FUNCTION: getKbyN
% Retruns the K-Gain dependant on number of update cycles (n)
% during Init (1st samples) K is big to generate fast response
% after certain time k gets lower to assure minor changes during runtime
function [k_now] = getKbyN(n) 
    
    k_now = 0.0001;
    %Increase filter Speed during Initialization
    if (n <= 0)
        k_now=1;
    elseif (n < 10)
        k_now = 0.1;
    elseif (n < 30)
        k_now = 0.05;
    elseif (n < 100)
        k_now = 0.02;        
    else 
        k_now = 0.01;
    end
end

