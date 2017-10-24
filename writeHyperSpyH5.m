function writeHyperSpyH5(fileName,data,scale,navDim,offset)
%writeHyperSpyH5(fileName,data,scale,navDim,offset)
% matlab2hyperSpy hdf5 file writer
% data = the data you wish to write to file.
% scale = array with as many dimensions as the data with the scaling value
% for this axis.
% navDim = a logical array which has true if that dimension is a navigation dimension
% offset = the numeric offset of this dimension scale.
%
% A. London 2017
%
% matlab to hyperspy hdf5
%
% Alternative "template" method, using an existing file you have made using HyperSpy:
%
%# in Python
%import hyperspy.api as hs
%import numpy as np
%# make an array with the same size as your data
%a = np.zeros((55, 53, 474 , 1238),dtype="uint8")
%# get the signal dimension(s)
%a = hs.signals.Signal1D(a)
%# check the data type
%a.data.dtype
%# save the file to use as a template
%a.save("template.hdf5")
%
% In Matlab
% Write data into f="template.hdf5" using Matlab:
% use a hs generated file...
% "transpose data"
% s_size = size(s);  %55,53,474,1238 to match above
% s2 = zeros(fliplr(size(s)));
% for i = 1:numel(s)
%     [a,b,c,d] = ind2sub(s_size,i);
%     s2(d,c,b,a) = s(i);
% end
% f = 'testArray.hdf5';
% h5write(f,'/Experiments/__unnamed__/data',s);

dims = size(data);
chunkSize = floor(dims./8)+1;



fid = H5F.create(fileName);
plist = 'H5P_DEFAULT';
gid_exp = H5G.create(fid,'Experiments',plist,plist,plist);
gid_name = H5G.create(gid_exp,'__unnamed__',plist,plist,plist);
% create axis groups
for dim = 1:(length(dims))
    axName = strcat('axis-', num2str(dim-1));
    gid = H5G.create(gid_name,axName,plist,plist,plist);
    H5G.close(gid);
end
H5G.close(gid_exp);
H5G.close(gid_name);
H5F.close(fid);
% HDF5 testArray4.hdf5 
% Group '/' 
%     Attributes:
%         'file_format':  'HyperSpy'
h5writeatt(fileName,'/','file_format','HyperSpy');
%         'file_format_version':  '2.1'
h5writeatt(fileName,'/','file_format_version','2.1');
%     Group '/Experiments' 
%         Group '/Experiments/__unnamed__' 
%             Dataset 'data' 
%                 Size:  722x87x26x26
%                 MaxSize:  722x87x26x26
%                 Datatype:   H5T_IEEE_F64LE (double)
%                 ChunkSize:  91x11x4x4
%                 Filters:  deflate(4)



% write data
h5create(fileName,'/Experiments/__unnamed__/data',dims,'Deflate',4,'ChunkSize',chunkSize);
h5write(fileName,'/Experiments/__unnamed__/data',data);

for dim = 1:(length(dims))
    %dim = length(dims)-dim1+1; % reverse order for hyperspy
    %             Group '/Experiments/__unnamed__/axis-0'
    %                 Attributes:
    %                     'scale':  1.000000
    %                     'navigate':  TRUE
    %                     'offset':  0.000000
    %                     'size':  26
    axName = strcat('/Experiments/__unnamed__/axis-', num2str(length(dims)-dim),'/');
    
    % write att manually % h5writeatt(fileName, axName, 'scale', scale(dim));
    fileId = H5F.open(fileName,'H5F_ACC_RDWR','H5P_DEFAULT'); % open file
    objId  = H5O.open(fileId,axName,'H5P_DEFAULT'); % open object
    attrId = H5A.create(objId,'scale',H5T.copy('H5T_NATIVE_DOUBLE'),H5S.create('H5S_SCALAR'),H5P.create('H5P_ATTRIBUTE_CREATE'));
    H5A.write(attrId,H5T.copy('H5T_NATIVE_DOUBLE'),scale(dim));
    H5A.close(attrId);
    
    %h5writeatt(fileName, axName, 'offset', offset(dim));
    attrId = H5A.create(objId,'offset',H5T.copy('H5T_NATIVE_DOUBLE'),H5S.create('H5S_SCALAR'),H5P.create('H5P_ATTRIBUTE_CREATE'));
    H5A.write(attrId,H5T.copy('H5T_NATIVE_DOUBLE'),offset(dim));
    H5A.close(attrId);
    H5O.close(objId);
    
    % naviation dimensions
    if navDim(dim)
        h5writeEnumBoolAtt(fileName, axName, 'navigate', true);
    else
        h5writeEnumBoolAtt(fileName, axName, 'navigate', false);
    end
    
    % size
    h5writeatt(fileName, axName, 'size', dims(dim));
    
    % close file for now
    H5F.close(fileId);
end

fid = H5F.open(fileName,'H5F_ACC_RDWR','H5P_DEFAULT');
plist = 'H5P_DEFAULT';
gid = H5G.open(fid,'/Experiments/__unnamed__');
gid1 = H5G.create(gid,'learning_results',plist,plist,plist);
H5G.close(gid1);
gid1 = H5G.create(gid,'metadata',plist,plist,plist);
gid0 = H5G.create(gid,'original_metadata',plist,plist,plist);
gid2 = H5G.create(gid1,'General',plist,plist,plist);
gid3 = H5G.create(gid1,'Signal',plist,plist,plist);
gid4 = H5G.create(gid1,'_HyperSpy',plist,plist,plist);
gid5 = H5G.create(gid4,'Folding',plist,plist,plist);
H5G.close(gid0);
H5G.close(gid1);
H5G.close(gid2);
H5G.close(gid3);
H5G.close(gid4);
H5G.close(gid5);
H5F.close(fid);

%             Group '/Experiments/__unnamed__/learning_results' 
%             Group '/Experiments/__unnamed__/metadata' 
%                 Group '/Experiments/__unnamed__/metadata/General' 
%                     Attributes:
%                         'title':  ''
% TODO: Change title to argin
h5writeatt(fileName, '/Experiments/__unnamed__/metadata/General', 'title', 'Title');
h5writeatt(fileName, '/Experiments/__unnamed__/metadata/General', 'ProducedBy', 'MATLAB');
%                 Group '/Experiments/__unnamed__/metadata/Signal' 
%                     Attributes:
%                         'signal_type':  ''
%                         'record_by':  'spectrum'
%                         'binned':  FALSE
h5writeatt(fileName, '/Experiments/__unnamed__/metadata/Signal', 'signal_type', 'Custom');
h5writeatt(fileName, '/Experiments/__unnamed__/metadata/Signal', 'record_by', 'spectrum');
%h5writeatt(fileName, '/Experiments/__unnamed__/metadata/Signal', 'binned', 'FALSE');
h5writeEnumBoolAtt(fileName, '/Experiments/__unnamed__/metadata/Signal', 'binned', false);
%                 Group '/Experiments/__unnamed__/metadata/_HyperSpy' 
%                     Group '/Experiments/__unnamed__/metadata/_HyperSpy/Folding' 
%                         Attributes:
%                             'signal_unfolded':  FALSE
%                             'unfolded':  FALSE
%                             'original_shape':  '_None_'
%                             'original_axes_manager':  '_None_'

h5writeatt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'original_shape', '_None_');
h5writeatt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'original_axes_manager', '_None_');

% h5writeatt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'signal_unfolded', 'TRUE');
% h5writeatt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'unfolded', 'TRUE');
h5writeEnumBoolAtt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'signal_unfolded', false);
h5writeEnumBoolAtt(fileName, '/Experiments/__unnamed__/metadata/_HyperSpy/Folding', 'unfolded', false);

%             Group '/Experiments/__unnamed__/original_metadata' 
