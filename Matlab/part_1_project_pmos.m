%% Session1 HW: gm, gds, gm/IDS and gm/gds vs VGS for different L
% check dependencies in conclusion

%% Loading MOS tables
addpath(genpath('circuitDesign'));
addpath(genpath('functions'));
addpath(genpath('models'));


load ('UMC65_RVT.mat');

%% Initialize everything
designkitName   = 'umc65';
circuitTitle    = 'Analog Design';

%Declaration of the circuit components
elementList.pmos = {'Mp2'};

spec.VDD        = 1.1;
choice.maxFingerWidth = 10e-6;
choice.minFingerWidth = 200e-9;
simulator       ='spectre';
simulFile       = 0;
simulSkelFile   = 0;
analog = cirInit('analog', circuitTitle, 'top', elementList, spec , choice,...
    designkitName, NRVT, PRVT, simulator, simulFile, simulSkelFile);

analog          = cirCheckInChoice(analog, choice);

%% Circuit
disp('     spec.VDD/2       ');
disp('        |             ');
disp('        |             ');
disp('  Vg---Mpx            ');
disp('        |             ');
disp('        Vs            ');

fprintf('\n--- First Exercise: Designing transistor from scratch ---\n');


%% Intrinsic gain versus VGS for different L
VGS = -(0:0.025:spec.VDD).'; % [V], gate source voltage
L   = [60 80 100 200 300 500 1000 1500]*1e-9; % [m], gate length
gm  = NaN(length(L),length(VGS));
gds = NaN(length(L),length(VGS));
gmIDS = NaN(length(L),length(VGS));
Av    = NaN(length(L),length(VGS));
Av_db = NaN(length(L),length(VGS));
VOV   = NaN(length(L),length(VGS));
w     = NaN(length(L),length(VGS));
ft    = nan(length(L), length(VGS));

Mp2.vds = -0.336;
Mp2.vsb = 0;

for kk = 1:length(L)
    Mp2.lg = L(kk);
    Mp2.w = 10*Mp2.lg; %% W/L = 10
    for i=1:length(VGS)
        Mp2.vgs = VGS(i);
        Mp2 = mosNfingers(Mp2);
        Mp2 = mosOpValues(Mp2);
        
        VOV(kk,i) = Mp2.vov;
        gm(kk,i) = Mp2.gm;
        gds(kk,i) = Mp2.gds;
        gmIDS(kk,i) = Mp2.gm/Mp2.ids;
        Av(kk,i) = Mp2.gm / Mp2.gds;
        Av_db(kk,i) = 20*log10(Mp2.gm / Mp2.gds);
        ft(kk, i) = Mp2.ft/1e9;
                     
    end
end

%% Plot

figure();
subplot(221); plot(VGS,gm,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm (mag)');
grid on;
title('gm vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(222); plot(VGS,gds,'linewidth',2);
xlabel('VGS (V)');
ylabel('gds (mag)');
grid on;
title('gds vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(223); plot(VGS,Av,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm/gds (mag)');
grid on;
title('Intrinsic gain (gm/gds) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(224); plot(VGS,gmIDS,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm/IDS (mag)');
grid on;
title('Gain efficiency (gm/Ids) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');

figure();
subplot(221); plot(VOV.',gm.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm (mag)');
grid on;
title('gm vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(222); plot(VOV.',gds.','linewidth',2);
xlabel('VOV (V)');
ylabel('gds (mag)');
grid on;
title('gds vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(223); plot(VOV.',Av.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm/gds (mag)');
grid on;
title('Intrinsic gain (gm/gds) vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(224); plot(VOV.',gmIDS.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm/IDS (mag)');
grid on;
title('Gain efficiency (gm/Ids) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');

figure;
semilogy(VOV.',ft.','linewidth',2);
title('ft vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
xlabel('VOV (V)')
ylabel('ft (GHz)')
