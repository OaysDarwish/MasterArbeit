function bhcsVerbose(verbosityLevel,severity,text)
%%
%     (C) All rights reserved by ROBERT BOSCH HEALTHCARE SOLUTIONS GMBH
%% ------------------------------------------------------------------------
% ----------------------- bhcsVerbose.m -----------------------------------
% -------------------------------------------------------------------------
% @HEADER:
%
% 	@autor:				Nico Schmid BHCS/ENG1
% 	@email:             nico.schmid2@de.bosch.com
% 	@created:           Sept 2017
% 	@version:			0.1
% 	@update:				
% 	@remark:
%   
% 
% -------------------------------------------------------------------------
% @DESCRIPTION: function to implement the notification concept defined in
% JIRA Issue FSE-61. It's basicly a unified framework on how the running 
% code should react on certain events or inform the user depending on the 
% ammount of info (verbose level) he or she wants. The function decides on 
% the given severity and verbose level how to respond. The notification is 
% implemented arrording to the table below. 5 ist the default verbosity
% level.
%
% 4 Possible responses are implemented:
% error, warning, info, none
%  verbose |shut up| <---less-------------more---> |default|  ext  | debug
%    level |   0   |   1   |   2   |   3   |   4   |   5   |   6   |   7
% severity |_______|_______|_______|_______|_______|_______|_______|_______
%    0     |   e       e       e       e       e       e       e       e
%    1     |   -       w       w       e       e       e       e       e
%    2     |   -       i       i       w       e       e       e       e
%    3     |   -       -       -       i       w       e       e       e
%    4     |   -       -       -       -       i       w       e       e
%    5     |   -       -       -       -       -       i       w       w
%    6     |   -       -       -       -       -       -       i       i
%    7     |   -       -       -       -       -       -       -       i
% e = error, w = warning, i = info, - = none
% -------------------------------------------------------------------------
% ToDo: 
%
%% ------------------------------------------------------------------------
% @INPUT: 
% @Required
%   - verbosityLevel: defines wich level of the current reaction should be.
%                     implemented values go from zero to seven. 
%   - severity:       defines the severity of the event ans is usually
%                     fixed
%   - text:           the text that is used either in the error, warning or 
%                     info message. Use sprintf without a trailing
%                     linebreak.
%% ------------------------------------------------------------------------

% determine the kind of the response
    determinedAction = 'error';
    switch severity
        case 0
            determinedAction = 'error';
        case 1
            if verbosityLevel < 1
                determinedAction = 'none';
            elseif  1 <= verbosityLevel && verbosityLevel < 3
                determinedAction = 'warning';
            elseif 3 <= verbosityLevel
                determinedAction = 'error';
            end
        case 2
            if verbosityLevel < 1
                determinedAction = 'none';
            elseif  1 <= verbosityLevel && verbosityLevel < 3
                determinedAction = 'info';
            elseif  3 <= verbosityLevel && verbosityLevel < 4
                determinedAction = 'warning';                
            elseif 4 <= verbosityLevel
                determinedAction = 'error';
            end
        case 3
            if verbosityLevel < 3
                determinedAction = 'none';
            elseif  3 <= verbosityLevel && verbosityLevel < 4
                determinedAction = 'info';
            elseif  4 <= verbosityLevel && verbosityLevel < 5
                determinedAction = 'warning';                
            elseif 5 <= verbosityLevel
                determinedAction = 'error';
            end
        case 4
            if verbosityLevel < 4
                determinedAction = 'none';
            elseif  4 <= verbosityLevel && verbosityLevel < 5
                determinedAction = 'info';
            elseif  5 <= verbosityLevel && verbosityLevel < 6
                determinedAction = 'warning';                
            elseif 6 <= verbosityLevel
                determinedAction = 'error';
            end
        case 5
            if verbosityLevel < 5
                determinedAction = 'none';
            elseif  5 <= verbosityLevel && verbosityLevel < 6
                determinedAction = 'info';              
            elseif 6 <= verbosityLevel
                determinedAction = 'warning';
            end
        case 6
            if verbosityLevel < 6
                determinedAction = 'none';               
            elseif 6 <= verbosityLevel
                determinedAction = 'info';
            end
        case 7
            if verbosityLevel < 7
                determinedAction = 'none';               
            elseif 7 <= verbosityLevel
                determinedAction = 'info';
            end
        otherwise
        	error('unsupported severity Level')   
    end
    % output according to the determined reaction        
    switch determinedAction
        case 'error'
            error(text)
        case 'warning'
            warning(text)
        case 'info'
            fprintf('%s\n',text)
    end
end