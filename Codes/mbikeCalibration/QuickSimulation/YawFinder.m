classdef YawFinder < handle  
% WTF-Matlab: make handle Class to update internal object-States (which isn´t default in Matlab!) instead of generating new object
%
%   The Yaw-Finder compares the Motorbike-Acceleration (by Speed-Diff) with
%   sensed accel_XYZ in the last History (e.g. previous 2s)
%   It tests serveral rotations of the X/Y-accel to best match current speed
%   to find the Yaw-Angle
% 
%   Because GPS updates less frequent (e.g. 1Hz) than the IMU (100Hz) #
%   the Finding-Yaw is not be performed every cycle (e.g. 2Hz)
%   The Sensed Data will be averaged until next update
%   This is called Segment
      properties (Constant)            
        UPDATECYCLE      = 50;   % No. of Cycles to update current Yaw-Finder -> 1=every Cycle ...100 =~1s ~=GPS-update 50 = 2x per GPS Update, 100Hz Accel will be averaged over this Sequence
        ANALYZEHISTORY_N = 400;  % Buffer Size of History; should be Multiple of UPDATECYCLES (e.g. duration of a break/accel phase) -> longer: higher precision (e.g. curves have less influence) smaller:more noise (but faster)
        TESTANGLES_N     = 50;   % Angle-Resolution, Number of Angles to be calculated iteratively higher values increase resolution (final angle has higher resolution due to averaging) but also processing effort e.g. 360 -> test every 1°
      end
        
    properties        
        HistoryBufferXYZ;
        HistoryBufferVdiff;
        
        bestAngle = single(0);
        bestError = single(0);
        meanSpeedDiff; %Mean acceleration over analyzed segment
        
        Segment_SUMXYZ      = single([0 0 0]);
        Segment_n           = 0;
        SegmentAccXYZ       = [0 0 0];
        SegmentSpeedDiff    = single(0);
        
    end
    
    methods
        % ****************************************************************************
        % FUNCTION: filter3D_init
        %
        % Initialize a YawFinder and all its Buffers
        function [obj] = init(obj)            
           % Init the Segment (Accel is averaged over Seg 
           % until next Find-Yaw-trigger (e.g. GPS-Update)
           obj.Segment_SUMXYZ = single([0 0 0]);
           obj.Segment_n=0;
           obj.SegmentAccXYZ = single([0 0 0]);

            obj.bestAngle = single(0);
            obj.bestError = single(0);
        
           obj.HistoryBufferXYZ   = calibFilter;
           obj.HistoryBufferXYZ.Ringbuffer3D_init(obj.ANALYZEHISTORY_N / obj.UPDATECYCLE, [0 0 0] );
           
           obj.meanSpeedDiff = single(0);
           
           obj.HistoryBufferVdiff = calibFilter;
           obj.HistoryBufferVdiff.Ringbuffer1D_init(obj.ANALYZEHISTORY_N / obj.UPDATECYCLE,  0);            
        end
        
        
        
        % ****************************************************************************
        % FUNCTION: update
        %   YawFinder -> Correlate Speed_Diff with
        %   Rotated (several Test-Angles) AccelXY
        %   minimum deviation of Speed_Diff and AccelX is assumed to be best matching Yaw
        %   -> will be updated on speed-Update (typically 1Hz)
        function bestAngle = update(obj, accIN, speedDiffIN)   
           
            %Average over current Segment
            obj.Segment_n         = obj.Segment_n+1;                                  
            obj.Segment_SUMXYZ    = obj.Segment_SUMXYZ +   accIN; %Sum up elements for averaging later
            obj.SegmentAccXYZ     = obj.Segment_SUMXYZ / obj.Segment_n; %Calc Mean
            
            %Speed-Diff should stay constant in segment -> no average, only use latest
            obj.SegmentSpeedDiff  = speedDiffIN;
            
            
            % Check for new update / Segment finished
            %Update of YawFinder and Try to figure most-likely yaw-angle 
            if (obj.Segment_n > obj.UPDATECYCLE)                   
 
                % Update Ringbuffer of current History                             
                obj.HistoryBufferXYZ.Ringbuffer3D_update(obj.SegmentAccXYZ);
                obj.HistoryBufferVdiff.Ringbuffer1D_update(obj.SegmentSpeedDiff);

                [obj.bestAngle, obj.bestError, Error_Min, Error_Max] = YawFinder_TestAngles(obj.HistoryBufferXYZ.Ringbuffer3D_getBuffer(), obj.HistoryBufferVdiff.Ringbuffer3D_getBuffer(), obj.TESTANGLES_N);

                
                obj.meanSpeedDiff = mean(obj.HistoryBufferVdiff.Ringbuffer3D_getBuffer());
                
                %Start new segment
                obj.Segment_n = 0;
                obj.Segment_SUMXYZ = single([0 0 0]);
            end
            
            bestAngle  = obj.bestAngle;
        end
        
    end %end methods
end %end classdef









% ****************************************************************************
% FUNCTION: YawFinder
%
% 
function [bestAngle,Error_Angle, Error_Min, Error_Max] = YawFinder_TestAngles(RingbufferXYZ, RingbufferVDiff, TESTANGLES_N, PlotEnabled) 

    Error_sumX  = single(0);
    Error_sumY  = single(0);

    Error_Max   = single(0);
    Error_Min   = single(9999999);
    
    
    %check Error for all Yaw-Angles
%{    
    if exist('PlotEnabled','var') %exist(PlotEnabled)
        disp('PlotEnabled');
        errorAngles = zeros(1,TESTANGLES_N);
        testX = zeros(1,3*TESTANGLES_N);
        testY = zeros(1,3*TESTANGLES_N);
    end
%}

    for i = 0:TESTANGLES_N
        %Rotate Signal by current check Yaw-Angle
        w=(i*360/TESTANGLES_N)/180*pi;
        
        %Rotate accXYZ-History with test-angle
        accByXY = cos(w)*RingbufferXYZ(1,:) -sin(w) * RingbufferXYZ(2,:);        
        %calculate Diff between rotated AccXYZ and Speed-acceleration
        errorWithAngle = abs(mean(RingbufferVDiff - accByXY));        

        Error_sumX=Error_sumX +cos(w)* errorWithAngle;
        Error_sumY=Error_sumY -sin(w)* errorWithAngle;
        
        Error_Max = max(Error_Max,errorWithAngle);
        Error_Min = min(Error_Min,errorWithAngle);
       
%{
        if exist('PlotEnabled','var')
            testX(3*i+1) = 0;
            testX(3*i+2) = cos(w)*errorWithAngle;
            testX(3*i+3) = 0;
            testY(3*i+1) = 0;
            testY(3*i+2) = -sin(w)*errorWithAngle;
            testY(3*i+3) = 0;
            errorAngles(i+1) = errorWithAngle;
        end
%}        
        
    end


    %calculate angle from geographic focus-point
    Error_sumX = Error_sumX/TESTANGLES_N;
    Error_sumY = Error_sumY/TESTANGLES_N;
    bestAngle=180*atan2(Error_sumY, Error_sumX)/pi;
    
    
    %Rotate accXYZ-History with test-angle

%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
%TODO: check og best angle hier stimmt was ist mit i????
    %w=(i*360/bestAngle)/180*pi;
    
    w=(360/bestAngle)/180*pi;    
    w=w+pi; %smallest error opposite direction -> +180°
    accByXY = cos(w)*RingbufferXYZ(1,:) -sin(w) * RingbufferXYZ(2,:);        
    %calculate Diff between rotated AccXYZ and Speed-acceleration
    Error_Angle = abs(mean(RingbufferVDiff - accByXY));     
%{    
    if exist('PlotEnabled','var')
        
        bestAngle
        Error_Max
        Error_Min
        Error_Angle
        
        testX(1) = -Error_sumX*5;
        testX(2) = 0;
        testY(1) = -Error_sumY*5;
        testY(2) = 0;    
        figure(2);
        plot(testX,testY);
        axis([-500 500 -500 500])
        figure(3);
        plot(errorAngles);
    end
%}
    
    % If Max_Error to small than almost no Accel/break in sequence
    if Error_Max < 150
%        bestAngle =0;
    end
    
    
    if Error_Angle/Error_Min >10
%        bestAngle =0;
    end
    
    %Error_Angle = Error_Angle/Error_Min;
    
end



