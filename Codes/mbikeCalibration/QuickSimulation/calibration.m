classdef calibration < handle  
% WTF-Matlab: make handle Class to update internal object-States (which isn´t default in Matlab!) instead of generating new object

      properties (Constant)            
            MODE_INIT           =single(1); %1st Call
            MODE_IDLE_STARTUP   =single(10); %Waiting for normal Run e.g. wait for Engine filters etc. alread running but maybe with non-usefule sensor-data (not at bike yet)
            MODE_RECHEK         =single(11); %Returned from normal Mode e.g. No Velocity or No-Engine visible anymore -> Calibration is still valid (if availible) but will be re-checked (like for fast-Init after App-Restart)
            MODE_RUN_PREPARE    =single(20); %In normal Mode but Wait for Filter etc. to be initiated with normal values
            MODE_RUN            =single(21);
            
        SPEED_DIFF_CAL = 0.303;%Calibration-Multiplier to get ~m/s²
        M_S2_TO_MG = 98.1 %Factor to translate m/s² to milli-g
            
        RIDE_MIN_V    = 3;      %Minimum Speed to Detect StartRide        
        RIDESTOPPED_N = 1000;  %Duration Standing to reCheck & reStart Calibration
            
        STATIONARY_MAX_STD = 100;
            
        FILTER1_FC = 0.5;
        FILTER_gyr1_FC = 0.5;

        ANYMOTION_WINDOW_N = 300;    %length in Cycles of Time-Frame for Std   

        MAX_SPEEDDIFF_FOR_GRAVITY=5; %Max. Speed Diff to extract Gravity
        GRAVITY_UPDATE_RATE = 0.1;  %Max. Speed Diff to extract Gravity
        
        
        VIBRATIONS_WINDOW_N = 200;    %length in Cycles of Time-Frame for Std   
        MIN_STD_ENGINE      = 40;    %Minimum STD for Engine/Vibration of Riding etc. (below can´t be riding)
        MIN_CONFIRMED_N     = 50;    % Minimum duration to set Situation Feature to true (e.g. Ride=true if above Vmin for N-Cycles) 
        MIN_SPEEDUP_VDIFF   = 100;    % Minimum change in speed to treat as Speed_up (or Speed_Down with negative value)
        MAX_GAP_N           = 50;    % Maximum Duration of Gap to reset typical status counter (e.g. Vibratins, Riding, Standing etc.) 
        MAX_GAP_NOENGINE_N  = 100;   % Maximum Duration of no motion visible -> bridge short periods but afterwards reset VibrationVisible_cnt

        MAX_GYRO_NOCURVE    = 5000; % Max Gyro signal to assume not in a Curve
        MIN_CONFIRMED_NOCURVE_N = 10;    % Minimum duration to set Situation Feature to true (e.g. Ride=true if above Vmin for N-Cycles) 

        MIN_ERROR_STABLE_YAW = 150; %If Yaw stable (iven in curve still try to use it)

        %DelayBuffer to Sync Acc (Filer 1) with other Signals e.g.STD-Window, Speed-Diff etc.
        % currently MAx-Delay is Speed-Diff
        DELAY_FILTER1  = 225; % estimated via xcorr(speed_diff, Acc_X) 
        DELAY_SPEED    = 100;
        DELAY_BASELINE = 130;
        DELAY_VIBRATIONS = 225;
        DELAY_ANYMOTION  = 150;
        
      end
        
    properties        
        FS = 100;   %current Sampling Rate        

        mode            = single(0);  %Mode is current execution e.g. after Restart App etc.
        mode_n          = single(0);
        state           = single(0);   % State is Status of calibration e.g. NONE, CalibOngoin/Prelminary Valid, CalibSuccess etc.
        calibratedFlag  = false; %set to true if Status contains confirmed calibration
        
        %speed variables
        speed_kmh;
        speed_kmh_before;
        speedFilt_kmh;
        speed_n;
        speed_diff_m_s2;
        speed_Differentiator;
        driveSituation =single(0);
        standing_cnt;
        riding_cnt;
        stationary_cnt;
     
        % Always On Filter:                
        % Filter_1  (Lowpass to remove Engine-Noise, Vibrations etc.
        calibFilter1;
        calibFilterGyr1;
        
        % Standard Deviation within TimeFrame e.g. for Engine-Noise, Vibrations etc        
        Vibrations_StdBuffer;
        Vibrations = single(0);
        noVibration_cnt     = single(0); %counter since last Mation detected
        VibrationVisible_cnt= single(0); %counter/duration of visible Motion/Vibrations
        noCurve_cnt = single(0);
        
        %Delay Buffer to sync all Signals to same time (delay to oldest signal)
        accXYZ_filter1_DelayBuffer;
        gyroXYZ_filter1_DelayBuffer;
        baseline_DelayBuffer;
        speed_kmh_DelayBuffer;
        Vibrations_DelayBuffer; 
        AnyMotion_DelayBuffer;
        
        Gravity;                %Object to estimate current Gravity (orientation over Ground)
        gravityBaseline;
        
        YawFinder;                         % Find Yaw by correlating Speed with measured Acc over past time-Frame
        YawFinder_bestAngle;
        
        mountingOrientation;    %confirmed mounting of Smartphone
        
        %Internal Calibration Values (updated depending on Situation)
        AnyMotion_StdBuffer;
        AnyMotion = single(0);
        
        %Debug-Output -> can be removed/disabled in release mode        
        Debug_accXYZ_raw     = [];
        Debug_gyrXYZ_raw     = [];
        Debug_accXYZ_filter1 = [];
        Debug_accXYZ_filter2 = [];
        Debug_accXYZ_rotated = [];        
        Debug_gyrXYZ_filter1 = [];
        Debug_gyrXYZ_rotated = [];        
        Debug_sidewise       = [];        
        Debug_Debug1         = [];        
        Debug_Debug2         = [];        
        Debug_Debug3         = [];        
        Debug_Debug4         = [];        
        Debug_Debug5         = [];        
        Debug_Debug6         = [];        
        Debug_Debug7         = [];        
        Debug_Debug8         = [];        
        Debug_Debug9         = [];        
        Debug_Debug10        = [];        
        Debug_Debug11        = [];        
        Debug_Debug12        = [];        
        Debug_Debug13        = [];        
        Debug_Debug14        = [];        
        Debug_Debug15        = [];        
        Debug_Debug16        = [];        
        Debug_Debug17        = [];        
        Debug_Debug18        = [];        
        Debug_Debug19        = [];        
        Debug_Debug20        = [];        
        
        Debug_SuperDebug     = [];        

    end
    
    methods
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % FUNCTION: calibration_setup
        %
        % Setups the Calibration (e.g. defines Filter, mallocs memory etc.)
        % Sets all internal States to Start-Value
        %
        function obj = setup(obj)              
            accXYZ = single([0 0 1000 ]);
            
            % Malloc and Setup Always ON-Filter         
            obj.Vibrations_StdBuffer = dsp.MovingStandardDeviation(obj.VIBRATIONS_WINDOW_N);            
            obj.AnyMotion_StdBuffer = dsp.MovingStandardDeviation(obj.ANYMOTION_WINDOW_N);

            % Generate 1st Filter -> Lowpass to reduce Engine-Noise, Vibrations etc.
            obj.calibFilter1 = calibFilter;
            obj.calibFilter1.filter3D_init(accXYZ, obj.FILTER1_FC, obj.FS);
            
                                
            % Generate Gyro Filter -> Lowpass to reduce Engine-Noise, Vibrations etc.
            obj.calibFilterGyr1 = calibFilter;
            obj.calibFilterGyr1.filter3D_init(single([0 0 0]), obj.FILTER_gyr1_FC, obj.FS);

            
            %Init Sync/Delay Buffer
           obj.baseline_DelayBuffer         = calibFilter;
           obj.baseline_DelayBuffer.Ringbuffer3D_init(obj.DELAY_BASELINE, accXYZ);
           
           obj.accXYZ_filter1_DelayBuffer   = calibFilter;
           obj.accXYZ_filter1_DelayBuffer.Ringbuffer3D_init(obj.DELAY_FILTER1, accXYZ);
           
           obj.gyroXYZ_filter1_DelayBuffer  = calibFilter;
           obj.gyroXYZ_filter1_DelayBuffer.Ringbuffer3D_init(obj.DELAY_FILTER1, single([0 0 0]));
           
           obj.speed_kmh_DelayBuffer        = calibFilter;
           obj.speed_kmh_DelayBuffer.Ringbuffer1D_init(obj.DELAY_SPEED, 0);           
           
           obj.Vibrations_DelayBuffer       = calibFilter;
           obj.Vibrations_DelayBuffer.Ringbuffer1D_init(obj.DELAY_VIBRATIONS, 0);
           
           obj.AnyMotion_DelayBuffer        = calibFilter;
           obj.AnyMotion_DelayBuffer.Ringbuffer1D_init(obj.DELAY_ANYMOTION, 0);

          
           % ****** Init Submodules
           % Gravity Init   
           obj.Gravity = Gravity;
           obj.Gravity.init(accXYZ, obj.FS);
           
           % YawFinder Init   
           obj.YawFinder =YawFinder;
           obj.YawFinder.init();
           
           % MountOrientation = Final Calibration-Vector
           obj.mountingOrientation = mountingOrientation;
           obj.mountingOrientation.init();
           
       
           obj.speed_Differentiator = dsp.Differentiator('DesignForMinimumOrder',false, 'FilterOrder', 3);

        end
        

        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % FUNCTION: calibration_init
        %
        % Initializes the Calibration (Setup has to be called before
        % Sets all internal States to Start-Value
        %
        function obj = init(obj, accXYZ)                        
            obj.Vibrations              = single(0);
            obj.AnyMotion               = single(0);
            obj.noVibration_cnt         = single(0);
            obj.VibrationVisible_cnt    = single(0);
                        
            obj.standing_cnt    = single(0);
            obj.stationary_cnt  = single(0);
            obj.riding_cnt      = single(0);
            obj.noCurve_cnt     =single(0);
           
           obj.speed_diff_m_s2 = single(0);
           

            %ReInit all Filter, Buffer
            obj.calibFilter1.filter3D_ReInit(accXYZ);
            obj.calibFilterGyr1.filter3D_ReInit(single([0 0 0]));

            obj.baseline_DelayBuffer.Ringbuffer3D_ReInit(accXYZ);           
            obj.accXYZ_filter1_DelayBuffer.Ringbuffer3D_ReInit(accXYZ);           
            obj.gyroXYZ_filter1_DelayBuffer.Ringbuffer3D_ReInit(single([0 0 0]));           
            obj.speed_kmh_DelayBuffer.Ringbuffer1D_ReInit(0);           
            obj.Vibrations_DelayBuffer.Ringbuffer1D_ReInit(0);           
            obj.AnyMotion_DelayBuffer.Ringbuffer1D_ReInit(0);

           
           % Prepare internal Mode
           obj.mode    = calibration.MODE_INIT;
           obj.mode_n  = single(0);
        
           obj.state    = single(0);           
           obj.calibratedFlag = false;

           obj.speed_kmh        = single(0);
           obj.speed_kmh_before = single(0);
           obj.speed_n          = single(0);            
            
        end        
        
        
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % FUNCTION: calibration_update
        %
        % Update the Calibration with New Swensor values
        function [CalibratedAccXYZ, CalibratedGyrXYZ, CalibrationStatus] = update(obj, speed_kmh, accXYZ_IN, gyrXYZ_IN)

           % ******************************************************* 
           % **************** Speed Processing *********************
           if ((obj.speed_kmh_before ~= speed_kmh) & (obj.speed_n > 70) ) | (obj.speed_n > 130) %Update ~1Hz, min 0.5s but latest after 1.5s
                obj.speed_n = single(0);                                
                %obj.speed_diff_m_s2  = obj.SPEED_DIFF_CAL * obj.speed_Differentiator((speed_kmh+obj.speed_kmh)/2);
                obj.speed_diff_m_s2  = obj.SPEED_DIFF_CAL * obj.speed_Differentiator(speed_kmh);            
                obj.speed_kmh_before = speed_kmh;
                obj.speed_kmh = speed_kmh;                
            else
                obj.speed_n = obj.speed_n+1;
           end

           % ******************************************************* 
           % ************ acc,gyroXYZ Processing *******************           
            accXYZ = accXYZ_IN;
            gyrXYZ = gyrXYZ_IN;
            obj.Debug_accXYZ_raw = accXYZ;
            obj.Debug_gyrXYZ_raw = gyrXYZ;
            
           
            % ------------------------------------------------------------           
            % ---------- basic Filter (e.g. IIR) Acc/Gyro Processing      
               %Update gravity (Zero-Offset due to gravity-Vector)
               %Remark: 
               % -> Baseline (almost) constant until next ReInit
               % -> obj.Gravity.smartFilter contains live estimation and updates faster (but causes loopbacks when used for following filters
                obj.gravityBaseline = obj.Gravity.update(accXYZ);
                accXYZ = accXYZ - obj.gravityBaseline;  % Remove Baseline (from Init)

                %Vibrations is based Raw Acc (inclduing engine-Noise)
                %Vibrations are caused by any Signal (Body-Motion, Vibrations,Engine etc.)
                obj.Vibrations = obj.Vibrations_StdBuffer( sqrt(accXYZ(1)^2 + accXYZ(2)^2 + accXYZ(3)^2 ) );
                
                % Update 1st Filter -> Lowpass to reduce Engine-Noise, Vibrations etc.
                accXYZ = obj.calibFilter1.filter3D_update(accXYZ);
                accXYZ_filter1 = accXYZ;% + obj.gravityBaseline;
                obj.Debug_accXYZ_filter1 = accXYZ_filter1 + obj.gravityBaseline;
                
                %Anymotion is based on Filtered Acc (e.g. No engine-Noise)
                %mostly influenced by Body-Motion
                obj.AnyMotion = obj.AnyMotion_StdBuffer( sqrt(accXYZ(1)^2 + accXYZ(2)^2 + accXYZ(3)^2 ) );
                                
                % Update 1st Filter -> Lowpass to reduce Engine-Noise, Vibrations etc.
                gyrXYZ = obj.calibFilterGyr1.filter3D_update(gyrXYZ);
                obj.Debug_gyrXYZ_filter1 = gyrXYZ;

                
            
            % -------------------------------------------------------------
            % ---------------- Sync all required signals ------------------
            % ----------------- to most delayed value  --------------------
            
                syncSpeedDiff       = obj.speed_diff_m_s2; %-> most delayed value sync all other to this
                syncBaseline        = obj.baseline_DelayBuffer.Ringbuffer3D_update(obj.gravityBaseline);
                syncAccXYZ_filter1  = obj.accXYZ_filter1_DelayBuffer.Ringbuffer3D_update(accXYZ_filter1);
                syncGyroXYZ_filter1 = obj.gyroXYZ_filter1_DelayBuffer.Ringbuffer3D_update(gyrXYZ);
                syncSpeed_kmh       = obj.speed_kmh_DelayBuffer.Ringbuffer1D_update(speed_kmh);                
                syncVibrations      = obj.Vibrations_DelayBuffer.Ringbuffer1D_update(obj.Vibrations);
                syncAnyMotion       = obj.AnyMotion_DelayBuffer.Ringbuffer1D_update(obj.AnyMotion);

                
                %comment this line out if non-synced (but live) value prefered
                obj.gravityBaseline         = syncBaseline;
                obj.Debug_accXYZ_filter1    = syncAccXYZ_filter1+syncBaseline;
                obj.speed_kmh               = syncSpeed_kmh;
                obj.Vibrations              = syncVibrations;
                obj.AnyMotion               = syncAnyMotion;
  

                % Update YawFinder            
                syncAccRot2grav         = rotate2gravity(syncBaseline,  syncAccXYZ_filter1); %Rotate delayed signal according current Gravity
                obj.YawFinder_bestAngle = obj.YawFinder.update(syncAccRot2grav, obj.M_S2_TO_MG*syncSpeedDiff);          %find Yaw with minError speedDiff <-> Accel in X/Y-Pane

                syncedGyrXYZRot2grav         = rotate2gravity(syncBaseline,  syncGyroXYZ_filter1); %Rotate delayed signal according current Gravity

            % -------------------------------------------------------------
            % -------------------------------------------------------------
            % ----------------- different Situations ----------------------
            
            % SITUATION: Engine
            % Vibration analysis e.g. for Engine detection
            if obj.Vibrations < obj.MIN_STD_ENGINE
                obj.noVibration_cnt = obj.noVibration_cnt +1;
                if obj.noVibration_cnt>obj.MAX_GAP_NOENGINE_N %Short Periods without vibration are tolerated
                    obj.VibrationVisible_cnt = single(0);   %No Motion detected for longer time -> reset duration of Vibration
                end
            else 
                obj.noVibration_cnt = single(0);
                obj.VibrationVisible_cnt = obj.VibrationVisible_cnt + 1;
            end
            FEATURE_EngineOn = false;
            if (obj.VibrationVisible_cnt > obj.MIN_CONFIRMED_N )
                FEATURE_EngineOn = true;
            end
            
            % SITUATION: Standing
            % update Parameter for Situations
            %Standing = (almost) No speed
            if (obj.speed_kmh < obj.RIDE_MIN_V)
                obj.standing_cnt = obj.standing_cnt+1;
                if (obj.standing_cnt > obj.MAX_GAP_N) %a Ride is stopped at longer Standing detection (short stops don´t abort the ride)
                    obj.riding_cnt = single(0);
                end
            else
                obj.standing_cnt = single(0);
                obj.riding_cnt = obj.riding_cnt +1;                
            end
            FEATURE_Riding = false;
            if (obj.riding_cnt > obj.MIN_CONFIRMED_N )
                FEATURE_Riding = true;
            end
            
            % SITUATION: Stationary (e.g. ride Const)
            % (almost) no std in Gravity
            if (obj.Gravity.std < obj.STATIONARY_MAX_STD) && (abs(obj.speed_diff_m_s2)<0.5)
                obj.stationary_cnt = obj.stationary_cnt+1;
            else
                obj.stationary_cnt = single(0);
            end
            FEATURE_Stationary = false;
            if (obj.stationary_cnt > obj.MIN_CONFIRMED_N )
                FEATURE_Stationary = true;
            end
            
            % SITUATION: Curve
            % (almost) no Gyro in X/Z-Pane (Z would be better but Yaw is still unkonwn)
            
           if sqrt(syncedGyrXYZRot2grav(1)^2 + syncedGyrXYZRot2grav(3)^2 ) < obj.MAX_GYRO_NOCURVE
                obj.noCurve_cnt = obj.noCurve_cnt+1;
            else
                obj.noCurve_cnt = single(0);
            end
            FEATURE_InCurve = true;
            if (obj.noCurve_cnt > obj.MIN_CONFIRMED_NOCURVE_N )
                FEATURE_InCurve = false;
            end
            
            
            
            % ------------------------------------------------------
            % ------------ Classify current Situation --------------
            obj.driveSituation = single(obj.mountingOrientation.SITUATION_UNKNOWN);
            
            
            if FEATURE_Riding == true
                % Riding Situations
                if (FEATURE_InCurve == false)
                    if FEATURE_Stationary == true
                        obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDECONST);
                    else
                        if obj.YawFinder.meanSpeedDiff > obj.MIN_SPEEDUP_VDIFF
                            obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDESPEEDUP);
                        end
                        if obj.YawFinder.meanSpeedDiff < -obj.MIN_SPEEDUP_VDIFF
                            obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDESPEEDDOWN);
                        end
                    end
                else                    
                    obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDECURVE);
                    
                    %Check if Yaw reiliable even in curve (e.g. break/Accel much higher than curve effect)
                    if (obj.YawFinder.bestError > obj.MIN_ERROR_STABLE_YAW)
                        if obj.YawFinder.meanSpeedDiff > obj.MIN_SPEEDUP_VDIFF
                                obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDESPEEDUP);
                        end
                        if obj.YawFinder.meanSpeedDiff < -obj.MIN_SPEEDUP_VDIFF
                            obj.driveSituation = single(obj.mountingOrientation.SITUATION_RIDESPEEDDOWN);
                        end
                    end
                end
            else
                % Standing Situations
                if ((FEATURE_EngineOn == true) && (FEATURE_Stationary == true))
                    obj.driveSituation = single(obj.mountingOrientation.SITUATION_BEFORESTARTRIDE);
                else
                    obj.driveSituation = single(obj.mountingOrientation.SITUATION_NONRELEVANT);
                end

            end
            
            
            
            
            obj.state = obj.mountingOrientation.update(obj.Gravity.smartFilter, obj.YawFinder_bestAngle, obj.driveSituation);
            
            

            
            % -------------------------------------------------------------
            % ------------ State Machine ----------------------------------
            % ---------- Calibration Mode ---------------------------------
            % -------------------------------------------------------------
            % State Machine -> update Filter according current State (e.g.INIT=Reset IIR vs. RUN=update IIR)
            mode_before= obj.mode;
           
            switch obj.mode
                %Mode Init e.g. Algo just started 1st Call after reset
                case calibration.MODE_INIT
                            if obj.mode_n > 10  %wait until everything running properly
                             obj.mode    = calibration.MODE_IDLE_STARTUP;                            
                             obj.gravityBaseline = obj.Gravity.ReInit();
                            end
                
                %MODE_STARTUP: Algo running for a few Cycles e.g. wait for Engine-Start
                case {calibration.MODE_IDLE_STARTUP, calibration.MODE_RECHEK}
                            %Switch to Run when Engine is running
                            obj.gravityBaseline = obj.Gravity.ReInit();
                            if (obj.VibrationVisible_cnt > 50 ) && (obj.speed_kmh > 5)
                                obj.mode    = calibration.MODE_RUN_PREPARE;                                
                            end
                            
                    
                otherwise  %dafault mode susually 'MODE_RUN'                                
                                if obj.mode_n > 50  %switch from prepare to normal Run (if not already there)
                                    obj.mode = obj.MODE_RUN;
                                end
                                
                                if (obj.noVibration_cnt > 200) ||(obj.standing_cnt > obj.RIDESTOPPED_N )     %Not Riding anymore -> No speed or No Engine seen for long time
                                    obj.mode    = calibration.MODE_RECHEK;
                                    % Re-Check mountOrientation at each Start for "Pocketmode"
                                    obj.mountingOrientation.forceInit(obj.mountingOrientation.mountGravity,obj.mountingOrientation.mountYaw);
                                end
                                
            end % End Switch-Case of "obj.mode"
            
            %mode Counter update
            if mode_before ~= obj.mode 
                obj.mode_n  = single(0);
            else
                obj.mode_n  = obj.mode_n+1;
            end
            
            
            
            
            
            % Rotate Input-Signals by Gravity Vector
            %gravityXYZ = filter2XYZ;
            %gravityXYZ = obj.Gravity.smartFilter;
            gravityXYZ = obj.gravityBaseline;

            if (obj.mountingOrientation.mountStatus >= obj.mountingOrientation.STATUS_FORCED_CONFIRMED)
                obj.calibratedFlag = true;
                %Rotate with confirmed Gravity and Yaw 
                CalibratedAccXYZ  = rotate2gravity(obj.mountingOrientation.confirmedGravity, accXYZ_IN);   
                w = obj.mountingOrientation.confirmedYaw;
                rotatedX = cos(w)*CalibratedAccXYZ(1) -sin(w) * CalibratedAccXYZ(2);
                rotatedY = sin(w)*CalibratedAccXYZ(1) +cos(w) * CalibratedAccXYZ(2);
                CalibratedAccXYZ  = [rotatedX rotatedY CalibratedAccXYZ(3)];
                
                CalibratedGyrXYZ  = rotate2gravity(obj.mountingOrientation.confirmedGravity, gyrXYZ_IN); 
                rotatedX = cos(w)*CalibratedGyrXYZ(1) -sin(w) * CalibratedGyrXYZ(2);
                rotatedY = sin(w)*CalibratedGyrXYZ(1) +cos(w) * CalibratedGyrXYZ(2);
                CalibratedGyrXYZ  = [rotatedX rotatedY CalibratedGyrXYZ(3)];
            else
                obj.calibratedFlag = false;
                %Rotate with preliminary mount Gravity and Yaw 
                CalibratedAccXYZ  = rotate2gravity(obj.mountingOrientation.mountGravity, accXYZ_IN);                
                w = obj.mountingOrientation.mountYaw;
                rotatedX = cos(w)*CalibratedAccXYZ(1) -sin(w) * CalibratedAccXYZ(2);
                rotatedY = sin(w)*CalibratedAccXYZ(1) +cos(w) * CalibratedAccXYZ(2);
                CalibratedAccXYZ  = [rotatedX rotatedY CalibratedAccXYZ(3)];
                
                CalibratedGyrXYZ  = rotate2gravity(obj.mountingOrientation.mountGravity, gyrXYZ_IN); 
                rotatedX = cos(w)*CalibratedGyrXYZ(1) -sin(w) * CalibratedGyrXYZ(2);
                rotatedY = sin(w)*CalibratedGyrXYZ(1) +cos(w) * CalibratedGyrXYZ(2);
                CalibratedGyrXYZ  = [rotatedX rotatedY CalibratedGyrXYZ(3)];
                
            end
            obj.Debug_accXYZ_rotated = CalibratedAccXYZ;
            obj.Debug_gyrXYZ_rotated = CalibratedGyrXYZ;                

            
            
            CalibrationStatus = obj.mountingOrientation.mountStatus;
            
           % ------------------------------------------------------------
           % ----------------- Debug Probes for Graph -------------------
           % ------------ can be removed in target code -----------------
           obj.Debug_Debug1 = obj.speed_diff_m_s2*obj.M_S2_TO_MG;% sqrt(accXYZ(1)^2+accXYZ(2)^2);
           obj.Debug_Debug2 = syncAccXYZ_filter1(2);%cos(obj.YawFinder_bestAngle/180*pi)*accXYZDelayedRot2grav(1) -sin(obj.YawFinder_bestAngle/180*pi) * accXYZDelayedRot2grav(2);
           obj.Debug_Debug3 = syncSpeed_kmh*10;%cos(105/180*pi) * accXYZDelayedRot2grav(1) -sin(105/180*pi) * accXYZDelayedRot2grav(2);% accXYZ(3);%obj.YawFinder_n;
           obj.Debug_Debug4 = obj.YawFinder.meanSpeedDiff;%obj.Gravity.smartFilter(2);% obj.YawFinder_bestAngle;           
           obj.Debug_Debug5 = 0;%obj.YawFinder_bestAngle;%accXYZDelayedRot2grav(2);% cos(105/180*pi)*obj.YawFinder_SegmentAccXYZ(1) -sin(105/180*pi) * obj.YawFinder_SegmentAccXYZ(2);
           obj.Debug_Debug6 = 0;%sqrt(syncedGyrXYZRot2grav(1)^2 + syncedGyrXYZRot2grav(3)^2 );%syncAccXYZ_filter1(2);%obj.standing_cnt;%accXYZ(2);% obj.YawFinder_SegmentSpeedDiff;           
           obj.Debug_Debug7 = obj.YawFinder.bestError;%syncBaseline(2);%obj.Gravity.std;% accXYZ_filter1(2); %obj.Debug_accXYZ_filter1(1); %obj.Vibrations;
           obj.Debug_Debug8 = obj.YawFinder_bestAngle;%obj.Vibrations;%obj.Gravity.smartFilter(1);% accXYZDelayed(2); %obj.AnyMotion;%obj.noVibration_cnt;
           obj.Debug_Debug9 = 0;%sqrt(syncAccXYZ_filter1(1)^2 + syncAccXYZ_filter1(2)^2 + syncAccXYZ_filter1(3)^2 );%accXYZ_filter1(2);%obj.Debug_accXYZ_raw(3);% obj.speed_diff; %100*(obj.AnyMotion < 20);%obj.VibrationVisible_cnt;           
           obj.Debug_Debug10= 0;%obj.AnyMotion;%obj.Debug_accXYZ_filter2(2);%obj.gravityBaseline(3);% %(obj.AnyMotion < 20) * (accXYZDelayed(2));
           obj.Debug_Debug11=0;%sqrt(gyrXYZ(1)^2 + gyrXYZ(2)^2 + gyrXYZ(3)^2 );
           obj.Debug_Debug12=0;%;
           obj.Debug_Debug13=sqrt(obj.mountingOrientation.mountGravity(1)^2 + obj.mountingOrientation.mountGravity(2)^2 + obj.mountingOrientation.mountGravity(3)^2 );
           obj.Debug_Debug14=max(abs(obj.mountingOrientation.mountGravity-obj.mountingOrientation.assumedGravity));
           obj.Debug_Debug15=0;
           obj.Debug_Debug16=obj.YawFinder_bestAngle;
           obj.Debug_Debug17=0;%(obj.driveSituation == obj.mountingOrientation.SITUATION_RIDESPEEDUP) * obj.YawFinder_bestAngle;
           obj.Debug_Debug18=0;%(obj.driveSituation == obj.mountingOrientation.SITUATION_RIDESPEEDDOWN) * obj.YawFinder_bestAngle;
           obj.Debug_Debug19=0;%obj.mountingOrientation.mountYaw;
           obj.Debug_Debug20=0;
           
            obj.Debug_SuperDebug     = obj.mountingOrientation.mountGravity;
             
        end
        
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % ****************************************************************************
        % FUNCTION: updateProbepoint (used for Debugging only)
        %
        % Update the Calibration with New Swensor values
        function accXYZ = updateProbepoint(obj, speed_kmh, accXYZ, gyrXYZ)
            disp(' ');
            disp('update Probepoint called');
            [obj.YawFinder_bestAngle, obj.YawFinder_bestError, ] = YawFinder(obj.YawFinder_HistoryBufferXYZ, obj.YawFinder_HistoryBufferVdiff, obj.YAWFINDER_TESTANGLES_N, 1);
        end        
        
    end
end

