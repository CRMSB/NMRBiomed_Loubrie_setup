function [imOut]=sl_radialT1_2D(paramStructure)
%input : Bruker acquisition paramstructure
%output : 4D image (FOVx, FOVy, Nechoes, Nsclices)

if nargin < 1
    [paramStructure]=readParams_Bruker();
end

RADIAL = 0;
NSLICES = paramStructure.NSLICES;

%% Variables
RPOffset = 0;
Nc = paramStructure.PVM_EncNReceivers;

if isfield(paramStructure,'ACQ_nr_completed')
    NR = paramStructure.ACQ_nr_completed;
    if NR<1
        NR = 1;
    end
else
    NR = paramStructure.NR;
end

NEchos = paramStructure.PVM_NEchoImages;

%% Rawdata reading
rawDataTemp=readFIDMc(paramStructure.ACQ_size(1)/2,Nc,[paramStructure.dirPath '/fid']);
for i=1:Nc
    rawData(:,:,i) = rawDataTemp{i};
end
tmpSizeRaw = size(rawData,1);

%% Rawdata reshaping
rawData=reshape(rawData,paramStructure.ACQ_size(1)/2,paramStructure.NRegroup,NEchos,[],Nc);

%% Trajectories
fid=fopen([paramStructure.dirPath '/traj'],'r');
Trajdata=fread(fid,'double','l');
fclose(fid);

Trajdata = reshape(Trajdata,2,paramStructure.ACQ_size(1)/2,paramStructure.NRegroup,[]);

% Trajectory reshaping on two lines (x,y)
traj = reshape(Trajdata,2,[]);

% Adding zeros on 3rd dimension (x,y,z)
GreTraj=[traj;zeros(1,size(traj,2))];

%% Reconstruction
%Trajectory weighting
wg = 2;
sw = 4;

numIter = 10;
effMtx  =[paramStructure.PVM_EncMatrix(1), paramStructure.PVM_EncMatrix(2) ,1];
osf     = 2;
verbose = 1;

w = sdc3_MAT(GreTraj,numIter,effMtx,verbose,osf);
w = double(w);

%% GPU NuFFT

FT = gpuNUFFT(GreTraj(1:2,:),w.^2,osf,wg,sw,effMtx(1:2),[],true);

for Gre = 1:NEchos
    for Channel = 1:Nc
        rawTmp=rawData(:,:,Gre,:,Channel);        
        imOutC(:,:,:,Gre,Channel)=FT'*squeeze(rawTmp(:));
    end
end
imOut=sqrt(sum(abs(double(imOutC)).^2,5));
imOutPhase=sqrt(sum(angle(double(imOutC)).^2,5));
varargout{1} = paramStructure;
