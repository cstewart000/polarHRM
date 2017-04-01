# polarHRM
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
