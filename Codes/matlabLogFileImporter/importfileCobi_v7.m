function logfile = importfileCobi_v7(filename, dataLines)
%IMPORTFILE Import data from a text file
%  IMULOGFILE20190605T163855 = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as a table.
%
%  IMULOGFILE20190605T163855 = IMPORTFILE(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  IMUlogFile20190605T163855 = importfile("L:\EBI\02_ENG\01_ENG1\10_UserOffice\Schnee\04_Algos\05_CrashAlgo\Simulink\CrashAlgoSchnee\CobiData\CobiAppIOS\IMU-logFile-2019-06-05T16_38_55.948+0200_timingYoutube_v7.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 05-Jun-2019 16:40:31

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Time", "counter", "accTime", "AccX", "Y", "Z", "pressure", "speed", "gyroCounter", "gyroTime", "Gyrx", "y", "z", "isHubConnected", "VarName15"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
opts = setvaropts(opts, 15, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 15, "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
logfile = readtable(filename, opts);

end