% READDBT Reads a DBITE file
%   data = readdbt(file, recordspec) reads the input file and
%   returns each record in a structure array according to the
%   specification string recordspec.
%
%   data = readdbt(file, recordspec, alignment) can be used to specify
%   a data alignment different from the default (8).
%
%   All numerical data fields are converted to double representation.
%
%   The recordspec string describes the data record. It is
%   a whitespace-delimited list of field specifications, where each
%   specification is of the following form:
%
%      recordspec :== fieldspec | fieldspec recordspec
%      fieldspec :== fieldname%typespec[*count]
%      typespec :== simple-type | (recordspec)
%    
%
%  FIELDNAME
%
%   The fieldname can be any acceptable MATLAB identifier or be left
%   empty.
%   In the latter case, a default name of the form fieldN will be used,
%   where N is the 1-based field number.
%
%
%  TYPE SPECIFICATIONS
%
%   Field type (typespec) can be either a simple builtin type or a sub
%   record specification.
%   In the former case, the output record field will be a scalar.
%   In the latter case, the output record field will be a structure 
%   conforming to the subrecord specification. Such definitions can be 
%   nested.
%
%   The following table describes the supported builtin scalar types:
%
%      %c      - A single signed 8-bit character
%
%      %i      - A signed 32-bit integer
%      %i8     - A signed 8-bit integer
%      %i16    - A signed 16-bit integer
%      %i32    - A signed 32-bit integer (same as 'i')
%      %i64    - A signed 64-bit integer
%
%      %u      - An unsigned 32-bit integer
%      %u8     - An unsigned 8-bit integer
%      %u16    - An unsigned 16-bit integer
%      %u32    - An unsigned 32-bit integer (same as 'u')
%      %u64    - An unsigned 64-bit integer
%
%      %f      - A 64-bit IEEE754 floating-point number (double)
%      %f32    - A 32-bit IEEE754 floating-point number (single)
%      %f64    - A 64-bit IEEE754 floating-point number (same as 'f')
%      %n      - A 64-bit IEEE754 floating-point number (same as 'f')
%       
%      %string - A zero-terminated character string.
%
%
%  REPETITION COUNT
%
%   An optional repetition count can be appended to any type specification
%   to read more than one value. In the specific case of the %string type,
%   the count indicates the maximum size of the string to read. 
%   If the string is shorter, the remaining bytes are skipped.
%
%
%  SKIPPING BYTES
%
%   The type specification %skip can be used to skip a byte in the
%   record. Its value is discarded. A count can be used to skip multiple
%   bytes.
%   This is useful to correct aligment issues (mainly at the end of 
%   records, where padding can be added by compilers).
%
%
%  OUTPUT VALUES
%
%  The output data is a MATLAB structure containting one member vector
%  for each field of the recordspec string, plus two fixed fields which are:
%  - t for the times (times are in seconds since 00:00:00 UTC,
%    January 1, 1970)
%  - tr for the timeranges (timeranges in seconds).
%
%
%  EXAMPLES
%
%    The following call reads a DBITE file whose records contain three
%    fields: a signed 64-bit integer and two double floating-point numbers.
%    data = readdbt('myfile.dbt', 'time_utc%d64 x%f y%f')
%
%    The output will be a data structure with 5 member line vectors of the
%    same length:
%    - data.t
%    - data.tr
%    - data.time_utc
%    - data.x
%    - data.y
%
%
%    The following call reads a DBITE file whose records contain an
%    integer 'obstacle_count', an array 'positions' of 10 identical 
%    structures and and array 'quality' of 10 unsigned 8-bit integers.
%
%    data = readdbt('myfile.dbt', 'obstacle_count%i positions%(x%f y%f)*10
%              quality%u8*10')
%
%    The output will be a data structure with 5 members organized as
%    follows (n is the total numer of records in the file):
%
%    - data.t               - 1 x n double
%    - data.tr              - 1 x n double
%    - data.obstacle_count  - 1 x n double
%    - data.positions       - 10 x n structure with the following members:
%        - data.positions(i, j).x    - 1 x 1 double
%        - data.positions(i, j).y    - 1 x 1 double
%    - data.quality         - 10 x n double
%
%    The following call reads a DBITE file whose records are zero-delimited
%    strings.
%
%    data = readdbt('myfile.dbt', 'filename%string')
%
%    The output will be a structure with three members. The 'filename' 
%    member will be a cell array of strings.
%
%    - data.t               - 1 x n double
%    - data.tr              - 1 x n double
%    - data.filename        - 1 x n cells of strings
%
%    This form is meaningful only if the strings in the record are fixed
%    size or if the field is the last. In that case, remaining bytes will
%    be skipped to reach the start of the next record.
%
%    data = readdbt('myfile.dbt', 'filename%string*12') will limit the
%    string length to twelve bytes.
%
%
%  NOTES
%
%  recordspec can contain less fields that an actual record in the file.
%  In that case, the data is read from the start of the record, filling
%  each defined field. The remainder of the record is skipped.
%  If recordspec contains more fields that an actual record, an error
%  is reported and the file import is aborted.
%
%  If the file header is damaged or incorrect, the record size will be
%  deduced from the recordspec string and the file will be read till
%  the end of file.
%
%  (c) 2013 S. Bonnet / HeuDiaSyC
function data = readdbt(file, recordspec, varargin)

%% Check for optional arguments
if (nargin == 3)
    align = varargin{1};
else
    % Default aligment is 8
    align = 8;
end

%% Parse the field description
try
    fields = parsefieldspec(recordspec, 1, numel(recordspec));
catch ex
    rethrow(ex);
end

%% Open the file for reading. Bailout on error
fid = fopen(file, 'r');
if fid == -1
    error(['Unable to open file '  file  ' for reading']);
end

%% Get the magic number (signature). Bailout on error
s = fread(fid, 4, '*char')';
if ~strcmp(s, 'ROAD')
    fclose(fid);
    error(['"' file '" does not seem to be a valid DBITE file.']);
end

%% Get the header
datatype = fread(fid, 1, '*uint32');
version = fread(fid, 1, '*uint32');
dataoffset = fread(fid, 1, '*uint32');
recordsize = fread(fid, 1, '*uint32');
filesize = fread(fid, 1, '*uint32');
timebounds = fread(fid, 2, '*uint64');
nbrecords = fread(fid, 1, '*uint32');

disp([file ' is a DBITE version ' num2str(version) ' file.']);
if (nbrecords ~= 0)
    disp(['Reading ' num2str(nbrecords) ' records of type ' num2str(datatype) '.']);
else
    disp('Record count is 0. This usually means the header is incorrect. I will try to read the data anyway.');
end

%% Check for header sanity
if (recordsize ~= 0) 
    disp(['Record size is ' num2str(recordsize) ' bytes.']);
else
    disp('The record size will be computed from the record specification string (WARNING - THE OUTPUT DATA MAY BE INCORRECT)');
end

if dataoffset == 0
    dataoffset = 44;
    disp('Incorrect data offset in header. Defaulting to 44 bytes.');
end

% If freeread is true, reading will occur until the end of file is reached
% regardless of the expected number of records 
if recordsize == 0 || nbrecords == 0
    freeread = true;
else
    freeread = false;
end


%% Preallocate data
nbfields = numel(fields);

if ~freeread
    for i=1:nbfields,
        if isempty(fields(i).subfields)
            % Field is a vector / matrix
            data.(fields(i).name) = zeros(fields(i).count, nbrecords);
        else
            data.(fields(i).name) = struct();
        end
    end
end

%% Read records
totalrecords = 0;

data = struct;
ppos = dataoffset; % The file position

while (~feof(fid) && (totalrecords ~= nbrecords || freeread))
    fseek(fid, ppos, -1);
    totalrecords = totalrecords + 1;
    
    % Get the record time and timerange
    t = fread(fid, 1, 'uint64');
    if isempty(t) 
        break;
    end
    data.t(1, totalrecords) = t;   
    
    tr = fread(fid, 1, 'uint32');
    if isempty(tr)
        break;
    end
    data.tr(1, totalrecords) = tr;
    
    % Handle variable record sizes
    if (recordsize == -1) % Variable record size
        ppos = ppos + 1;
        datasize = fread(fid, 1, '*uint8');
    else
        datasize = recordsize;
    end
    
    % Read each field separately
    offset = 0; % Offset within the record, from the start of the data
    
    for i = 1:nbfields,
        try
            [value, offset] = readfield(fields(i), fid, offset, align);
        catch ex
            fclose(fid);
            rethrow(ex);
        end
            
        if (offset > recordsize && ~freeread)
           fclose(fid);
           error(['Exceeded record size while reading record #' num2str(totalrecords) '. Check field specifications and data alignment.']);
        end
            
        if isempty(value)
           continue;
        end
       
        try
            if (numel(value) == 1)
                data.(fields(i).name)(1, totalrecords) = value;
            else
                data.(fields(i).name)(:, totalrecords) = value;
            end
        catch ex
            disp(['Not enough data to complete field ' fields(i).name ' while processing record #' num2str(totalrecords)]);
        end
    end
    
    if (freeread && (datasize == 0))
        recordsize = offset;
        datasize = offset;
        disp(['The computed record size is ' num2str(recordsize) ' bytes.']);
    end
    
    if (offset < datasize)
        disp(['Record #' num2str(totalrecords) ' has ' num2str(datasize - offset) ' extra data bytes']);
    end
    
    ppos = ppos + datasize + 12;    % 12 = Size of the time + timerange
    
    % Display a progress message
    if (mod(totalrecords, 500) == 0)
        disp([ num2str(totalrecords) ' read']);
    end
end

if ~freeread
    disp(['Done reading ' num2str(totalrecords) ' of a total of ' num2str(nbrecords) ' records.']);
else
    disp(['Done reading ' num2str(totalrecords) ' records. Please check the correctness of the data.']);
end

% Convert times into seconds
data.t = data.t /1000000;
data.tr = data.tr /1000000;

fclose(fid);
end

%% Parses the format string
function fields = parsefieldspec(recordspec, startpos, endpos)

if (startpos > endpos) && ~isempty(recordspec)
    error(['Found an empty subrecord specification at ' recordspec(1:startpos)]);
elseif isempty(recordspec)
    error('No record specification provided. Check the record specification string is not empty and is valid.');
else
    fields = struct('name', [], 'type', [], 'size', [], 'subfields', [], 'count', []);

    nbfields = 0;
    nesting = 0;
    namestage = false;
    precstage = false;
    countstage = false;
    i = startpos;
    
    % The parser
    while i <= endpos
        if ~namestage && ~precstage && ~countstage && ~isspace(recordspec(i))
            namestage = true;
            namestart = i;
            nbfields = nbfields + 1;
        end
        
        if countstage
            % Parse the count
            if i == endpos
                countstage = false;
                countend = i;
            elseif isspace(recordspec(i))
                countstage = false;
                countend = i - 1;
            end
            
            if (~countstage)
                countstr = recordspec(countstart:countend);
                count = str2double(countstr);
                if isnan(count)
                    % Maybe a variable count specification, look for a
                    % field with the right name
                    for j=1:nbfields - 1,
                        if strcmp(fields(j).name, countstr)
                            count = countstr;
                            break
                        end
                    end
                    if (isnan(count))
                        error(['Incorrect count specification "' recordspec(countstart:countend) '" at ' recordspec(1:i)]);
                    end
                end
                fields(nbfields).count = count;
            end
        elseif namestage
            % Get the name of the field
            if isspace(recordspec(i)) || i == endpos
                error(['Unexpected end of record specification at ' recordspec(1:i)]);
            elseif recordspec(i) == '%'
                namestage = false;
                precstage = true;
                nesting = 0;
                name = recordspec(namestart:i - 1);
                precstart = i + 1;
                
                if isempty(name)
                    fields(nbfields).name = ['field' num2str(nbfields)];
                else
                    fields(nbfields).name = name;
                end
                fields(nbfields).type = [];
                fields(nbfields).size = 0;
                fields(nbfields).subfields = [];
                fields(nbfields).count = 1;
            end
        elseif precstage
            % Get the type of the field
            if (i == endpos) && ~isspace(recordspec(i))
                precstage = false;
                precend = i;
                if recordspec(i) == ')'
                    nesting = nesting - 1;
                end
            elseif isspace(recordspec(i)) && (nesting == 0)
                precstage = false;
                precend = i - 1;
            elseif (recordspec(i) == '*') && (nesting == 0)
                precstage = false;
                countstage = true;
                countstart = i + 1;
                precend = i - 1;
            elseif recordspec(i) == '('
                if nesting == 0 && recordspec(i - 1) ~= '%'
                    error(['Incorrect type specification at ' recordspec(1:i)]);
                end
                nesting = nesting + 1;
            elseif recordspec(i) == ')'
                nesting = nesting - 1;
            end
            
            if ~precstage
                if (nesting ~= 0)
                    error(['Missing closing parenthesis after ' recordspec(1:i)]);
                end
                
                if recordspec(precstart) == '('
                    fields(nbfields).subfields = parsefieldspec(recordspec, precstart + 1, precend - 1);
                else
                    type = strtrim(recordspec(precstart:precend));
                    if (strcmp(type, 'c'))
                        fields(nbfields).type = '*char';
                        fields(nbfields).size = 1;
                    elseif (strcmp(type, 'i') || strcmp(type, 'i32'))
                        fields(nbfields).type = 'int32';
                        fields(nbfields).size = 4;
                    elseif (strcmp(type, 'i8'))
                        fields(nbfields).type = 'int8';
                        fields(nbfields).size = 1;
                    elseif (strcmp(type, 'i16'))
                        fields(nbfields).type = 'int16';
                        fields(nbfields).size = 2;
                    elseif (strcmp(type, 'i64'))
                        fields(nbfields).type = 'int64';
                        fields(nbfields).size = 8;
                    elseif (strcmp(type, 'u') || strcmp(type, 'u32'))
                        fields(nbfields).type = 'uint32';
                        fields(nbfields).size = 4;
                    elseif (strcmp(type, 'u8'))
                        fields(nbfields).type = 'uint8';
                        fields(nbfields).size = 1;
                    elseif (strcmp(type, 'u16'))
                        fields(nbfields).type = 'uint16';
                        fields(nbfields).size = 2;
                    elseif (strcmp(type, 'u64'))
                        fields(nbfields).type = 'uint64';
                        fields(nbfields).size = 8;
                    elseif (strcmp(type, 'f') || strcmp(type, 'f64') || strcmp(type, 'n'))
                        fields(nbfields).type = 'double';
                        fields(nbfields).size = 8;
                    elseif (strcmp(type, 'f32'))
                        fields(nbfields).type = 'single';
                        fields(nbfields).size = 4;
                    elseif (strcmp(type, 'string'))
                        fields(nbfields).type = 'str';
                        fields(nbfields).size = 1;
                    elseif (strcmp(type, 'skip'))
                        fields(nbfields).type = [];
                        fields(nbfields).size = 1;
                    else
                        error(['Unrecognized builtin type "' type '" at  "' recordspec(1:i)]);
                    end
                end
            end
        end
        i = i + 1;
    end
end
end

%% Reads the field and returns its value
function [value, offset] = readfield(field, fid, offset, align)

% Check if the field is a simple or compount type.
if (~isempty(field.subfields))
    % Compound type, the value is a structure 
    value = struct();
    nbfields = numel(field.subfields);
    for i = 1:nbfields,  
        for j = 1:field.count,
            [newvalue, offset] = readfield(field.subfields(i), fid, offset, align);
            if (~isempty(newvalue))
                [value(j).(field.subfields(i).name)] = newvalue;
            else
                value = [];
                return;
            end
        end
    end
else  
    bytes = field.size * field.count;
    if isempty(field.type)   
        fseek(fid, bytes, 0);
        value = [];
    elseif (strcmp(field.type, 'str'))
        % Special case for strings
        if (field.count > 1)
            value = fread(fid, field.count, '*char')';
            idx = find(value == 0, 1);
            if (~isempty(idx)) 
                value = value(1: idx - 1);
            end
        else
            bytes = 1;
            value = '';
            c = fread(fid, 1, '*char');
            while  c ~= 0
                value(end + 1) = char(c);
                c = fread(fid, 1, '*char');
                bytes = bytes + 1;
            end
        end
        value = cellstr(value);
    else 
        % Handle alignment
        if (field.size <= align)
            padding = mod((field.size - mod(offset, field.size)), field.size);
        else
            padding = mod((align - mod(offset, align)), align);
        end
        if (padding ~= 0)
            fseek(fid, padding, 0);
            offset = offset + padding;
        end
        
        
        % Read the data
        value = fread(fid, field.count, field.type);
    end
    offset = offset + bytes;
end
end














