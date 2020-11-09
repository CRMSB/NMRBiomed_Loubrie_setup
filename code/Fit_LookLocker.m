function [fitresult, gof] = Fit_LookLocker(x, y, paramStructure)
% inputs:
% x: Echo times
% y: Signal intensities
% paramStructure: Bruker acquisition parameters
% outputs:
% fitresult: Fitting parameters estimated values
% gof: Fitting procedure accuracy (R2, 95% intervals...)

% Preparing data
[xData, yData] = prepareCurveData( x, y );

Trr=num2str(paramStructure.RRDelay);%Delay between two LL points
alpha=num2str(2*pi*paramStructure.ACQ_flip_angle/360); % Flip angle conversion en radians 

% Set up fittype and options.
% LL fitting equation (Castets et al. 2015)
ft = fittype( strcat('abs(((1-exp(-',Trr,'/T1))/(1-(cos(',alpha,')^2)*exp(-',Trr,'/T1))-(mmax+(1-exp(-',Trr,'/T1))/(1-(cos(',alpha,')^2)*exp(-',Trr,'/T1)))*((cos(',alpha,')^2)*exp(-',Trr,'/T1)).^(x)).*A)'), 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.MaxIter = 1000;

% Fitting parameters starting values
AStart=yData(1,:);
T1Start=1000;
mmaxStart=paramStructure.stdbruit;
opts.StartPoint = [AStart T1Start mmaxStart];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


