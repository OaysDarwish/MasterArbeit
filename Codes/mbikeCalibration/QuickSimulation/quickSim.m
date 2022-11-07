% ****************************************************************************
% FUNCTION: quickSim
%
% Simulate Calibration for a given Test-File (in data.accXYZ....)
function a = quickSim(data,t_start, t_stop)



% Create and Initialize Calibration Object
accXYZ_Sf = [data.AccSfX_mg(1) data.AccSfY_mg(1) data.AccSfZ_mg(1)];
gyrXYZ_Sf = [data.GyrSfX_mdegs(1) data.GyrSfY_mdegs(1) data.GyrSfZ_mdegs(1)];

calib = calibration;
calib.setup();
calib.init(accXYZ_Sf);


clear myAlgoOUTPUT
global myAlgoOUTPUT; %Remark: must also be declared once in Matlab Scope -> WTF: call "global myAlgoOUTPUT" in Console
myAlgoOUTPUT = [];
myAlgoOUTPUT.accXYZ_raw     = [];
myAlgoOUTPUT.gravityBaseline= [];
myAlgoOUTPUT.accXYZ_filter1 = [];
myAlgoOUTPUT.accXYZ_calibrated= [];
myAlgoOUTPUT.speed_kmh      = [];         
myAlgoOUTPUT.speed_diff_m_s2= [];         

myAlgoOUTPUT.gyrXYZ_raw     = [];
myAlgoOUTPUT.gyrXYZ_filter1 = [];
myAlgoOUTPUT.gyrXYZ_calibrated= [];

myAlgoOUTPUT.CalibState     = [];
myAlgoOUTPUT.CalibMode      = [];
myAlgoOUTPUT.driveSituation = [];
myAlgoOUTPUT.CalibGravityXYZ= [];
myAlgoOUTPUT.CalibYaw       = [];



myAlgoOUTPUT.debug1         = [];
myAlgoOUTPUT.debug2         = [];
myAlgoOUTPUT.debug3         = [];
myAlgoOUTPUT.debug4         = [];
myAlgoOUTPUT.debug5         = [];
myAlgoOUTPUT.debug6         = [];
myAlgoOUTPUT.debug7         = [];
myAlgoOUTPUT.debug8         = [];
myAlgoOUTPUT.debug9         = [];
myAlgoOUTPUT.debug10        = [];
myAlgoOUTPUT.debug11        = [];
myAlgoOUTPUT.debug12        = [];
myAlgoOUTPUT.debug13        = [];
myAlgoOUTPUT.debug14        = [];
myAlgoOUTPUT.debug15        = [];
myAlgoOUTPUT.debug16        = [];
myAlgoOUTPUT.debug17        = [];
myAlgoOUTPUT.debug18        = [];
myAlgoOUTPUT.debug19        = [];
myAlgoOUTPUT.debug20        = [];

myAlgoOUTPUT.SuperDebug     = [];


if (t_start==0) t_start=1; end
if (t_stop==0)  t_stop=length(data.AccSfX_mg); end
if (t_stop > length(data.AccSfX_mg)) t_stop=length(data.AccSfX_mg); end

%Iterate through whole Measurment and update Calibration in each Cycle
progress=0;
for cycle_i = t_start:t_stop
    
    %disp([num2str(cycle_i-t_start),':', num2str(t_stop-t_start), ' -> ', num2str((cycle_i-t_start)*100/(t_stop-t_start)) ])
    if (progress <= ((cycle_i-t_start)*100/(t_stop-t_start)))
        fprintf('%d0.', fix((cycle_i-t_start)*10/(t_stop-t_start)));
        progress = progress+10;
    end
    if mod(cycle_i,500) == 0                        
        %    fprintf('%d', ((cycle_i-t_start)*10/t_stop-t_start));
        fprintf('.');      
        %end 
    end
    
       
    
    accXYZ_Sf = single([data.AccSfX_mg(cycle_i) data.AccSfY_mg(cycle_i) data.AccSfZ_mg(cycle_i)]);
    gyrXYZ_Sf = single([data.GyrSfX_mdegs(cycle_i) data.GyrSfY_mdegs(cycle_i) data.GyrSfZ_mdegs(cycle_i)]);
    speed_kmh = single(data.speed_kmh(cycle_i));

    
    %Fake-Rotation zum test    
    if false  
           w=20/180*pi;
           w2=120/180*pi;
           accXYZ_Sf = [(cos(w)*accXYZ_Sf(1) -sin(w) * accXYZ_Sf(2)) (sin(w)*accXYZ_Sf(1) +cos(w) * accXYZ_Sf(2)) accXYZ_Sf(3)];
           gyrXYZ_Sf = [(cos(w)*gyrXYZ_Sf(1) -sin(w) * gyrXYZ_Sf(2)) (sin(w)*gyrXYZ_Sf(1) +cos(w) * gyrXYZ_Sf(2)) gyrXYZ_Sf(3)];
           
           accXYZ_Sf = [accXYZ_Sf(1) (cos(w2)*accXYZ_Sf(2) -sin(w2) * accXYZ_Sf(3)) (sin(w2)*accXYZ_Sf(2) +cos(w2) * accXYZ_Sf(3)) ];
           gyrXYZ_Sf = [gyrXYZ_Sf(1) (cos(w2)*gyrXYZ_Sf(2) -sin(w2) * gyrXYZ_Sf(3)) (sin(w2)*gyrXYZ_Sf(2) +cos(w2) * gyrXYZ_Sf(3)) ];
           
    end
    
    %update Calibration with new sampled value
    [calibratedAccXYZ_Sf, calibratedGyrXYZ_Sf, ~] = calib.update(speed_kmh, accXYZ_Sf, gyrXYZ_Sf);
    
    if cycle_i == -1
    %if cycle_i == 5600
    %if mod(cycle_i,300) == 0    
        disp(' ');
        disp(['****updateProbepoint cycle_i: ',num2str(cycle_i)]);
        calib.updateProbepoint(speed_kmh, accXYZ_Sf, gyrXYZ_Sf);
    end
    
    % Generate Debug-Output        
    myAlgoOUTPUT.accXYZ_raw         = cat(1,myAlgoOUTPUT.accXYZ_raw, accXYZ_Sf);
    myAlgoOUTPUT.gyrXYZ_raw         = cat(1,myAlgoOUTPUT.gyrXYZ_raw, gyrXYZ_Sf);
    myAlgoOUTPUT.speed_kmh          = cat(1,myAlgoOUTPUT.speed_kmh, speed_kmh);

    myAlgoOUTPUT.accXYZ_calibrated  = cat(1,myAlgoOUTPUT.accXYZ_calibrated, calibratedAccXYZ_Sf);
    myAlgoOUTPUT.gyrXYZ_calibrated  = cat(1,myAlgoOUTPUT.gyrXYZ_calibrated, calibratedGyrXYZ_Sf);
    
    
    myAlgoOUTPUT.CalibMode            = cat(1,myAlgoOUTPUT.CalibMode, calib.mode);
    myAlgoOUTPUT.CalibState           = cat(1,myAlgoOUTPUT.CalibState, calib.state);
    myAlgoOUTPUT.CalibGravityXYZ      = cat(1,myAlgoOUTPUT.CalibGravityXYZ, calib.mountingOrientation.confirmedGravity);
    myAlgoOUTPUT.CalibYaw             = cat(1,myAlgoOUTPUT.CalibYaw, calib.mountingOrientation.confirmedYaw);
    myAlgoOUTPUT.driveSituation       = cat(1,myAlgoOUTPUT.driveSituation, calib.driveSituation);
    
    myAlgoOUTPUT.speed_diff_m_s2     = cat(1,myAlgoOUTPUT.speed_diff_m_s2, calib.speed_diff_m_s2);

    myAlgoOUTPUT.gravityBaseline    = cat(1,myAlgoOUTPUT.gravityBaseline, calib.gravityBaseline);
    myAlgoOUTPUT.accXYZ_filter1     = cat(1,myAlgoOUTPUT.accXYZ_filter1, calib.Debug_accXYZ_filter1);
    myAlgoOUTPUT.gyrXYZ_filter1     = cat(1,myAlgoOUTPUT.gyrXYZ_filter1, calib.Debug_gyrXYZ_filter1);
    
    
    
    myAlgoOUTPUT.debug1              = cat(1,myAlgoOUTPUT.debug1, calib.Debug_Debug1);
    myAlgoOUTPUT.debug2              = cat(1,myAlgoOUTPUT.debug2, calib.Debug_Debug2);
    myAlgoOUTPUT.debug3              = cat(1,myAlgoOUTPUT.debug3, calib.Debug_Debug3);
    myAlgoOUTPUT.debug4              = cat(1,myAlgoOUTPUT.debug4, calib.Debug_Debug4);
    myAlgoOUTPUT.debug5              = cat(1,myAlgoOUTPUT.debug5, calib.Debug_Debug5);
    myAlgoOUTPUT.debug6              = cat(1,myAlgoOUTPUT.debug6, calib.Debug_Debug6);
    myAlgoOUTPUT.debug7              = cat(1,myAlgoOUTPUT.debug7, calib.Debug_Debug7);
    myAlgoOUTPUT.debug8              = cat(1,myAlgoOUTPUT.debug8, calib.Debug_Debug8);
    myAlgoOUTPUT.debug9              = cat(1,myAlgoOUTPUT.debug9, calib.Debug_Debug9);
    myAlgoOUTPUT.debug10             = cat(1,myAlgoOUTPUT.debug10, calib.Debug_Debug10);
    myAlgoOUTPUT.debug11             = cat(1,myAlgoOUTPUT.debug11, calib.Debug_Debug11);
    myAlgoOUTPUT.debug12             = cat(1,myAlgoOUTPUT.debug12, calib.Debug_Debug12);
    myAlgoOUTPUT.debug13             = cat(1,myAlgoOUTPUT.debug13, calib.Debug_Debug13);
    myAlgoOUTPUT.debug14             = cat(1,myAlgoOUTPUT.debug14, calib.Debug_Debug14);
    myAlgoOUTPUT.debug15             = cat(1,myAlgoOUTPUT.debug15, calib.Debug_Debug15);
    myAlgoOUTPUT.debug16             = cat(1,myAlgoOUTPUT.debug16, calib.Debug_Debug16);
    myAlgoOUTPUT.debug17             = cat(1,myAlgoOUTPUT.debug17, calib.Debug_Debug17);
    myAlgoOUTPUT.debug18             = cat(1,myAlgoOUTPUT.debug18, calib.Debug_Debug18);
    myAlgoOUTPUT.debug19             = cat(1,myAlgoOUTPUT.debug19, calib.Debug_Debug19);
    myAlgoOUTPUT.debug20             = cat(1,myAlgoOUTPUT.debug20, calib.Debug_Debug20);

   myAlgoOUTPUT.SuperDebug           = cat(1,myAlgoOUTPUT.SuperDebug, calib.Debug_SuperDebug);



end


fprintf('\n');
disp('Simulation done');
figure(1)
% Plot Debug-Output
tiledlayout(4,3);

myPlot1 = nexttile;
plot(myAlgoOUTPUT.speed_kmh);
hold on;
plot(myAlgoOUTPUT.speed_diff_m_s2);
title('1: speedKMH speeddiff-m-s2')

myPlot2 = nexttile;
plot(myAlgoOUTPUT.accXYZ_raw);
title('2: accXYZ raw')

myPlot3 = nexttile;
plot(myAlgoOUTPUT.gyrXYZ_raw);
title('3: gyrXYZ raw')

myPlot4 = nexttile;
plot(myAlgoOUTPUT.CalibMode);
hold on;
plot(myAlgoOUTPUT.CalibState);
plot(myAlgoOUTPUT.driveSituation);
title('4: CalibMode   CalibState driveSituation')

myPlot5 = nexttile;
plot(myAlgoOUTPUT.accXYZ_calibrated);
hold on;
%plot(myAlgoOUTPUT.gravityBaseline);
title('5: accXYZ-calibrated')

myPlot6 = nexttile;
plot(myAlgoOUTPUT.gyrXYZ_calibrated);
title('6: gyrXYZ-calibrated')

myPlot7 = nexttile;
plot(myAlgoOUTPUT.debug1);
hold on;
plot(myAlgoOUTPUT.debug2);
plot(myAlgoOUTPUT.debug3);
plot(myAlgoOUTPUT.debug4);
plot(myAlgoOUTPUT.debug5);
title('7: debug 1 2 3 4 5')

myPlot8 = nexttile;
plot(myAlgoOUTPUT.accXYZ_filter1);
hold on;
%plot(myAlgoOUTPUT.gravityBaseline);
plot(myAlgoOUTPUT.CalibYaw);
plot(myAlgoOUTPUT.CalibGravityXYZ);
title('8: accXYZ-filter1 CalibGravityXY CalibYaw')

myPlot9 = nexttile;
plot(myAlgoOUTPUT.debug11);
hold on;
plot(myAlgoOUTPUT.debug12);
plot(myAlgoOUTPUT.debug13);
plot(myAlgoOUTPUT.debug14);
plot(myAlgoOUTPUT.debug15);
title('9: Debug 11 12 13 14 15')

myPlot10 = nexttile;
plot(myAlgoOUTPUT.debug6);
hold on;
plot(myAlgoOUTPUT.debug7);
plot(myAlgoOUTPUT.debug8);
plot(myAlgoOUTPUT.debug9);
plot(myAlgoOUTPUT.debug10);
title('10: debug 6 7 8 9 10')

myPlot11 = nexttile;
plot(myAlgoOUTPUT.debug16);
hold on;
plot(myAlgoOUTPUT.CalibYaw);
plot(myAlgoOUTPUT.debug17);
plot(myAlgoOUTPUT.debug18);
plot(myAlgoOUTPUT.debug19);
plot(myAlgoOUTPUT.debug20);

title('11: debug 16 17 18 19 20 CalibYaw')

myPlot12 = nexttile;

plot(myAlgoOUTPUT.accXYZ_filter1(:,2));
hold on;
plot(myAlgoOUTPUT.SuperDebug);
title('12: SuperDebug')

linkaxes([myPlot1 myPlot2 myPlot3 myPlot4 myPlot5 myPlot6 myPlot7 myPlot8 myPlot9 myPlot10 myPlot11  myPlot12],'x');
end





