# writeHyperSpyH5
A function for Matlab to write HyperSpy formatted HDF5 files

# Installation
Simply add the writeHyperSpyH5.m and h5writeEnumBoolAtt.m files to the Matlab path, and then use the example below to test it.

# Example usage
Write some example data to `data`, plot it in Matlab and then write it to a HyperSpy format hdf5 file. Here there are two navigation dimensions (x, y) and one signal dimension. This is specified by the `navDim` argument. `scale` and `offset` are for the scaling of each dimension. X and Y will go from 0-30 (scale = 1 and offset = 0), but the signal dimension will go from 10 to 30: (0-100)*0.2 + 10.

The plot (from scatter3) in Matlab looks like this:
![image](https://user-images.githubusercontent.com/23404786/31942039-e4df8f80-b8bb-11e7-9acd-2ce3a5f7dd0c.png)
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

To load the file into HyperSpy:
```
import hyperspy.api as hs
%matplotlib qt4
s = hs.load("hs_test.hdf5")
# check the contents of s
s
#<Signal1D, title: Title, dimensions: (30, 30|100)>
s.plot()
```

Your HyperSpy plot should look like this with a navigator and signal plot windows:
![image](https://user-images.githubusercontent.com/23404786/31942169-5c89404e-b8bc-11e7-8a43-e665860fb15f.png)

# Details: Args
## data
The data you wish to write to file.
## scale
Array with as many dimensions as the data with the scaling value for this axis.
## navDim
A logical array which has true if that dimension is a navigation dimension
## Offset 
The numeric offset of this dimension scale.

# Issues
TODO: Could probably add options to name the axes and add units.
TODO: Test with the latest version of HyperSpy (1.3)
TODO: Needs more robustness built in (check file can be opened etc.)
