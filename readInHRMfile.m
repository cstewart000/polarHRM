
function [dataDate, dataTime, heartRateBpm,elapsedtime] = readInHRMfile(path)

	% Exmple [dataDate, dataTime, heartRateBpm,elapsedtime] = readInHRMfile("./sample/watch 12-cow1184-21march.hrm")
	file = fopen(path);

	fileData = fileread(path);

	% Get the date
	dataDatendex = strfind(fileData, 'Date');
	dataDate = substr(fileData, dataDatendex+5, 8);

	% Get the time
	dataTimeIndex = strfind(fileData, 'StartTime');
	dataTime = substr(fileData, dataTimeIndex+10, 10);


	% Split the file around the "[HRData]" marker

	dataHRMIndex = strfind(fileData, '[HRData]');

	dataHRM = substr(fileData, dataHRMIndex+8);

	dataHRMdelimeted = strsplit(dataHRM, '\n');

	% chop off the first value whis is a \n char	
	dataHRMdelimeted = dataHRMdelimeted(2:end);

	% this is the time in ms between heartbeats
	dataHRMdelimetedInt = str2double(dataHRMdelimeted)';
	%dataHRMdelimetedInt = (dataHRMdelimeted);

	% this is the hear rate in bps
	heartRateBps = ((dataHRMdelimetedInt)/1000).^-1;

	
	heartRateBpm =  heartRateBps.*60;


	% make a vector of the time by adding the time between readings
	elapsedtime(1)=0;

	for(i=2: length(dataHRMdelimetedInt));

		elapsedtime(i) = dataHRMdelimetedInt(i-1)+elapsedtime(i-1);
	end

	elapsedtime = elapsedtime';


	return
end