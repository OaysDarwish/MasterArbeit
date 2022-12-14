function createfigure(X1, Y1, Y2, XData1, YData1)
%CREATEFIGURE(X1, Y1, Y2, XData1, YData1)
%  X1:  vector of x data
%  Y1:  vector of y data
%  Y2:  vector of y data
%  XDATA1:  line xdata
%  YDATA1:  line ydata

%  Auto-generated by MATLAB on 26-Nov-2022 19:32:03

% Create figure
figure1 = figure('WindowState','maximized');

% Create sgtitle
sgtitle(figure1,'Check speed with angle');

% Create subplot
subplot1 = subplot(2,1,1);
hold(subplot1,'on');

% Create plot
plot(X1,Y1);

% Create ylabel
ylabel('Speed [km/h]');

% Create title
title('Speed');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot1,[229.99 369.99]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot1,[-10 40]);
grid(subplot1,'on');
hold(subplot1,'off');
% Create subplot
subplot2 = subplot(2,1,2);
hold(subplot2,'on');

% Create plot
plot(X1,Y2);

% Create line
line(XData1,YData1,'Parent',subplot2,'LineStyle','-.','Color',[1 0 0]);

% Create ylabel
ylabel('Angle [Degree]');

% Create xlabel
xlabel('time (Sec)');

% Create title
title('Change of smartphone angle');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot2,[229.99 369.99]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot2,[-40 20]);
grid(subplot2,'on');
hold(subplot2,'off');
