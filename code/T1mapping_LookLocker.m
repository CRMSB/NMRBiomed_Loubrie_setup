function [ T1map, r2map ] = T1mapping_LookLocker( im, paramStructure )
% inputs:
% im: images as a 4D matrix (FOVx, FOVy, Nslices, Nechoes)
% paramStructure: Bruker acquisition parameters
% outputs:
% T1map and R2map (fitting procedure accuracy, not relaxivity)

warning off

% Mask calculation to focus on pixels of interest. Thresold can be modified
% for more or less selectiveness
moy=mean(im(:,:,:,[end-3:end]),4);
mask_im=moy;
seuil=2.5*mean(moy(:));
mask_im(mask_im<=seuil)=0;
mask_im(mask_im>=seuil)=1;
mask=mask_im(:);

% data modification in a 2D matrix (FOVx x FOVy x Nslices, Nechoes-1)
data=reshape(im,[],size(im,4));
x=[1:size(im,4)]';

T1map=zeros(length(data),1);
r2map=zeros(length(data),1);

for i=1:length(data)
    if mask(i)==1
        y=data(i,:);
        try
            [fitresult, gof] = Fit_LookLocker(x, y, paramStructure, 0);
            T1map(i)=fitresult.T1;
            r2map(i)=gof.rsquare;
        catch
            T1map(i)=0;
            r2map(i)=0;
        end
    end
end

T1map=reshape(T1map,size(im,1),size(im,2),size(im,3));
r2map=reshape(r2map,size(im,1),size(im,2),size(im,3));

