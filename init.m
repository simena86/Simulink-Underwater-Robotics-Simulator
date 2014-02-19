%-----------------------------------
%
%  this file holds the parameters 
%  defining the kinematic structure
%  in Denavit-Hartenbarg terms
%
%-----------------------------------

clear all; clc;

%% The denavit-hartenberg defines each frame as a homognous transformation
% definded by:
%               Ai=Rot_z(theta)Trans_z(d)Trans_x(a)Rot_x(alpha)
%

%clear all;clc;

d2r=pi/180;
r2d=180/pi;
n=6;



% Tbi is the parent class of all transformations from body to frame i -
% with both homoegneous, rotation and position matrices/vectors
Ti = struct('g0b',zeros(3,3),'g0i',zeros(4,4,n),'R0i', zeros(3,3,n),'p0i', zeros(3,1,n),  'Adg0i',zeros(6,6,n),'Adg0i_inv',zeros(6,6,n),   ...
'gbi',zeros(4,4,n),'Rbi', zeros(3,3,n),'pbi', zeros(3,1,n),'Adgbi',zeros(6,6,n),'Adgbi_inv',zeros(6,6,n),...
'g6e',eye(4) ,'g0e',zeros(4,4),'R0e', zeros(3,3),'p0e', zeros(3,1),  'Adg0e',zeros(6,6),'Adg0e_inv',zeros(6,6),   ...
'gbe',zeros(4,4),'Rbe', zeros(3,3),'pbe', zeros(3,1),'Adgbe',zeros(6,6),'Adgbe_inv',zeros(6,6) ...
);

Ji = struct('Ji',zeros(n,n+6),'Je',zeros(n,n+6));

DH=struct('a',zeros(n,1),'d',zeros(n,1),'alpha',zeros(n,1));
DH.a(1) = 0.2;
DH.a(2) = 1;
DH.a(3) = 0.6;
DH.a(4) = 0.4;
DH.a(5) = 0;
DH.a(6) = 0;

DH.d(1) = 0;
DH.d(2) = 0;
DH.d(3) = 0;
DH.d(4) = 0;
DH.d(5) = 0;
DH.d(6) = 0.4;

DH.alpha(1) = pi/2;
DH.alpha(2) = 0;
DH.alpha(3) = 0;
DH.alpha(4) = -pi/2;
DH.alpha(5) = -pi/2;
DH.alpha(6) = 0;

busInfo = Simulink.Bus.createObject(DH);
busInfo2 = Simulink.Bus.createObject(Ti);
busInfo3 = Simulink.Bus.createObject(Ji);


%% joint limits - global parameters 

global qmin;
global qmax;

qmin(1)=-70*(pi/180);
qmax(1)=70*(pi/180);

qmin(2)=-70*(pi/180);
qmax(2)=70*(pi/180);

qmin(3)=-70*(pi/180);
qmax(3)=70*(pi/180);

qmin(4)=-70*(pi/180);
qmax(4)=70*(pi/180);

qmin(5)=90*(pi/180) - 70*(pi/180);
qmax(5)=70*(pi/180) + 90*(pi/180);

qmin(6)=-160*(pi/180);
qmax(6)=160*(pi/180);




%% set robot configurations
global six_link;

for i =1:6
    l(i) = Link([0, DH.d(i), DH.a(i), DH.alpha(i)]);
end


six_link = SerialLink(l,'name','six link');
 


aq=[0,3,0,0,0,1];

six_link.fkine(aq);
g0b=eye(4);


%%

%sim('uvms',1);




