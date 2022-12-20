function [motionClass, lastMotionClassTime, frequency, Inten] = getMotionClass(Intensity, freq, DuSpeed, lastMotionClass, lastMotionClassTime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% function to detect the activity and differentiate 
%%%%%%%% between walking and driving. When a walking detected, 
%%%%%%%% the Crash detection should be paused.
%%%%%%%% 
%%%%%%%% The function output should be a MotionClass-ID of 4 Classes
%%%%%%%% ID = -1    => Error
%%%%%%%% ID = 0     => No Movement
%%%%%%%% ID = 1     => Walking
%%%%%%%% ID = 2     => Driving
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check the biggest five frequencies. The idea is to determine the right 
% detected frequency
for iFq = 1:5
    % %% first check the intensity of the frequency to get only 
    % %% the frequency with an enough energy (intensity)
    if Intensity(iFq) > 100 
        % %% check the actual frequency. Three intervals are defined 
        % %% (walking, driving, between zones)
        if freq(iFq) >= 7
            % high frequency detected (most likely driving)
            
            % %% doppel check with the speed
            if DuSpeed < 5
                % high frequency but very low speed => No Movement
                motionClass = 0;
            else
                % there is movement => Driving
                motionClass = 2;
            end
            break
            
        elseif freq(iFq) >= 0.390625000 && freq(iFq) <= 2
            % Low frequency, (most likely walking)
            
            % %% doppel check with the speed
            if DuSpeed <=7 && DuSpeed > 0
                % walking speed => Walking
                motionClass = 1; 
                break
            elseif DuSpeed == 0
                % no speed => no Movement
                motionClass = 0; 
                break
            else
                % speed > 7 kmh => not walking => conflict 
                % => check next frequency
                motionClass = -1;
                continue;
            end
        elseif freq(iFq) > 2 && freq(iFq) <7
            % Between zone. Maybe walking and maybe driving. 
            
            % %% Double check with the speed. 
            % %% If the speed is bigger than 7 km/h than he must  
            % %% be driving. If the speed is smaller than 7 km/h 
            % %% it should stay undeclared.the person might be 
            % %% driving with no GPS-Signal (e.g. no speed)
            if DuSpeed >= 7
                % Driving speed => Driving
                motionClass = 2;
                break;
            else
                % Not driving speed => Conflict => check next frequency
                motionClass = -1;
                continue;
            end
        else
            % not intended to get here; all usecases were 
            % defined previously
            motionClass = lastMotionClass; % keep last detected class
            break
        end
    else
        % The intensity is smaller than 100 => the frequency could't
        % be used  => determine motionClass only using the speed
        if DuSpeed >= 7
            % Driving speed => Driving
            motionClass = 2;
            break;
        elseif DuSpeed < 7 && DuSpeed > 0.1
            % Walking speed => Walking
            motionClass = 1;
            break;
        else
            % Speed = 0 => No movement 
            motionClass = 0;
        end
    end
end
% save the frequency used to determine motionClass
frequency = freq(iFq);  
% save the intensity used to determine motionClass
Inten = Intensity(iFq); 
end

