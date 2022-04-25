clear; clc
format short

%finding cubic constants for thermistor NTCLE413E2103F102L
%using Steinhart-Hart equation

%create matrix for tested temperature in K
temp = zeros(1,16);
for i = 1:16
    temp(1,i) = (i*5)+273;
end

%inserting non-incremental temperature values
temp = [temp(1:4), 21+273, temp(5:end)];
temp = [temp(1:0), 275, temp(1:end)];
invertT = 1./temp;

%resistance reading
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


%finding coefficients of beta parameter
rNormBeta = log(resistance./resistance(6));
betaX = zeros(18,2);
for i = 1:18
    betaX(i, :) = [1, rNormBeta(i)];
end
b = betaX\invertT;

%plotting
figure
hold on
manR = [27.348, 22.108, 17.979, 14.706, 12.094, 10, ...
        8.311, 6.941, 5.825, 4.911, 4.158, 3.536, 3.02 ...
        2.589, 2.228, 1.925, 1.668];
manTemp = temp;
manTemp(6) = [];
betaTemp = 1./(betaX*b);
steinhartTemp = 1./(x*a);
plot(manR, manTemp, 'p');
plot(resistance,steinhartTemp);
plot(resistance, betaTemp, 'k');
xlabel('Resistance (kOhms)');
ylabel('Temperature (Kelvin)');
grid on
title('Temperature and Resistance Relationships')
legend('Manufacture','Steinhart', 'Beta', 'Location','best')