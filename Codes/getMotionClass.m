function [motionClass, lastMotionClassTime, frequency, Inten] = getMotionClass(Intensity, freq, DuSpeed, lastMotionClass, lastMotionClassTime)
% status = -1;
for iFq = 1:5
    if Intensity(iFq) > 100
        lastMotionClassTime = 0;
        %         lastClassTime = 0;
        if freq(iFq) >= 7
            % high frequency (most likely driving), check with speed
            if DuSpeed < 5
                % high frequency but very low speed => sitting on motorbike and standing still
                motionClass = 0;
            else
                % there is movement
                motionClass = 2;
            end
            break
        elseif freq(iFq) >= 0.390625000 && freq(iFq) <= 2
            % walking, (most likely walking) check with speed
            if DuSpeed <=7 && DuSpeed > 0
                % walking speed
                motionClass = 1;
                break
            elseif DuSpeed == 0
                % no speed, propably standing
                motionClass = 0;
                break
            else
                % speed > 7 kmh => not walking => conflict => check next frequency
                motionClass = -1;
                continue;
            end
        elseif freq(iFq) > 2 && freq(iFq) <7
            % undeclared. Maybe walking and maybe driving. Double check with the spped. If the speed is bigger than 7 km/h than he must be driving.
            % If the speed's smaller than 7 km/h it should stay undeclared, he might be driving with no GPS-Signal (e.g. no speed) or walking
            if DuSpeed >= 7
                motionClass = 2;
                break;
            else
                motionClass = -1;
                continue;
            end
            
        elseif freq(iFq) < 0.3906 % undeclared f < 0.3906 Hz
            % not intended to get here
            % (sensor couldn't sense frequencies smaller than 0.396)
            motionClass = -2;
            break
        else
            % not intended to get here either; all usecases were defined in the
            % previous elseifs
            motionClass = lastMotionClass;
            break
        end
    else
        if DuSpeed >= 7
            motionClass = 2;
            break;
        elseif DuSpeed < 7 && DuSpeed > 0.1  
            motionClass = 1;
            break;
%             if lastMotionClassTime <=100
%                 lastMotionClassTime = lastMotionClassTime + 1;
%                 motionClass = lastMotionClass;
%             else
%                 lastMotionClassTime = 0;
%                 motionClass = 1;
%             end
%             continue
            break;
        else
            motionClass = 0;
        end
        lastMotionClassTime = 0;
    end
end
frequency = freq(iFq);
Inten = Intensity(iFq);
end

% statusAll = [statusAll status];
