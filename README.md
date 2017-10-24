# writeHyperSpyH5
A function for Matlab to write HyperSpy formatted HDF5 files

# Example usage
Write some example data to `data`, plot it in Matlab and then write it to a HyperSpy format hdf5 file. Here there are two navigation dimensions (x, y) and one signal dimension. This is specified by the `navDim` argument. `scale` and `offset` are for the scaling of each dimension. X and Y will go from 0-30 (scale = 1 and offset = 0), but the signal dimension will go from 10 to 30: (0-100)*0.2 + 10.
```
% Matlab 2 HyperSpy example

data = zeros(30,30,100);
xx = 1:size(data,3);
for i = 1:size(data,1)
    for j = 1:size(data,2)
        data(i,j,:) = sin(i/5)+cos(j/2)+0.2.*sin(xx/20);
    end
end
% visualise data
[X,Y,Z] = meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));
scatter3(X(:),Y(:),Z(:),1,data(:),'.');

% write to HyperSpy formatted HDF5 (H5) file
writeHyperSpyH5('hs_test.hdf5',data,[1 1 0.2],[true true false],[0 0 10]);
```
# Details: Args
## data
The data you wish to write to file.
## scale
Array with as many dimensions as the data with the scaling value for this axis.
## navDim
A logical array which has true if that dimension is a navigation dimension
## Offset 
The numeric offset of this dimension scale.
