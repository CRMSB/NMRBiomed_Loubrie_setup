function [fitresult, gof] = Fit_MSME(x, y, paramStructure)
% inputs:
% x: Echo times
% y: Signal intensities
% paramStructure: Bruker acquisition parameters
% outputs:
% fitresult: Fitting parameters estimated values
% gof: Fitting procedure accuracy (R2, 95% intervals...)

% Preparing data
[xData, yData] = prepareCurveData( x, y );

% Number of receiving coils
Nc=num2str(paramStructure.PVM_EncNReceivers);

% Distribution adjustement coefficient depending on the number of receiving
% coils (Henkelman et al. 1985)
if Nc=='1'
    C=num2str(0.695);
else if Nc=='4'
        C=num2str(0.655);
    end
end

% Set up fittype and options.
% Noise correction equation (Raya et al. 2010)
ft = fittype(strcat('sqrt(abs((M0*exp(-x/T2))^2+2*',Nc,'*(sigma/',C,')^2))'), 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.MaxIter = 1000;

% Fitting parameters starting values
M0Start=yData(1,:);
T2Start=30;
sigmaStart=paramStructure.stdbruit;
opts.StartPoint = [M0Start T2Start sigmaStart];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



