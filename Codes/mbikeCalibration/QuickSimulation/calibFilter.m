classdef calibFilter < handle  
% WTF-Matlab: make handle Class to update internal object-States (which isn´t default in Matlab!) instead of generating new object

      properties (Constant)            

      end
        
    properties        
         
        % Filter3D IIR Lowpass
        a;
        b;
        myFilter_x;
        myFilter_y;
        myFilter_z;
        
        myFilterValue;
        
        filterSize =0;
        
        % Ringbuffer Stuff
        Ringbuffer
    end
    
    methods
        

        

        % ****************************************************************************
        % FUNCTION: filter3D_init
        %
        % Initialize a IIR Filter for 3-Dimensions (e.g. X,Y,Z)
        % calculate Lowpass coefiicients based on Butterworth
        % function [obj] = filter3D_init(obj, accInit, n, fc, fs) % WTF-Matlab cannot handle variable n
        function [obj] = filter3D_init(obj, accInit, fc, fs) % WTF-Matlab cannot handle variable n
                    % Generate coefficients for 1st Filter: Butterworth Lowpass
                    %[obj.b, obj.a] = butter(n, fc / (fs/2), 'low'); WTF-Matlab handle variable n
                    [obj.b, obj.a] = butter(2, fc / (fs/2), 'low');

                    %Init 
                    obj.myFilter_x = zeros((max(length(obj.a),length(obj.b))-1), 1, 'single');
                    obj.myFilter_y = zeros((max(length(obj.a),length(obj.b))-1), 1, 'single');
                    obj.myFilter_z = zeros((max(length(obj.a),length(obj.b))-1), 1, 'single');

                    % Inbitialize Filter (with internal Z-State) with 1st Sample
                    [~ , obj.myFilter_x]   = filter(obj.b, obj.a, accInit(1));
                    [~ , obj.myFilter_y]   = filter(obj.b, obj.a, accInit(2));
                    [~ , obj.myFilter_z]   = filter(obj.b, obj.a, accInit(3));

                    %{
                    % Stupid Matlab filtic(...) not supported with Code-Generation -> use brute force method:
                    for i = 1:10000   
                        [accDummy(1) , myFilter_z1]   = filter(myFilter.b, myFilter.a, accInit(1),myFilter_z1);
                        [accDummy(2) , myFilter_z2]   = filter(myFilter.b, myFilter.a, accInit(2),myFilter_z2);
                        [accDummy(3) , myFilter_z3]   = filter(myFilter.b, myFilter.a, accInit(3),myFilter_z3);
                    end
                    %}
                    obj.myFilterValue = accInit;
        end 

        % ****************************************************************************
        % FUNCTION: filter3D_ReInit
        function [obj] = filter3D_ReInit(obj, accIN)
                    % Stupid Matlab filtic(...) not supported with Code-Generation -> use brute force method:
                    for i = 1:10000   
                        obj.filter3D_update(accIN);
                    end
        end

        
        
        % ****************************************************************************
        % FUNCTION: filter3D_update
        function [accOUT] = filter3D_update(obj, accIN)
            obj.myFilterValue = accIN;
            [obj.myFilterValue(1), obj.myFilter_x]   = filter(obj.b, obj.a, accIN(1),obj.myFilter_x);
            [obj.myFilterValue(2), obj.myFilter_y]   = filter(obj.b, obj.a, accIN(2),obj.myFilter_y);
            [obj.myFilterValue(3), obj.myFilter_z]   = filter(obj.b, obj.a, accIN(3),obj.myFilter_z);
            
            accOUT = obj.myFilterValue;
        end
        % ****************************************************************************
        % FUNCTION: filter3D_get
        function [accOUT] = filter3D_get(obj)          
            accOUT = obj.myFilterValue;
        end
        
        
        % ****************************************************************************
        % FUNCTION: filter3D_init
        %
        % Initialize a IIR Filter for 3-Dimensions (e.g. X,Y,Z)
        % calculate Lowpass coefiicients based on Butterworth
        function [obj] = median3D_init(obj, accIN, n)            
                    %Init 
                    obj.myFilter_x = dsp.MedianFilter(n);
                    obj.myFilter_y = dsp.MedianFilter(n);
                    obj.myFilter_z = dsp.MedianFilter(n);
                    
                    obj.filterSize =n;
                 

                    % Inbitialize Filter with 1st Sample
                    %-> use brute force method:
                    for i = 1:n   
                        obj.myFilter_x(accIN(1));
                        obj.myFilter_y(accIN(2));
                        obj.myFilter_z(accIN(3));
                    end

        end

       
        % ****************************************************************************
        % FUNCTION: filter3D_init
        %
        % Initialize a IIR Filter for 3-Dimensions (e.g. X,Y,Z)
        % calculate Lowpass coefiicients based on Butterworth
        function [obj] = median3D_ReInit(obj, accIN)
                    % Inbitialize Filter with 1st Sample
                    %-> use brute force method:
                    for i = 1:obj.filterSize 
                        obj.median3D_update(accIN);
                    end
        end
     
        
        
        % ****************************************************************************
        % FUNCTION: filter3D_update
        function [accOUT] = median3D_update(obj, accIN)
            accOUT = accIN;
            accOUT(1) = obj.myFilter_x(accIN(1));
            accOUT(2) = obj.myFilter_y(accIN(2));
            accOUT(3) = obj.myFilter_z(accIN(3));
        end
        
        
        
        % ****************************************************************************
        % FUNCTION: Ringbuffer3D_init/update
        %
        % Ringbuffer to keep a History of a signal, outputs the max delayed signal
        % e.g. - Delay-Signal to sync with further deleayed signals
        %      - To calculate Values on Hisotry
        function [obj] = Ringbuffer3D_init(obj, bufferSize, sigIN)    
            %obj.Ringbuffer = sigIN.' .* ones(3, bufferSize); %WTF: Matlab code generation
            obj.Ringbuffer = single(ones(3, bufferSize));
            %obj.Ringbuffer = obj.Ringbuffer .* sigIN'; %WTF: Matlab code generation
            %obj.Ringbuffer = [obj.Ringbuffer(1,:)*sigIN(1);
            %obj.Ringbuffer(2,:)*sigIN(2); obj.Ringbuffer(3,:)*sigIN(3)] %WTF: Matlab code generation
            for i = 1:length(obj.Ringbuffer)  
                obj.Ringbuffer(:,i) = sigIN';
            end
        end
        function [obj] = Ringbuffer3D_ReInit(obj, sigIN)    
            for i = 1:length(obj.Ringbuffer)  
                obj.Ringbuffer(:,i) = sigIN';
            end
        end        
        function [sigOUT] = Ringbuffer3D_update(obj, sigIN) %Updates Ringbuffer and Returns max Delay
            obj.Ringbuffer = [obj.Ringbuffer(1, 2:end) sigIN(1); obj.Ringbuffer(2, 2:end) sigIN(2); obj.Ringbuffer(3, 2:end) sigIN(3)];
            sigOUT = obj.Ringbuffer(:,1).';    
        end
        function [sigOUT] = Ringbuffer3D_get(obj, n) %Returns Singal with given Delay
            
            if (n < length(obj.Ringbuffer))
                index = length(obj.Ringbuffer)-n+1;
            else
                index = 1;
            end
            index = 1;
           sigOUT = obj.Ringbuffer(:,index).';
        end

        function [Ringbuffer] = Ringbuffer3D_getBuffer(obj) %Returns the Whole History
            Ringbuffer = obj.Ringbuffer;
        end

        % ****************************************************************************
        % FUNCTION: Ringbuffer1D_init/update
        %
        % Ringbuffer to keep a History of a signal
        % e.g. for sliding mean etc.
        function [obj] = Ringbuffer1D_init(obj, bufferSize, sigIN)    
            obj.Ringbuffer = single(sigIN * ones(1, bufferSize));    
        end
        function [obj] = Ringbuffer1D_ReInit(obj, sigIN)    
            for i = 1:length(obj.Ringbuffer)  
                obj.Ringbuffer(i) = sigIN;
            end
        end        
        function [sigOUT] = Ringbuffer1D_update(obj, sigIN)
            obj.Ringbuffer = [obj.Ringbuffer(2:end) sigIN];
            sigOUT = obj.Ringbuffer(1);    
        end
        function [Ringbuffer] = Ringbuffer1D_getBuffer(obj)
            Ringbuffer = obj.Ringbuffer;
        end

    end %End methods
end









% ****************************************************************************
% FUNCTION: Ringbuffer3D_init/update
%
% Ringbuffer to keep a History of a signal, outputs the max delayed signal
% e.g. - Delay-Signal to sync with further deleayed signals
%      - To calculate Values on Hisotry
function [Ringbuffer] = Ringbuffer3D_init(bufferSize)    
    Ringbuffer = zeros(3, bufferSize);    
end
function [sigOUT, Ringbuffer] = Ringbuffer3D_update(Ringbuffer, sigIN)
    Ringbuffer = [Ringbuffer(1, 2:end) sigIN(1); Ringbuffer(2, 2:end) sigIN(2); Ringbuffer(3, 2:end) sigIN(3)];
    sigOUT = Ringbuffer(:,1);    
    %sigOUT = sigIN +50;
end

% ****************************************************************************
% FUNCTION: Ringbuffer3D_init/update
%
% Ringbuffer to keep a History of a signal
% e.g. for sliding mean etc.
function [Ringbuffer] = Ringbuffer1D_init(bufferSize)    
    Ringbuffer = zeros(1, bufferSize);    
end
function [sigOUT, Ringbuffer] = Ringbuffer1D_update(Ringbuffer, sigIN)
    Ringbuffer = [Ringbuffer(2:end) sigIN];
    %disp(' ')
    %disp('Ringbuffer1D_update')
    %sigIN
    %Ringbuffer
    sigOUT = Ringbuffer(1);    
    %sigOUT = sigIN +50;
end






% ****************************************************************************
% FUNCTION: filter3D_init
% Rotates the input Signal depending on the gravity vector.
% As a Result the x,y,z will show in the always in the same direction
% (independant of mounting position or posture)
% The X-komponent from the Input will show towards the floor.
% der Winkel zwischen zwei Vektoren aus dem Skalarprodukt:
% 	_   _
% 	x * y = |x|*|y|*cos(a(x,y)) = x1*y2 + x2*y2 + x3*y3
% 
% 			_   _
% 			x * y	  	x1*y2 + x2*y2 + x3*y3
% 	cos(a)=	------	= ------------------------
% 			|x|*|y|	sqrt((x1²+x2²+x3²)*(y1²+y2²+y3²))
% 
% der Vektor um den gedreht werden soll (Senskrecht zu Vektor a & b)
% 
% 	_   _	( x2*y3 - x3*y2 )	(v1)
% 	x x y = ( x3*y1 - x1*y3 ) =	(v2)
% 			( x1*y2 - x2*y1 )	(v3)
% 
% umformen zum Einheitsvektor:
% 			 _			_
% 		_	 v			v
% 		e = ---	= ---------------
% 			|v|	  sqrt(v1²+v2²+v3²) 			
% 
% Einsetzen in die allgemeine Rotationsmatrix http://de.wikipedia.org/wiki/Drehmatrix
% 
% oder über Eulerwinkel
% 
% 	x,y,z				=Gravitation	
% 	xx,yy,zz			=Rohsignal
% 	a=sqrt(x²+y²+z²)	=Betrag für Einheitsvektor
% 
% 	xcal= (sqrt((x*x+y*y)/(x*x+y*y))*(x*xx+z*zz)+y*yy)/a;
% 	ycal= (-x*y*xx-z*y*zz+(x*x+z*z)*yy)/(a*sqrt(x*x+z*z)) ;
% 	zcal= (-z*xx+x*zz)/sqrt(x*x+z*z);
% 
% 	ggf. kann Sensor mit sich selbst Kalibriet (a!=1g) werden:  
% 
% 	xcal= (sqrt((x*x+y*y)/(x*x+y*y))*(x*xx+z*zz)+y*yy)/1;
% 	ycal= (-x*y*xx-z*y*zz+(x*x+z*z)*yy)/(1*sqrt(x*x+z*z)) ;
% 	zcal= a*(-z*xx+x*zz)/sqrt(x*x+z*z);
function accXYZRot  = rotate2gravity(gravityXYZ,             accXYZ)

	%Transformation Matrix ausrechnen mit gravity
    %Init Output to pass-through
	accXYZRot = accXYZ;

    % Absolute Value a =sqrt (x²+y²+z²)
	a	= sqrt(sum(gravityXYZ.^2));    
    
    
    if a~=0
			n1 = gravityXYZ(1)/a +1;
			n2 = gravityXYZ(2)/a;
			n3 = gravityXYZ(3)/a;

			a	= sqrt(n1*n1+n2*n2+n3*n3);
			n1 = n1/a;
			n2 = n2/a;
			n3 = n3/a;

            % Remark: Calculation done with X=1g
            % Here:   toggle X <-> Z (Z-should be gravity here)
			accXYZRot(3) = (n1*n1*2-1)	*(accXYZ(1))	+	(n1*n2*2)	*(accXYZ(2))	+ (n1*n3*2)		*(accXYZ(3));
			accXYZRot(2) = (n2*n1*2)	*(accXYZ(1))	+	(n2*n2*2-1)	*(accXYZ(2))	+ (n2*n3*2)		*(accXYZ(3));
			accXYZRot(1) = (n3*n1*2)	*(accXYZ(1))	+	(n3*n2*2)	*(accXYZ(2))	+ (n3*n3*2-1)	*(accXYZ(3));                                    
    end
end





% ****************************************************************************
% FUNCTION: YawFinder
%
% 
function [bestAngle,Error_Angle, Error_Min, Error_Max] = YawFinder(RingbufferXYZ, RingbufferVDiff, TESTANGLES_N, PlotEnabled) 

    Error_sumX=0;
    Error_sumY=0;

    Error_Max = 0;
    Error_Min = 9999999;
    
    %check Error for all Yaw-Angles
    if exist('PlotEnabled','var') %exist(PlotEnabled)
        disp('PlotEnabled');
        errorAngles = zeros(1,TESTANGLES_N);
        testX = zeros(1,3*TESTANGLES_N);
        testY = zeros(1,3*TESTANGLES_N);
    end

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
       
        if exist('PlotEnabled','var')
            testX(3*i+1) = 0;
            testX(3*i+2) = cos(w)*errorWithAngle;
            testX(3*i+3) = 0;
            testY(3*i+1) = 0;
            testY(3*i+2) = -sin(w)*errorWithAngle;
            testY(3*i+3) = 0;
            errorAngles(i+1) = errorWithAngle;
        end
    end

    %calculate angle from geographic focus-point
    Error_sumX = Error_sumX/TESTANGLES_N;
    Error_sumY = Error_sumY/TESTANGLES_N;
    bestAngle=180*atan2(Error_sumY, Error_sumX)/pi;
    
    
    %Rotate accXYZ-History with test-angle
    w=(i*360/bestAngle)/180*pi;
    w=w+pi; %smallest error opposite direction -> +180°
    accByXY = cos(w)*RingbufferXYZ(1,:) -sin(w) * RingbufferXYZ(2,:);        
    %calculate Diff between rotated AccXYZ and Speed-acceleration
    Error_Angle = abs(mean(RingbufferVDiff - accByXY));     
    
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

    
    % If Max_Error to small than almost no Accel/break in sequence
    if Error_Max < 150
%        bestAngle =0;
    end
    
    
    if Error_Angle/Error_Min >10
%        bestAngle =0;
    end
    
    %Error_Angle = Error_Angle/Error_Min;
    
end



