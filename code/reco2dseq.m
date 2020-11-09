function [im,rawData]=reco2dseq(paramStructure)

if nargin < 1
    [paramStructure]=readParams_Bruker();
end

%Read file
fid=fopen([paramStructure.dirPath '/pdata/1/2dseq'],'r','b');
rawData=fread(fid,'int16=>int16','l');
fclose(fid);

if paramStructure.ACQ_dim==2
    im=reshape(rawData,paramStructure.PVM_Matrix(1),paramStructure.PVM_Matrix(2), paramStructure.PVM_NEchoImages);
end
if paramStructure.ACQ_dim==3
    im=reshape(rawData,paramStructure.PVM_Matrix(1),paramStructure.PVM_Matrix(2), paramStructure.PVM_NEchoImages, paramStructure.PVM_Matrix(3));
end
end