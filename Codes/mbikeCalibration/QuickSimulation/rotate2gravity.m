% ****************************************************************************
% FUNCTION: rotate2gravity
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
function accXYZRot  = rotate2gravity(gravityXYZ, accXYZ)

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


