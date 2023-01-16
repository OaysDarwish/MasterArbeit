%% create a logFile object with the DEKRA test:
% logFile = Cobi_CrashAlgo_Logfile('C:\Users\dao1wa2\Bosch Group\Connected Life - Pocketmode@HC\Messdaten\20220811_Hosentasch_FussAnAmpelRunter\IMU_logFile_mb_android_samsung-SM-G973F_lib1.1.2_crcl4.0003_mcal1.2005_2022-08-11T16-16-05.665+0200_v13.csv');
filePath = '\\bosch.com\dfsrb\DfsDE\LOC\Wa2\BHCS\310_PJ-CL\025_Help_Connect\200_Algorithm\010_CrashDatabase\2022-06-18T08-08-00\IMU_logFile_mb_android_samsung-SM-G780F_lib1.1.1_crcl1.1973_mcal1.2005_2022-06-18T08-05-42.718+0200_v13.csv';
logFile = Cobi_CrashAlgo_Logfile(filePath);


%% simulating recorded data and visualize results

% copy the simulation data so the model can read it from workspace
data23 = logFile.getSimulationData;

% run the simulation
out = sim('CrashAlgo_TestEnvironment_Motorrad_v2');

% show the results in the Simulation Data Inspector
open('SDI_crashOverview.mldatx')


% time calculated during the simulation
tout = out.tout;

%% get activities out of the original csv-file


csvTable = readtable(filePath);
tableArray = table2array(csvTable);

accCounter = csvTable.accCounter ;

% prepare activity data of the table

for iTable = 1:height(csvTable)
    rowi = tableArray(iTable,:);
    activiesdata = rowi(end-9:end-2);
    [maxVal,iMax] = max(activiesdata);
    % IDs:  inVehicle = 1;  onBicycle = 2;  onFoot = 3;     still = 4; 
    %       unknown = 5;    tilting = 6;    walking = 7;    running = 8;
    tableActivityID(iTable) = iMax;
    tableActivityValue(iTable) = maxVal;
    tableActivitySum(iTable) = sum(activiesdata);
end
% recode the activity into -1, 0; 1; 2 like the motionClass
activityId = tableActivityID;
activityId (tableActivityID == 1) = 2;
% onFoot; walking; running;
activityId (tableActivityID == 3) = 1;
activityId (tableActivityID == 7) = 1;
activityId (tableActivityID == 8) = 1;

activityId (tableActivityID == 4) = 0;

activityId (tableActivityID == 5) = -1;
activityId (tableActivityID == 6) = -1;


%% some plots

% plot all activities
figure;
% IDs:  inVehicle = 1;  onBicycle = 2;  onFoot = 3;     still = 4; 
    %       unknown = 5;    tilting = 6;    walking = 7;    running = 8;
plot(accCounter, csvTable.running, ...
    accCounter, csvTable.walking, ...
    accCounter, csvTable.unknown, ...
    accCounter, csvTable.tilting, ...
    accCounter, csvTable.onFoot, ...
    accCounter, csvTable.inVehicle, ...
    accCounter, csvTable.still, ...
    accCounter, csvTable.onBicycle)
legend('running', 'walking', 'unknown', 'tilting', 'onFoot', 'inVehicle', 'still', 'onBicycle')



% plot original activities and recoded activities to doppel check 
figure; plot(1:length(activityId), activityId, 1:length(activityId), tableActivityID, '-o');
legend('ID','tableID')

% plot original activities on simulated timeStamp
figure; plot (tout, tableActivityID); title('max activityId - google - original - onFoot 3')

% plot recoded activities on simulated timeStamp
figure; plot (tout, activityId); title('activityId - google - recoded')

% plot speed of simulation on simulation time
figure; plot(tout, out.DU_speed_kmh); title('Speed out of sim')
% plot speed of original file on original timeStamp
figure; plot(csvTable.accCounter, out.DU_speed_kmh); title('Speed out of sim - AccCounterCSV')

% plot recoded activities on original timeStamp
figure; plot (csvTable.accCounter, tableActivityID); title('tableActivityID')

% plot GroundTruth activities on original timeStamp
figure; plot (tout, csvTable.Label_Auto_generated); title('tableActivityID')
figure; plot(1:length(activityId), activityId, 1:length(activityId), tableActivityID, '-o'); legend('ID','tableID')

% plot speed with groundtruth and google activities - recoded
figure; plot (tout, csvTable.Label_Auto_generated2*10, '-.', tout, out.DU_speed_kmh, tout, out.MD_motionClass*10, '--r'); 
title('Groundtruth, MotionClass,  speed')
legend('Groundtruth', 'Speed', 'MotionClass')


% plot speed with groundtruth of sitting and standing and speed
figure; plot (tout, csvTable.Label_Stand_Sit *10, '-.', tout, out.DU_speed_kmh); 
title('Groundtruth Standing n sitting, speed')
legend('Groundtruth Stand Sit', 'Speed')
%% get indicies of all phase-edges
% 
% xPhaseSt = find(csvTable.Label_DrWalk == -1, 1,'last');
% 
% xPhase1St = find(csvTable.Label_DrWalk == 0, 1,'first');
% xPhase2St = find(csvTable.Label_DrWalk == 2, 1,'first');
% 
% x1Start = find(csvTable.Label_DrWalk == 1, 1,'first');
% x1End = find(csvTable.Label_DrWalk == 1, 1,'last');
% 
% x2End = find(csvTable.Label_DrWalk == 2, 1,'last');

xPhaseDrWalk = [];
xPhase_StandSit = [];
for i=2:length(csvTable.Label_DrWalk)
    
   if  csvTable.Label_DrWalk(i) - csvTable.Label_DrWalk(i-1)~= csvTable.Label_DrWalk(i)-csvTable.Label_DrWalk(i)
       xPhaseDrWalk (end+1) = i; 
   end
   if  csvTable.Label_Stand_Sit(i) - csvTable.Label_Stand_Sit(i-1)~= csvTable.Label_Stand_Sit(i)-csvTable.Label_Stand_Sit(i)
       xPhase_StandSit (end+1) = i; 
   end
end

%% subplots for %% Auf Fußraste stehen %% - Ergebnisse
% time out of simulation
xt = tout;

figure;
sgtitle('Compare various driving positions')

subplot(4,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
plot (tout, csvTable.crashFire*50, '-.magenta') % crash fires
% phase edges
line([tout(xPhase_StandSit(1)) tout(xPhase_StandSit(1))], [-1000 1000], 'Color','red','LineStyle','-.' ) 
line([tout(xPhase_StandSit(2)) tout(xPhase_StandSit(2))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(3)) tout(xPhase_StandSit(3))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(4)) tout(xPhase_StandSit(4))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(5)) tout(xPhase_StandSit(5))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(6)) tout(xPhase_StandSit(6))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(7)) tout(xPhase_StandSit(7))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(8)) tout(xPhase_StandSit(8))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
legend('Speed', 'Crash fire')
hold off
ylabel('Speed [km/h]')
ylim([-10 60])
xlim([xt(36300) xt(end)])
title('Speed')
grid



subplot(4,1,2);
hold on
plot (xt, csvTable.Label_Stand_Sit)
% phase edges

line([tout(xPhase_StandSit(1)) tout(xPhase_StandSit(1))], [-1000 1000], 'Color','red','LineStyle','-.' ) 
line([tout(xPhase_StandSit(2)) tout(xPhase_StandSit(2))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(3)) tout(xPhase_StandSit(3))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(4)) tout(xPhase_StandSit(4))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(5)) tout(xPhase_StandSit(5))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(6)) tout(xPhase_StandSit(6))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(7)) tout(xPhase_StandSit(7))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(8)) tout(xPhase_StandSit(8))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
hold off
ylim([-2 2])
yticks([-1 0 1 2])
yticklabels({'Undefined', 'Sitting', 'Standing', ''})
xlim([xt(36300) xt(end)])
title('Ground truth of sitting/standing')
txt = 'Sitting'; text((xt(36300)+tout(xPhase_StandSit(2)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Standing'; text((tout(xPhase_StandSit(2))+tout(xPhase_StandSit(3)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Sitting'; text((tout(xPhase_StandSit(3))+tout(xPhase_StandSit(4)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
% txt = 'Walking'; text((tout(xPhaseDrWalk(4))+tout(xPhaseDrWalk(5)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Undefined'; text((tout(xPhase_StandSit(6))+tout(xPhase_StandSit(5)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Sitting'; text((tout(xPhase_StandSit(6))+tout(xPhase_StandSit(7)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Standing'; text((tout(xPhase_StandSit(7))+tout(xPhase_StandSit(8)))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Undefined'; text((tout(xPhase_StandSit(8))+tout(end))/2, 1.5, txt,'HorizontalAlignment','center','Color','#A2142F')
grid


subplot(4,1,3); 
hold on
plot (xt, csvTable.Label_DrWalk)
line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
hold off
ylim([-2 3])
yticks([-1 0 1 2 3])
yticklabels({'Undefined', 'No motion', 'Walking', 'Driving', ''})
xlim([xt(36300) xt(end)])
title('Ground truth of walking/driving')
txt = 'No Motion'; text((xt(36300)+tout(xPhaseDrWalk(2)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Driving'; text((tout(xPhaseDrWalk(2))+tout(xPhaseDrWalk(3)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
% txt = 'Walking'; text((tout(xPhase(3))+tout(xPhase(4)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Walking'; text((tout(xPhaseDrWalk(4))+tout(xPhaseDrWalk(5)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Driving'; text((tout(xPhaseDrWalk(6))+tout(xPhaseDrWalk(7)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Unknown'; text((tout(xPhaseDrWalk(7))+tout(end))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
grid


subplot(4,1,4); 
hold on
plot (tout, out.TO_curAngle)
% phase edges
line([tout(xPhase_StandSit(1)) tout(xPhase_StandSit(1))], [-1000 1000], 'Color','red','LineStyle','-.' ) 
line([tout(xPhase_StandSit(2)) tout(xPhase_StandSit(2))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(3)) tout(xPhase_StandSit(3))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(4)) tout(xPhase_StandSit(4))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(5)) tout(xPhase_StandSit(5))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(6)) tout(xPhase_StandSit(6))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(7)) tout(xPhase_StandSit(7))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
line([tout(xPhase_StandSit(8)) tout(xPhase_StandSit(8))], [-1000 1000], 'Color','red', 'LineStyle','-.') 
hold off
xlabel('time (Sec)')
ylabel('Angle [Degree]')
ylim([-120 35])
xlim([xt(36300) xt(end)])
title('Change of smartphone angle')
grid


%% subplots for Lauferkennung - Ergebnisse
% time out of simulation
xt = out.tout;

figure;
sgtitle('Compare differents motion detection methods')

subplot(4,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
% phase edges
line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% crash fires
% plot (tout, csvTable.crashFire*50, '-.g')
hold off
xticklabels('')
ylabel('Speed [km/h]')
ylim([-10 60])
xlim([xt(36300) xt(end)])
title('Speed')
grid



subplot(4,1,2);
hold on
plot (xt, csvTable.Label_DrWalk)
line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
hold off
ylim([-2 3])
yticks([-1 0 1 2 3])
yticklabels({'Undefined', 'No motion', 'Walking', 'Driving', ''})
xlim([xt(36300) xt(end)])
xticklabels('')
title('Ground truth of walking/driving')
txt = 'No Motion'; text((xt(36300)+tout(xPhaseDrWalk(2)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Driving'; text((tout(xPhaseDrWalk(2))+tout(xPhaseDrWalk(3)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
% txt = 'Walking'; text((tout(xPhase(3))+tout(xPhase(4)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Walking'; text((tout(xPhaseDrWalk(4))+tout(xPhaseDrWalk(5)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Driving'; text((tout(xPhaseDrWalk(6))+tout(xPhaseDrWalk(7)))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
txt = 'Unknown'; text((tout(xPhaseDrWalk(7))+tout(end))/2, 2.5, txt,'HorizontalAlignment','center','Color','#A2142F')
grid

subplot(4,1,3); 
hold on
plot (xt, out.MD_motionClass)
line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
hold off
ylim([-2 3])
yticks([-1 0 1 2 3])
yticklabels({'Undefined', 'No motion', 'Walking', 'Driving', ''})
xlim([xt(36300) xt(end)])
xticklabels('')
title('Activity detection using the new motion detection module')
grid


subplot(4,1,4); 
hold on
plot (xt, activityId)
line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
hold off
xlabel('time (Sec)')
ylim([-2 3])
yticks([-1 0 1 2 3])
yticklabels({'Undefined', 'No motion', 'Walking', 'Driving', ''})
xlim([xt(36300) xt(end)])
title('Activity detection using google integrated tool')
grid

%% Anhalten Speed - angle change

% time out of simulation
xt = tout;

figure;
sgtitle('Check speed with angle')

subplot(2,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
% phase edges
% line([tout(xPhaseDrWalk(1)) tout(xPhaseDrWalk(1))], [-10 60], 'Color','red','LineStyle','-.' ) % end of unknown phase
% line([tout(xPhaseDrWalk(2)) tout(xPhaseDrWalk(2))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhaseDrWalk(3)) tout(xPhaseDrWalk(3))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% % line([tout(xPhase(4)) tout(xPhase(4))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% % line([tout(xPhase(5)) tout(xPhase(5))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhaseDrWalk(6)) tout(xPhaseDrWalk(6))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% line([tout(xPhaseDrWalk(7)) tout(xPhaseDrWalk(7))], [-10 60], 'Color','red', 'LineStyle','-.') % end of unknown phase
% crash fires
% plot (tout, csvTable.crashFire*50, '-.g')
hold off
ylabel('Speed [km/h]')
ylim([-10 40])
xlim([xt(23000) xt(37000)])
title('Speed')
grid



subplot(2,1,2);
hold on
% plot (xt, out.TO_curAngle)
% plot (xt, out.rollAngle_deg, '-.')
plot (xt, out.pitchAngle_deg)
hold off
% legend('TO', 'roll', 'pitch')
xlabel('time (Sec)')
ylabel('Angle [Degree]')
ylim([-40 20])
xlim([xt(23000) xt(37000)])
title('Change of smartphone angle')
grid
%% extra plots 
% plot the maximum value of all activities on original timeStamp
figure; plot (csvTable.accCounter, tableActivityValue); title('tableActivityValue')

% plot the sum of all values of all activities on original timeStamp
figure; plot (csvTable.accCounter, tableActivitySum); title('tableActivitySum')


%% Plot GroundHit factors - FullView

% time out of simulation
xt = out.tout;

figure;
sgtitle('GroundHit energy and speed in a crash situation')

subplot(2,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
% plot (xt, out.rollAngle_deg) % roll angle
plot (xt, out.groundHitFire*70, '-.r');%, xt, csvTable.crashFire*70, '-.g') % GroundHit Fire
% legend('Speed', 'GH')
hold off
ylabel('Speed [km/h]')
xlabel('time (Sec)')
ylim([-5 80])
% xlim([xt(1) xt(40000)])
title('Speed')
grid

subplot(2,1,2);
hold on
plot (xt, out.accEnergySTXYintern)
plot (xt, out.GHScaleFactorXGHEnergyThreshold)
hold off
% legend('AccEnergy', 'Threshold')
xlabel('time (Sec)')
% ylabel('Angle [Degree]')
ylim([-0.1 1.1])
yticklabels({})
% xlim([xt(1) xt(40000)])
title('Actual energy and threshold of groundHit')
grid
%% Plot GroundHit factors - zoomed

% time out of simulation
xt = out.tout;

figure;
sgtitle('GroundHit energy and speed in a crash situation - zoomed view')

subplot(2,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
plot (xt, out.groundHitFire*70, '-.r');%, xt, csvTable.crashFire*70, '-.g') % GroundHit Fire
legend('Speed', 'GH-Fire')%, 'Crash-Fire in field')
hold off
% ylabel('Speed [km/h]')
xlabel('time (Sec)')
ylim([-5 80])
xlim([xt(59100) xt(59400)])
title('Speed - zoomed')
grid

subplot(2,1,2);
hold on
plot (xt, out.accEnergySTXYintern)
% plot (xt, out.rollAngle_deg, '-.')
plot (xt, out.GHScaleFactorXGHEnergyThreshold)
hold off
legend('Energy', 'Energy threshold')
xlabel('time (Sec)')
ylim([-0.01 0.13])
% yticks([-1 0 1 2 3])
yticklabels({})
xlim([xt(59100) xt(59400)])
title('energy of groundHit- zoomed')
grid



%% Plot CollisionHit factors - FullView

% time out of simulation
xt = out.tout;

figure;
sgtitle('CollisionHit energy and speed in a no-crash situation')

subplot(2,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
plot (xt, out.collisionFire*20, '-.r') % CollisionHit Fire
% legend('Speed', 'GH')
hold off
ylabel('Speed [km/h]')
xlabel('time (Sec)')
ylim([-5 35])
xlim([xt(23000) xt(end)])
title('Speed')
grid




subplot(2,1,2);
hold on
plot (xt, out.accEnergySTXYintern)
plot (xt, out.CHEnergyThreshold)
hold off
% legend('AccEnergy', 'Threshold')
xlabel('time (Sec)')
ylim([-0.1 0.55])
yticklabels({})
xlim([xt(23000) xt(end)])
title('Actual energy and threshold of collisionHit')
grid

%% Plot CollisionHit factors - zoomed

% time out of simulation
xt = out.tout;

figure;
sgtitle('CollisionHit energy and speed in a crash situation - zoomed view')

subplot(2,1,1);
hold on
plot (xt, out.DU_speed_kmh) % speed
plot (xt, out.collisionFire*20, '-.r') % CollisionHit Fire
legend('Speed', 'CH-Fire')
hold off
xlabel('time (Sec)')
ylim([-5 35])
xlim([xt(42000) xt(44500)])
title('Speed - zoomed')
grid


subplot(2,1,2);
hold on
plot (xt, out.accEnergySTXYintern)
plot (xt, out.CHEnergyThreshold)
hold off
legend('Energy', 'Energy threshold')
xlabel('time (Sec)')
ylim([-0.1 0.55])
yticklabels({})
xlim([xt(42000) xt(44500)])
title('energy of collisionHit- zoomed')
grid

%% Angle changing 90 grad

AngleTable = readtable('E:\Studium\02Master\6.SS22 - Masterarbeit\MasterArbeit\OutputData\20221216_1919_ChangeAngle90Grad.csv');
figure;
plot(AngleTable.time,AngleTable.gFy);
xlabel('time [Sec]')
ylabel('Angle [Degree]')
xticks(0:4:18)
xticklabels({'0','1', '2','3', '4'})
xlim([0 16])

yticks(-1:0.5:1)
yticklabels({'- 90','- 45', '0'})
ylim([-1.15 0.1])

title('changing an angle between vertical and horizontal positioning of the smartphone')


%% Plot sine wave of TestModellSpitzenzaehler
% load 'MasterArbeit\OutputData\out_TestModellSpitzenzaehler.mat' first
dataTemp1 = out_TestModellSputzenzaehler.yout{1}.Values;
dataTemp2 = out_TestModellSputzenzaehler.yout{2}.Values;
% t = out_TestModellSputzenzaehler.tout;
figure;
plot(dataTemp1.Time, dataTemp1.Data, dataTemp2.Time, dataTemp2.Data, '-.r')
legend('Sine wave','Zero crossing')
title('Sine wave and every zero crossing')
xlabel('Time [Sec]')
ylabel('Amplitude')
grid

%% Änderung an Figure von der WInkeländerung während des Anhaltens
% Figure erstmal öffnen
ylim([-40 35])

line([263.84 263.84], [-1000 1000], 'Color','red', 'LineStyle','-.')
line([277.6 277.6], [-1000 1000], 'Color','red', 'LineStyle','-.')
line([314.55 314.55], [-1000 1000], 'Color','red', 'LineStyle','-.')
line([322.8 322.8], [-1000 1000], 'Color','red', 'LineStyle','-.')
line([355.54 355.54], [-1000 1000], 'Color','red', 'LineStyle','-.')
line([349.5 349.5], [-1000 1000], 'Color','red', 'LineStyle','-.')



txt = 'Driving'; t0 = text(247, 25, txt,'HorizontalAlignment','center','Color','red'); %t0.Rotation = 90;
txt = 'Stopping'; t1 = text((277.6 + 263.84)/2, 10, txt,'HorizontalAlignment','center','Color','red'); t1.Rotation = 90;
txt = 'Driving'; t11 = text((277.6 + 314.55)/2, 25, txt,'HorizontalAlignment','center','Color','red'); %t11.Rotation = 90;
txt = 'Stopping'; t2 = text((322.8 + 314.55)/2, 10, txt,'HorizontalAlignment','center','Color','red'); t2.Rotation = 90;
txt = 'Driving'; t21 = text((322.8 + 349.5)/2, 25, txt,'HorizontalAlignment','center','Color','red'); %t21.Rotation = 90;
txt = 'Stopping'; t3 = text((355.54 + 349.5)/2, 10, txt,'HorizontalAlignment','center','Color','red'); t3.Rotation = 90;
txt = 'Driving'; t31 = text(363.5, 25, txt,'HorizontalAlignment','center','Color','red'); %t31.Rotation = 90;


%% Excel figures erstellen


StatistikUnfallgegnerTabelle = readtable('E:\Studium\02Master\6.SS22 - Masterarbeit\MasterArbeit\Quellen\Unfall_Statistik_Unfallgegner.xlsx');
StatistikAktivPassivUnfallTabelle = readtable('E:\Studium\02Master\6.SS22 - Masterarbeit\MasterArbeit\Quellen\Unfall_Statistik_AktivPassivUnfall.xlsx');
StatistikUrsacheAnzahlTabelle = readtable('E:\Studium\02Master\6.SS22 - Masterarbeit\MasterArbeit\Quellen\Unfall_Statistik_UrsacheAnzahl.xlsx');
StatistikALLDataTabelle =  readtable('E:\Studium\02Master\6.SS22 - Masterarbeit\MasterArbeit\Quellen\Unfall_Statistik_Tabelle1.xlsx');
% plot AktivPassivUnfall als Kreisgrafik
pielabels = {'Aktiver Unfall', 'Passiver Unfall'};
pie(StatistikAktivPassivUnfallTabelle.AnzahlAktiverUnfall ,pielabels);
colormap([0 0 1;      %// blue
          1 0 0]);      %// red

% plot Unfallgegner
c = categorical(StatistikALLDataTabelle.ID_Unfallsart,[1 2 3 4 5],{'Alleinig','Mit Auto','Mit Gegenstand', 'Mit Motorrad', 'Insgesamt'});

histDiagramm = histogram(StatistikALLDataTabelle.ID_Unfallsart);
% histDiagramm.BinWidth = 0.5;
histDiagramm.FaceColor = 'blue';


%% Sine Wave generator

fs = 2048; % Sampling frequency (samples per second)
dt = 1/fs; % seconds per sample
StopTime = 1; % seconds
t = (0:dt:StopTime)'; % seconds
F1 = 23.8; % Sine wave frequency (hertz)
data23 = 200*sin(2*pi*F1*t);

F2 = 1.1; % Sine wave frequency (hertz)
data11 = 200*sin(2*pi*F2*t);

F3 = 47.8; % Sine wave frequency (hertz)
data47 = 200*sin(2*pi*F3*t);

dataAll = data23 + data11 + data47;

figure;
% sgtitle('')
subplot(4,1,1);
hold on
plot(t,data11)
xticks(0:0.2:1)
xticklabels('')
yticks([-200 -100 0 100 200])
yticklabels({'-200', '', '0', '', '200'})
% ylabel('Amplitude')
ylim([-210 210])
% xlim([xt(36300) xt(end)])
title('signal 1, f = 1.1 Hz')
grid

subplot(4,1,2);
hold on
plot(t,data23)
xticks(0:0.2:1)
xticklabels('')
yticks([-200 -100 0 100 200])
yticklabels({'-200', '', '0', '', '200'})
% ylabel('Amplitude')
ylim([-210 210])
% xlim([xt(36300) xt(end)])
title('signal 2, f = 23.8 Hz')
grid

subplot(4,1,3); 
hold on
plot(t,data47)
xticks(0:0.2:1)
xticklabels('')
yticks([-200 -100 0 100 200])
yticklabels({'-200', '', '0', '', '200'})
% ylabel('Amplitude')
ylim([-210 210])
% xlim([xt(36300) xt(end)])
title('signal 3, f = 47.8 Hz')
grid

subplot(4,1,4); 
hold on
plot(t,dataAll)
xticks(0:0.2:1)
% xticklabels('')
ylim([-620 550])
yticks([-500 -250 0 250 500])
yticklabels({'-500', '', '0', '', '500'})
% ylabel('Amplitude')
% xlim([xt(36300) xt(end)])
title('signal sum (total)')
grid
xlabel('time [Sec]')


%
figure;
% sgtitle('')
subplot(2,1,1);
hold on
plot(t,data11 + 1000, '-.')
plot(t,data23 + 400, '--r')
plot(t,data47 - 200, 'g')
hold off
xticks(0:0.2:1)
xticklabels('')
ylim([-450 1250])
yticks(-400:200:1200)
yticklabels({'-200', '', '+200','-200', '', '+200','-200', '', '+200'})
ylabel('Amplitude')
title('original signals')
legend({'f = $1.1$ Hz','f = $23.8$ Hz','f = $47.8$ Hz'}, 'FontSize',12,'Interpreter','latex')
grid

subplot(2,1,2); 
hold on
plot(t,dataAll)
xticks(0:0.2:1)
ylim([-620 550])
yticks([-500 -250 0 250 500])
yticklabels({'-500', '', '0', '', '500'})
ylabel('Amplitude')
title('signal sum (total)')
grid
xlabel('time [Sec]')



