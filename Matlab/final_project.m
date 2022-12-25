%% Analog Electronics final project

clc; 
%close all; 
clear;

addpath(genpath('circuitDesign'));
addpath(genpath('functions'));
addpath(genpath('models'));

load('UMC65_RVT.mat');

%% Initializations
designkitName		= 'umc65';
circuitTitle		= 'Analog Design - Project';
elementList.nmos	= {'Mn3','Mn4','Mn6'};
elementList.pmos	= {'Mp1','Mp2','Mp5','Mp7','Mp8'};

choice.maxFingerWidth = 10e-6;
choice.minFingerWidth = 200e-9;

simulator			= 'spectre';
simulFile			= 0;
simulSkelFile		= 0;
spec				= [];
analog			= cirInit('analog',circuitTitle,'top',elementList,spec,choice,...
						designkitName,NRVT,PRVT,simulator,simulFile,simulSkelFile);
analog			= cirCheckInChoice(analog, choice);


%% Project: circuit
disp('                                                       ');
disp('  VDD          VDD                    VDD              ');
disp('   |             |                      |              ');
disp('  Mp8-+---------Mp7---------------------Mp5            ');
disp('   |--+          |                      |              ');
disp('   |          +--+--+         node 3->  +-----+---OUT  ');
disp('   |          |     |                   |     |        ');
disp('   |    IN1--Mp1   Mp2--IN2             |     |        ');
disp('   |          |     |                   |     |        ');
disp('   | node 1-> |     | <-node 2          |     Cl       ');
disp('   |          |--+  +------+-Cm---Rm----+     |        ');
disp(' Ibias        |  |  |      |    ↑       |     |        ');
disp('   |         Mn3-+-Mn4     |  node 4    |     |        ');
disp('   |          |     |      +-----------Mn6    |        ');
disp('   |          |     |                   |     |        ');
disp('  GND        GND   GND                 GND   GND       ');

%% AI: Implement your OpAmp according to your handcalculations

%Mp1 and Mp2
Mp1.gm = 1.335176877775662e-07;
%Mp1.gds = 1.335176877775662e-07;
Mp1.ls = 5.000000000000001e-07;
Mp1.w = 10*Mp1.ls;
Mp1.ov = -0.2;
Mp1.vgs = -0.034000000000000;
Mp1.vds = -0.336;
Mp1.vsb = 0;
Mp1 = mosNfingers(Mp1);
Mp1 = mosOpValues(Mp1);

Mp2.gm = 1.335176877775662e-07;
%Mp2.gds = 1.335176877775662e-07;
Mp2.ls = 5.000000000000001e-07;
Mp2.w = 10*Mp2.ls;
Mp2.ov = -0.2;
Mp2.vgs = -0.034000000000000;
Mp2.vds = -0.336;
Mp2.vsb = 0;
Mp2 = mosNfingers(Mp2);
Mp2 = mosOpValues(Mp2);

%Mn3 and Mn4
Mn4.gm = 2.774798067659500e-07;
%Mn4.gds = 5.983811117921269e-09;
Mn4.ls = 5.000000000000001e-07;
Mn4.w = 10*Mn4.ls;
Mn4.vgs = 0.050000000000000;
Mn4.vsb = 0;
Mn4.vds = 0.336;
Mn4.ov = 0;
Mn4 = mosNfingers(Mn4);
Mn4 = mosOpValues(Mn4);

Mn3.gm = 2.774798067659500e-07;
%Mn3.gds = 5.983811117921269e-09;
Mn3.ls = 5.000000000000001e-07;
Mn3.w = 10*Mn3.ls;
Mn3.vgs = 0.050000000000000;
Mn3.vsb = 0;
Mn3.vds = 0.336;
Mn3.ov = 0;
Mn3 = mosNfingers(Mn3);
Mn3 = mosOpValues(Mn3);


%Mn6

Mn6.gm = 1.602212253330795e-06;
%Mn6.gds = 2.004203332554601e-07;
Mn6.ls = 7.000000000000000e-08;
Mn6.w = 10*Mn6.ls;
Mn6.vgs = 0.4;
Mn6.vsb = 0;
Mn6.vds = 0.550000000000000;
Mn6.ov = 0.2;
Mn6 = mosNfingers(Mn6);
Mn6 = mosOpValues(Mn6);




%Mp8 and Mp5
Mp8.ls = 6.000000000000001e-08
Mp8.w = 10*Mp8.ls;
Mp8.ids = 1.414145096894760e-07
Mp8.vov = 0
Mp8.vds = -0.5500
Mp8.vgs = -0.24
Mp8.vsb = 0
Mp8 = mosNfingers(Mp8);
Mp8 = mosOpValues(Mp8);

Mp5.ls = 6.000000000000001e-08
Mp5.w = 10*Mp5.ls;
Mp5.ids = 1.414145096894760e-07
Mp5.vov = 0
Mp5.vds = -0.5500
Mp5.vgs = -0.24
Mp5.vsb = 0
Mp5 = mosNfingers(Mp5);
Mp5 = mosOpValues(Mp5);

%Mp7

Mp7.ls =  5.890166726979056e-06
Mp7.w = 10*Mp7.ls;
Mp7.ids = 1.200428750528804e-08
Mp7.vov = 0
Mp7.vds = -0.336000000000000
Mp7.vgs = -0.24
Mp7.vsb = 0
Mp7 = mosNfingers(Mp7);
Mp7 = mosOpValues(Mp7);






%% AI: Set-up Rm, Cc and CL and calculate the zero required for the transfer-fct

spec.Cm = 1.25*10^-12;
spec.Cl = 5*10^-12;
spec.Rm = 0.0001; 
z1 = spec.Rm/spec.Cm;

%% AI: Fill out the empty variables required to plot the transfer-function.
%  meaning of each variable see comment and
%  location of nodes see line 31 

AvDC1 = Mp1.gm/(Mp1.gds + Mn3.gds);  % DC gain 1st stage
AvDC2 = Mn6.gm/(Mn6.gds + Mp5.gds);  % DC gain 2nd stage
C1    = Mn3.cgs + Mn3.cgb + Mp1.cgd + Mp1.cdb + Mn4.cgs;  % Capacitance on node 1
G1    = Mn3.gm + Mp1.gds;  % Admittance  on node 1
C2    = spec.Cm;  % Capacitance on node 2
G2    = Mn4.gds + Mp2.gds;  % Admittance  on node 2
C3    = spec.Cl;  % Capacitance on node 3
G3    = Mn6.gds ;  % Admittance  on node 3
C4    = spec.Cm;  % Capacitance on node 4
G4    = 1/spec.Rm;  % Admittance on node 4 (hint: what happens with CL at very high frequencies?)




%% AI: Fill out the empty variables required for the performance summary
Vin_cm_min  = 0;   
Vin_cm_max  = 1.1; 
Vout_cm_min = 0;                         
Vout_cm_max = 1.1;             
Pdiss       = 5;

%% Sanity check (do not modify)

disp('======================================');
disp('=      Transistors in saturation     =');
disp('======================================');
if mosCheckSaturation(Mp1)
	fprintf('\nMp1:Success\n')
end
if mosCheckSaturation(Mp2)
	fprintf('Mp2:Success\n')
end
if mosCheckSaturation(Mn3)
	fprintf('Mn3:Success\n')
end
if mosCheckSaturation(Mn4)
	fprintf('Mn4:Success\n')
end
if mosCheckSaturation(Mp5)
	fprintf('Mp5:Success\n')
end
if mosCheckSaturation(Mn6)
	fprintf('Mn6:Success\n')
end
if mosCheckSaturation(Mp7)
	fprintf('Mp7:Success\n')
end
if mosCheckSaturation(Mp8)
	fprintf('Mp8:Success\n\n')
end


%% Summary of sizes and biasing points (do not modify)

disp('======================================');
disp('=    Sizes and operating points      =');
disp('======================================');
analog = cirElementsCheckOut(analog); % Update circuit file with 
% transistor sizes
mosPrintSizesAndOpInfo(1,analog); % Print the sizes of the 
% transistors in the circuit file
fprintf('IBIAS\t= %6.2fmA\nRm\t= %6.2f Ohm\nCm\t= %6.2fpF\n\n',Mp8.ids/1e-3,spec.Rm,spec.Cm/1e-12);

%% Performance summary (do not modify)

disp('======================================');
disp('=        Performance                 =');
disp('======================================');

fprintf('\nmetrik        \t result\n');
fprintf('Vin,cm,min [mV] \t%.0f\n',Vin_cm_min/1e-3);
fprintf('Vin,cm,max [mV] \t%.0f\n',Vin_cm_max/1e-3);
fprintf('Vout,cm,min [mV] \t%.0f\n',Vout_cm_min/1e-3);
fprintf('Vout,cm,max [mV] \t%.0f\n',Vout_cm_max/1e-3);
fprintf('Pdiss [mW]       \t%.1f\n',Pdiss/1e-3);

%% Ploting transfer function (do not modify)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if control toolbox in Matlab is available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s   = tf('s');
% transfer function
TF1   = AvDC1*AvDC2*((1+s*C1/(2*G1))*(1-s*(1/z1)))/ ...
                ((1+s*C1/G1)*(1+s*C2/G2)*(1+s*C3/G3)*(1+s*C4/G4));

freq = logspace(1,12,1e3);
figure
bode(TF1,2*pi*freq); grid on;
h = gcr;
setoptions(h,'FreqUnits','Hz');
title('Frequency response Opamp');
hold all


