%% Analog Electronics final project

clc; 
%close all; 
clear;

addpath(genpath('circuitDesign'));
addpath(genpath('functions'));
addpath(genpath('modelg'));

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
simulgkelFile		= 0;
spec				= [];
analog			= cirInit('analog',circuitTitle,'top',elementList,spec,choice,...
						designkitName,NRVT,PRVT,simulator,simulFile,simulgkelFile);
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

%% project specs

Cl = 5*10^-12
GBWf = 17500000
GBW = GBWf*2*pi
gain = 223.87
VDD = 1.1

Ibias = 20e-6
%% AI: Implement your OpAmp according to your handcalculations

%Mp1 and Mp2
Mp1.ids = 1.0906e-6
Mp1.lg = 1000*10^-9
Mp1.vsb = 0;
Mp1.vds = -0.3
Mp1.vgs = -0.2
Mp1.vth = tableValueWref('vth', PRVT, Mp1.lg, 0, Mp1.vds, Mp1.vsb);
Mp1.w = mosWidth('ids', Mp1.ids, Mp1);
Mp1 = mosNfingers(Mp1);
Mp1 = mosOpValues(Mp1);

Mp1 = mosNfingers(Mp1);
Mp1 = mosOpValues(Mp1);

Mp2.gm = Mp1.gm;
Mp2.gds = Mp1.gds
Mp2.lg = Mp1.lg
Mp2.w = Mp1.w
Mp2.vgs = Mp1.vgs
Mp2.vds = Mp1.vds
Mp2.vsb = Mp1.vsb
Mp2.ids = Mp1.ids
Mp2 = mosNfingers(Mp2);
Mp2 = mosOpValues(Mp2);

%Mn3 and Mn4
Mn4.ids = Mp1.ids
Mn4.lg = 1e-6
Mn4.vsb = 0;
Mn4.vds = 0.4
Mn4.vgs = Mn4.vds
Mn4.w = mosWidth('ids', Mn4.ids, Mn4);
Mn4 = mosNfingers(Mn4);
Mn4 = mosOpValues(Mn4)

Mn3.gm = Mn4.gm
Mn3.gds = Mn4.gds
Mn3.ids = Mn4.ids
Mn3.lg = Mn4.lg
Mn3.w = Mn4.w
Mn3.vgs = Mn4.vgs
Mn3.vsb = Mn4.vsb
Mn3.vds = Mn4.vds
Mn3 = mosNfingers(Mn3);
Mn3 = mosOpValues(Mn3);


%Mn6

%Mn6.gm = 0.001602212253331
%Mn6.gds = 2.004203332554601e-07;
Mn6.ids = 46e-6
Mn6.lg = 80e-9
Mn6.vsb = 0;
Mn6.vds = 0.550
Mn6.vgs = 0.3537
Mn6.w = mosWidth('ids', Mn6.ids, Mn6);
Mn6 = mosNfingers(Mn6);
Mn6 = mosOpValues(Mn6);

%Mp8
Mp8.lg = 1e-6
Mp8.ids = Ibias
Mp8.vgs = -0.550
Mp8.vds = Mp8.vgs
Mp8.vgd = 0
Mp8.vsb = 0
Mp8.w =  mosWidth('ids', Mp8.ids, Mp8);
Mp8 = mosNfingers(Mp8);
Mp8 = mosOpValues(Mp8);

%Mp5
Mp5.ids = Mn6.ids
Mp5.lg = 120*10^-9
Mp5.vsb = 0;
Mp5.vds = -0.550
Mp5.vgs = -0.540
Mp5.w = mosWidth('ids', Mp5.ids, Mp5);
Mp5 = mosNfingers(Mp5);
Mp5 = mosOpValues(Mp5);

%Mp7
Mp7.ids = Mp1.ids + Mp2.ids
Mp7.lg = 1000*10^-9
Mp7.vsb = 0;
Mp7.vds = -0.4
Mp7.vgs = Mp8.vds
Mp7.w = mosWidth('ids', Mp7.ids, Mp7);
Mp7 = mosNfingers(Mp7);
Mp7 = mosOpValues(Mp7);

%% AI: Set-up Rm, Cc and CL and calculate the zero required for the transfer-fct


AvDC1 = Mp1.gm/(Mp1.gds + Mn3.gds);  % DC gain 1st stage
AvDC2 = Mn6.gm/(Mn6.gds + Mp5.gds);  % DC gain 2nd stage

spec.Cm = (Mp1.gds + Mn3.gds)/(GBW/(AvDC1*AvDC2) * (1+abs(AvDC2)));
spec.Cl = 5e-12;
spec.Rm = (1+ spec.Cl/spec.Cm)/Mn6.gm;
z1 = 1/ (spec.Cm*(1/Mn6.gm - spec.Rm));

%% AI: Fill out the empty variables required to plot the transfer-function.
%  meaning of each variable see comment and
%  location of nodes see line 31 


C1    = Mn3.cgs + Mn3.cgb + Mp1.cgd + Mp1.cdb + Mn4.cgs;  % Capacitance on node 1
G1    = Mn3.gm + Mp1.gds;  % Admittance  on node 1
C2    = spec.Cm*(1+AvDC2); %miller % Capacitance on node 2
G2    = Mn4.gds + Mp2.gds;  % Admittance  on node 2
C3    = spec.Cl;  % Capacitance on node 3
G3    = Mn6.gm ;  % Admittance  on node 3
C4    = spec.Cl;  % Capacitance on node 4
G4    = spec.Rm;  % Admittance on node 4 (hint: what happens with CL at very high frequencies?)

G1/C1
G2/C2
G3/C3
G4/C4
z1
%% AI: Fill out the empty variables required for the performance summary
Vin_cm_min  = Mp2.vth + Mn4.vth + Mn4.vov
Vin_cm_max  = Mp7.vov + Mp2.vov + VDD; 
Vout_cm_min = Mn6.vdsat;                         
Vout_cm_max = VDD - abs(Mp5.vdsat);  
Vswing = Vout_cm_max - Vout_cm_min
Pdiss       = VDD*(Mp8.ids + Mp7.ids + Mp5.ids);

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
fprintf('IBIAS\t= %6.2fmA\nRm\t= %6.2f Ohm\nCm\t= %6.2fpF\n\n',Mp8.ids,spec.Rm,spec.Cm/1e-12);

%% Performance summary (do not modify)

disp('======================================');
disp('=        Performance                 =');
disp('======================================');

fprintf('\nmetrik        \t result\n');
fprintf('Vin,cm,min [mV] \t%.0f\n',Vin_cm_min/1e-3);
fprintf('Vin,cm,max [mV] \t%.0f\n',Vin_cm_max/1e-3);
fprintf('Vout,cm,min [mV] \t%.0f\n',Vout_cm_min/1e-3);
fprintf('Vout,cm,max [mV] \t%.0f\n',Vout_cm_max/1e-3);
fprintf('Vswing [mV]      \t%.0f\n',Vswing/1e-3);
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

figure
margin(TF1)

