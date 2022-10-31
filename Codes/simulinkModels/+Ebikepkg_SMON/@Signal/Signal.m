classdef Signal < Simulink.Signal
    
    methods
		function obj = Signal()
        end
        
        function setupCoderInfo(obj)
			useLocalCustomStorageClasses(obj, 'Ebikepkg_SMON');
			
			obj.CoderInfo.StorageClass = 'Custom';
%             obj.CoderInfo.CustomStorageClass = 'EbikePack';
		end
	end % methods
    
end %classdef