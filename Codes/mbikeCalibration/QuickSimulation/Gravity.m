classdef Gravity < handle  
% Baseline is the const-Offset within XYZ-Axis
% it is caused by Gravity (and Sensor Offset-Failures)
% it should be constant as long as orientation isn´t changed
% due to noise init-failures etc. very slow adjustment during runtime are possible
% larger Changes (e.g. Smartphone Orientation-toggle) should cause re-Calibration
      properties (Constant)
          MEDIAN_N  = 11;
          ADJUST_K = 0.0001; %K-Factor of Adjusting current Offset should be very small e.g. 90° Rotation Re-Calibration should last >1min

          FILTER1_FC = 2.5;          
          
          STD_WINDOW_N = 40; %length in Cycles of Time-Frame for Std   

          STD_MAX  = 70; %Max. Std for Update -> std above will not cause slowst Update Rate
          STD_MIN  = 30;  %Values below Min. Std will have fastest update Rate
          GRAVITY_K_SLOW = 0.00001;
          GRAVITY_K_FAST = 0.001;          
          GRAVITY_K_CHANGERATE = 0.1;  %To aoid jumps in K this is also filtered 

          DELAY_N  = 400; % Interesting Gravity before init                      
      end %end Constant
      
      properties
          FS; %current Sampling Rate -> must be set during Init
          
          constOffset   = single([0 0 0]);  %const Value until next Init (only used for fast Init to start IIR with Zero-Offset)
          adjustOffset  = single([0 0 0]); %adjustment during Update (should be very small and slow!!)
          smartFilter   = single([0 0 0]); %current assumed Gravity-Vector with smart Filter adaptive to situation (no Motion-> fast Update; Motion-> slow Update)
        
          % pure Raw-Data is crap (1st remove Engine-Noise, Vibrations etc.)
          % Remove spikes etc. (Impulse -Peaks not of interest for Gravity)
          medFiltXYZ;
        
          % Always On Filter  Fast Lowpass (should follow anymotion -> fast)        
          alwasOnFilter;
        
          % Standard Deviation within TimeFrame e.g. to update Gravity if not in Motion
          StdBuffer;          
          stdXYZ;
          std; %current Max STD in XYZ
          MeanBuffer;
          mean;
          lastStableMean;
          
          
          % Smart-Gravity K-Filter (slow/no Update during motion, fast update if static
          gravity_k; %current k-Update Factor

          %DelayBuffer to know about previosu State (e.g. time before Starting to drive)
            stableXYZ_DelayBuffer;
            stableXYZ_delayed;
            
      end %end properties
      
      methods
          
        % ****************************************************************************
        % FUNCTION: init
        %
        % Initialize Baseline and all its Buffers
        function [obj] = init(obj, accIN, FS_IN) 
            obj.FS                  = FS_IN;
            obj.constOffset         = accIN;
            obj.adjustOffset        = single([0 0 0]); 
            obj.mean                = accIN;
            obj.lastStableMean      = obj.mean;
            obj.stableXYZ_delayed   = accIN;

            
            % Always ON-Median
            obj.medFiltXYZ = calibFilter;
            obj.medFiltXYZ.median3D_init(accIN, obj.MEDIAN_N);            
            
            % Generate Filter
            obj.alwasOnFilter = calibFilter;
            obj.alwasOnFilter.filter3D_init(accIN, obj.FILTER1_FC, obj.FS);           
            %-> use brute force Init method:
            for i = 1:20
                obj.medFiltXYZ.median3D_update(accIN);
                obj.alwasOnFilter.filter3D_update(accIN);
            end    
            
            %Init Sliding window for STD, Mean
            obj.StdBuffer = dsp.MovingStandardDeviation(obj.STD_WINDOW_N);
            obj.MeanBuffer= dsp.MovingAverage(obj.STD_WINDOW_N);
            
            obj.stableXYZ_DelayBuffer = calibFilter;
            obj.stableXYZ_DelayBuffer.Ringbuffer3D_init(obj.DELAY_N, accIN);
            
            %Set Start-Baseline
            ReInit(obj);       
        end
           
        % ****************************************************************************
        % FUNCTION: Re-init
        % Set New Baseline, based on previous Singal History
        % Init without Malloc / filter definition etc.
        % 
        function baseline = ReInit(obj) 
            
            obj.constOffset= obj.stableXYZ_delayed;%obj.mean;%obj.alwasOnFilter.filter3D_get();
            
            
            obj.adjustOffset= single([0 0 0]);
            
            obj.gravity_k = obj.GRAVITY_K_SLOW;
            baseline = obj.constOffset + obj.adjustOffset;
            
            obj.smartFilter = baseline;
        end
        
        
        % ****************************************************************************
        % FUNCTION: update
        %
        % Update all internal values etc.       
        function baseline = update(obj, accIN) 
            
            accXYZ = accIN;
            % always on Quick-Median Remove Spikes
            accXYZ = obj.medFiltXYZ.median3D_update(accXYZ);            
            % always on Filter -> only Motion (no fast Singals e.g. remove Vibration)
            accXYZ = obj.alwasOnFilter.filter3D_update(accXYZ);            
            
            %Update Adjust Offset
            obj.adjustOffset = (1-obj.ADJUST_K)* obj.adjustOffset + obj.ADJUST_K * (accXYZ - obj.constOffset);
              
            baseline = obj.constOffset + obj.adjustOffset;
            
            %accXYZ = accXYZ - baseline;            
            
            %Update Windows            
%            obj.std = obj.StdBuffer( sqrt(accXYZ(1)^2 + accXYZ(2)^2 + accXYZ(3)^2 ) );
            obj.stdXYZ = obj.StdBuffer( accXYZ);
            obj.std = max(obj.stdXYZ);
            
            
            
            obj.mean = obj.MeanBuffer(accXYZ);
            
            if (obj.std<obj.STD_MIN)
                obj.lastStableMean = obj.mean;
            end
            
            obj.stableXYZ_delayed  = obj.stableXYZ_DelayBuffer.Ringbuffer3D_update(obj.lastStableMean);
            
            % Smart Filtering depending on current noise/motion
            %   Low-Noise/Motion	-> fast signal following
            %   High-Noise/Motion	-> high filtering (=slow following)

            % Adapt k Lowpass in dependancy of Standard daviation (low noise = const. Riding = faster filter)      
            k_wish = obj.GRAVITY_K_SLOW;
            std=obj.std;
            if (std<obj.STD_MIN)  
                %Std below Min ->fastest Update
                k_wish = obj.GRAVITY_K_FAST;
            elseif (std<obj.STD_MAX) 
                %Std in between -> interpolate for current k
                k_wish = double( (((obj.GRAVITY_K_SLOW-obj.GRAVITY_K_FAST)/(obj.STD_MAX-obj.STD_MIN))*(std-obj.STD_MIN)+obj.GRAVITY_K_FAST));
            else
                %Std above Max Std -> slowest Update
                k_wish = obj.GRAVITY_K_SLOW;
            end            
                        
            % Smoothen k filter to avoid fast k-changes in small low-noise sequences
            % if k is smaller/slower (due to noise in signal) always reduce k fast
            if (k_wish > obj.gravity_k)
                obj.gravity_k = obj.GRAVITY_K_CHANGERATE* k_wish + (1-obj.GRAVITY_K_CHANGERATE) * obj.gravity_k;
            else
                obj.gravity_k = k_wish;
            end            
            
            %Update Smart-lowpass of Gravity-Filter
            obj.smartFilter = (1-obj.gravity_k)* obj.smartFilter + obj.gravity_k * (obj.mean);
            
        end
        
      end %end methods
end





