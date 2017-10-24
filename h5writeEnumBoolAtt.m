function h5writeEnumBoolAtt(fileName, groupName, ATTRIBUTE, value)
%h5writeEnumAtt(fileName, groupName, ATTRIBUTE, value)
% fileName = the hdf5 file name
% groupName = the group within the file to write the attribute to
% ATTRIBUTE = the name of the attribute (string), e.g. 'navigate'
% value = true or false to write 

    % write att manually % h5writeatt(fileName, axName, 'scale', scale(dim));
    fileId = H5F.open(fileName,'H5F_ACC_RDWR','H5P_DEFAULT'); % open file
    objId  = H5O.open(fileId,groupName,'H5P_DEFAULT'); % open object
    
    % ENUM data type
    type_id = H5T.enum_create ('H5T_STD_I8LE');
    memtype  = H5T.enum_create ('H5T_STD_I8LE');
    %parent_id = H5T.copy('H5T_NATIVE_UINT');
    %type_id = H5T.enum_create(parent_id);
    H5T.enum_insert(type_id,'FALSE',0);
    H5T.enum_insert(type_id,'TRUE',1);
    H5T.enum_insert(memtype,'FALSE',0);
    H5T.enum_insert(memtype,'TRUE',1);

    %H5T.close(parent_id);
    %H5Tinsert (memtype, "FLAG", HOFFSET (pointing_t, FLAG),  type_id);
    
    %space = H5S.create ('H5S_SCALAR');
    %dset = H5D.create (file, DATASET, 'H5T_STD_I8LE', space, 'H5P_DEFAULT');
    %H5S.close (space);
    %space = H5S.create_simple (2,fliplr( dims), []);
    space = H5S.create ('H5S_SCALAR');
    if value
        %h5writeatt(fileName, axName, 'navigate', 'TRUE');
        attr = H5A.create (objId, ATTRIBUTE, type_id, space, 'H5P_DEFAULT');
        H5A.write (attr, memtype, int8(1));
    else
        %h5writeatt(fileName, axName, 'navigate', 'FALSE');
        attr = H5A.create (objId, ATTRIBUTE, type_id, space, 'H5P_DEFAULT');
        H5A.write (attr, memtype, int8(0));
    end
    
    % clean up
    H5T.close(type_id);
    H5T.close(memtype);
    H5A.close(attr);
    H5O.close(objId);
    H5F.close(fileId);
end
