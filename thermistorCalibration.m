clear; clc
format short

%finding cubic constants for thermistor NTCLE413E2103F102L
%using Steinhart-Hart equation

%create x matrix with increment of 5
temp = zeros(1,16);
for i = 1:16
    temp(1,i) = (i*5)+273;
end

%inserting non-incremental temperature values
temp = [temp(1:4), 21+273, temp(5:end)];
temp = [temp(1:0), 275, temp(1:end)];
invertT = 1./temp;

%Y matrix ie ln(R)
resistance = [25, 22.9, 17.78, 13.4, 12.86, 10.42, 10.42, 8.83, 7.5, 6.06,... 
              5.10, 4.33, 3.75, 3.15, 3.03, 2.06, 1.65, 1.41];

%natural log of resistance from Steinhart
rNorm = log(resistance);

%characteristics x matrix
x = zeros(18,3);
for i = 1:18
    x(i, :) = [1, rNorm(i), rNorm(i)^3];
end

invertT = invertT';

%polynomial constants
a = x\invertT;