%Amatthewskott, April 12 2024, brg dist intersection
%input: 1st point, 2nd point, bearing from point 1, distance from point 2
%processing:
%output:

clear
clc
format longg


function MyRad=MyD2R(D,M,S) % Converts DMS to radians

factor = 1;

if D < 0 || M <0 || S<0
    factor = -1;
end

MyRad= factor*(abs(D)+abs(M)/60+abs(S)/3600)*pi/180;

endfunction

function DMS = MyR2D(rad) % Converts Radians to DMS

 factor=1;55
if rad<0
     rad =abs(rad);
     factor=-1;
end

rad=rad*180/pi;
d   = fix(rad);
%  Degrees
ms  = 60*(rad - d);         %  Minutes and seconds
m   = fix(ms);              %  Minutes
s   = 60*(ms - m);         %  Seconds

if (ceil(s) - s)<0.0001
    s=ceil(s);
    %disp('s')
end

if s>=60
    s=s-60;
    m=m+1;
end

if m>=60
    m=m-60;
    d=d+1;
end


while d>=360
    d=d-360;
    disp('hi')
end

%taking care of the negative sign
if d>0
    d= d* factor;
elseif m>0
    m=m*factor;
elseif s>0
    s=s*factor;
end

DMS=[d,m,s];

endfunction



N1 = input('Input 1st point northing: ');
E1 = input('Input 1st point easting: ');
N2 = input('Input 2nd point northing: ');
E2 = input('Input 2nd point easting: ');



%Find change in northing and easting
dN = N2 - N1;
dE = E2 - E1;


%Find bearing P1 to P2

if dN >= 0 && dE >= 0
  BrgP1P2 = atan(dE / dN);

elseif dN < 0 && dE >= 0
  BrgP1P2 = atan(dE / dN) + pi;

elseif dN < 0 && dE < 0
  BrgP1P2 = atan(dE / dN) + pi;

else
  BrgP1P2 = atan(dE / dN)  + 2 * pi;
endif

%Find distance P1 to P2
DistP1P2 = sqrt(dE ^2 + dN ^2);



%}
BrgP1P3Deg = input('Input bearing degrees: ');
BrgP1P3Min = input('Input bearing minutes: ');
BrgP1P3Sec = input('Input bearing seconds: ');

BrgP1P3 = MyD2R(BrgP1P3Deg, BrgP1P3Min, BrgP1P3Sec);
DistP2P3 = input('Input distance between P1 and P2: ');


%Find angle between P1 to P2 and P1 to P3
if BrgP1P2 > BrgP1P3
  AngP1 = BrgP1P2 - BrgP1P3;

else
  AngP1 = BrgP1P3 - BrgP1P2;
end

DistP2T = DistP1P2 * sin(AngP1);
DistP1T = DistP1P2 * cos(AngP1);

DistP2TRound = round(DistP2T * 1000) / 1000;

%Determine number of solutions and print results
if DistP2P3 < DistP2TRound
  printf('No solution.\n')

elseif DistP2P3 == DistP2TRound
  DistP3T = sqrt(DistP2P3 ^2 - DistP2T ^2);
  DistP1P3 = DistP1T - DistP3T;
  N3 = N1 + DistP1P3 * cos(BrgP1P3);
  E3 = E1 + DistP1P3 * sin(BrgP1P3);

  printf('One solution.\n\n')
  printf('N %.3f, E %.3f\t Distance from P1: %.3f\n', N3, E3, DistP1P3)

else DistP2P3 > DistP2TRound
  DistP3T = sqrt(DistP2P3 ^2 - DistP2T ^2);
  DistP1P3 = DistP1T - DistP3T;
  DistP1P4 = DistP1T + DistP3T;
  N3 = N1 + DistP1P3 * cos(BrgP1P3);
  E3 = E1 + DistP1P3 * sin(BrgP1P3);
  N4 = N1 + DistP1P4 * cos(BrgP1P3);
  E4 = E1 + DistP1P4 * sin(BrgP1P3);

  printf('Two solutions.\n\n')
  printf('N %.3f, E %.3f\t Distance from P1: %.3f\n\n', N3, E3, DistP1P3)
  printf('N %.3f, E %.3f\t Distance from P1: %.3f\n', N4, E4, DistP1P4)
end
