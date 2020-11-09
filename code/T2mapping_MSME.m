function [ T2map, r2map ] = T2mapping_MSME( im, paramStructure )
% inputs:
% im: images as a 4D matrix (FOVx, FOVy, Nechoes, Nslices)
% paramStructure: Bruker acquisition parameters
% outputs:
% T2map and R2maps (fitting procedure accuracy, not relaxivity)

warning off

% Noise standard deviation estimation
roibruit=im(1:20,1:20,end,end);
stdbruit=std(double(roibruit(:)));
paramStructure.stdbruit=stdbruit;

% Mask calculation to focus on pixels of interest. Thresold can be modified
% for more or less selectiveness
moy=mean(im(:,:,1:3,:),3);
mask_im=moy;
threshold=2*mean(moy(:));
mask_im(mask_im<=threshold)=0;
mask_im(mask_im>=threshold)=1;
mask=mask_im(:);

%Taking off the first echo and data modification in a 2D matrix (FOVx x FOVy x Nslices, Nechoes-1)
Npoints=size(im,4);
data=reshape(im(:,:,2:Npoints,:),[],Npoints-1); 
x=paramStructure.EffectiveTE(2:Npoints+1);

T2map=zeros(length(data),1);
r2map=zeros(length(data),1);

% Fitting procedure for each line of the matrix belonging to the mask
for i=1:length(data)
    if mask(i)==1
        y=data(i,:);
        try
            [fitresult, gof] = Fit_MSME(x, y, paramStructure, 0);
            T2map(i)=fitresult.T2;
            r2map(i)=gof.rsquare;
        catch
            T2map(i)=0;
            r2map(i)=0;
        end
    end
end

T2map=reshape(T2map,size(im,1),size(im,2),size(im,4));
r2map=reshape(r2map,size(im,1),size(im,2),size(im,4));

