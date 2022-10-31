classdef Parameter < Simulink.Parameter
    
    methods
		function obj = Parameter(optionalValue)
			if (nargin == 1)
				obj.Value = optionalValue;
			end
        end
        
        function setupCoderInfo(obj)
			useLocalCustomStorageClasses(obj, 'Ebikepkg_ACAL');
			
			obj.CoderInfo.StorageClass = 'Custom';
%             obj.CoderInfo.CustomStorageClass = 'EbikePack';
		end
	end % methods
    
end %classdef