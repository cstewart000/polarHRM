%%  readInHRMfile function
%{
  Matlab function to parse a Polar brand heart rate monitor .hrm files into matlab.  

  Created by: Cameron Stewart
  23/03/2017
  cstewart000@gmail.com
  
  https://hackingismakingisengineering.wordpress.com/
  https://github.com/cstewart000/polarHRM

  @Input Arguments:
  path = the absolute path of the ".hrm" file to read in. Ues a period ('.') before the path to make the path relative to the working directory

  @Output Values
  dataDate - the start date of the data set as a string in: 'yyyyMMdd' format
  time - the start time of the data set as a string in: 'HH:mm:ss.s' format
  heartRateBpm - a vector of the heart rate in BPM at each reading interval
  elapsedtimeSS - a vector of the elapsed time in seconds between each HR value.

  Note:
  The heart rate monitor records the time between beats in ms. The frequency of the reading is therefore iregular.
  The rate is measured as the inverse of the time between each reading:

  HR_{bps} = 1/(T_{reading.ms}/1000)

  Example call: [dataDate, dataTime, heartRateBpm,elapsedtime] = readInHRMfile(".<your_file>.hrm")

}
% 

function [dataDate, time, heartRateBpm,elapsedtimeSS] = readInHRMfile(path)

    %PLOT CONFIG
    X_MAX_LIMIT = 300; %seconds duration
    Y_MAX_LIMIT = 100;
    Y_MIN_LIMIT = 40;

	
	fileData = textscan(file, '%s');
    fileData= fileData{1};
    fileData= char(fileData);
	
    % Get the date
	
    dataDate =0 ;
    for i=1:length(fileData(:,1))
        
        if(findstr(fileData(i,:),'Date')>0)
           dataDate = fileData(i,6:14)
           break
        end
    end
    
    % Convert to date vector
    dateDateTimeStart = datetime(dataDate,'InputFormat','yyyyMMdd')
   
	% Get the time
    time =0 ;
    for i=1:length(fileData(:,1))
        
        if(findstr(fileData(i,:),'StartTime')>0)
           time = fileData(i,11:20);
           break
        end
    end

   
    timeDateTimeStart = datetime(time,'InputFormat','HH:mm:ss.s')

    % Combine date and time dateTime objects
    startDateTime = datevec(timeDateTimeStart);
    timeVectorStart = datevec(dateDateTimeStart);
    startVectorDateTime(1:3) =timeVectorStart(1:3);
    
    
    startDateTime = datetime(startVectorDateTime);
    
	% Split the file around the "[HRData]" marker
    hrPeriod =0;
    dataIndex = 0;
    for i=1:length(fileData(:,1))
        
        if(findstr(fileData(i,:),'[HRData]')>0);
           
            dataIndex=i+1;
           break
        end
    end
    
    	
    hrPeriodDouble=0;
    hrPeriod = fileData(dataIndex:end,:)


   for i=1:length(hrPeriod)
        
        hrPeriodDouble(i)=str2num(hrPeriod(i,:));

   end
    
   %Go through the data set BACKWARDS and find the last non-'3999' timeout
   %value
   
   lastDataindex = length(hrPeriod);
   for i=length(hrPeriod):-1:1
        
        if(hrPeriodDouble(i)~= 3999)
            lastDataindex = i;
            break;
        end

   end
   
   hrPeriodDouble = hrPeriodDouble(1:lastDataindex);
   


	% this is the hear rate in bps
	heartRateBps = ((hrPeriodDouble')/1000).^-1;

	heartRateBpm =  heartRateBps.*60;


	% make a vector of the time by adding the time between readings
	elapsedtimeMS(1)=0;

	for(i=2: length(hrPeriodDouble));

		elapsedtimeMS(i) = hrPeriodDouble(i-1)+elapsedtimeMS(i-1);
    end
    
    elapsedtimeSS = startDateTime+ seconds(elapsedtimeMS/1000)';
    
    pl = plot(elapsedtimeSS, heartRateBpm)
    ylim([Y_MIN_LIMIT,Y_MAX_LIMIT]);
    %xlim([elapsedtimeSS(1),elapsedtimeSS(1)+seconds(X_MAX_LIMIT)]);
    title(strcat('Output from Polar HRM file: ',path));
    xlabel('date and time')
    ylabel('HR (bpm)')
    
	return
end