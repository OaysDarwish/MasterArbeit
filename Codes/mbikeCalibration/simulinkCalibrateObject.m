classdef simulinkCalibrateObject < matlab.System
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
    end

    properties(DiscreteState)
    end
    
      properties (Constant)     
      end    

    % Pre-computed constants
    properties(Access = private)
        calib;
        firstSample = false;
    end

    methods(Access = protected)
        function setupImpl(obj)
            obj.calib = calibration;
            obj.calib.setup();
            obj.calib.init(single([0 0 1000]));
           
            obj.firstSample = false;
        end

        function [accBfXYZmg_OUT, gyrBfXYZmdegs_OUT, calibStatus_OUT] = stepImpl(obj, speed_kmh_IN, accSfXYZmg_IN, gyrSfXYZmdegs_IN)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            
            %Cheick if 1st call with Sensor values to ReInit
            if (obj.firstSample == false )
                obj.calib.init(accSfXYZmg_IN'); %Init with SensorValues
                obj.firstSample = true;
            end
            
            
            %update Calibration with new value
            [calibratedAccXYZ_Sf, calibratedGyrXYZ_Sf, calibrationStatus] = obj.calib.update(speed_kmh_IN, accSfXYZmg_IN', gyrSfXYZmdegs_IN');
            
            accBfXYZmg_OUT      = calibratedAccXYZ_Sf';
            gyrBfXYZmdegs_OUT   = calibratedGyrXYZ_Sf';
            calibStatus_OUT     = calibrationStatus;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties                       
           obj.firstSample = false; %if false init will be called first SensorValues
        end
    end
end
