% here I'm declaring a variable named 'intensityValues' which will define
% my loop. As with every loop I'm indicating: what numeric value I'm
% starting at, my step or the difference between each number, and lastly
% what will my final numeric value is where the loop will terminate.
intensityValues = 1:0.5:20;

% starting my loop - we're going to loop over each file number from 1 to 39
% each iteration represents one '.mat' file that will be processed.
for fileNumber = 1:39
    % we're creating a string and storing it in a variable named
    % 'fileName'. The 'sprintf' function creates a string from a format
    % specifier and a set of variables. The specifier here would be the
    % '%02d'. The function will create file names depending on the value we
    % defined 'fileNum' to be. If < 10, file name will be prefixed with a 0
    % else, will generate integers of 10,11,12, etc.
    fileName = sprintf('%02d AP_hBN_File1.mat', fileNumber);

    % let's load all of the '.mat' files done by the iteration using the
    % load function and store it in a variable named 'loadedData'.
    loadedData = load(fileName);

    % clearing the cmd window
    clc;

    % listing of all variables stored within the loaded structure for
    % validation purposes
    disp(whos('-file', fileName));
    disp(fieldnames(loadedData));

    % since we know that the intensity increases in steps of 0.5,
    % we adjust the indexing to map file numbers to intensity values
    % and then convert these to the structure names used in the files.
    % we need to account for the fact that whole numbers are followed by a
    % 0. For example, '10.0' becomes 100 and '10.5' becomes 105 etc.
    intensityIndex = (fileNumber - 1) * 0.5 + 1;  

    % beginning our logic, checking if the intensity index is a whole
    % number and formatting the structure file name accordingly by
    % appending a '0' for whole numbers (if applicable).
    if mod(intensityIndex, 1) == 0  
        % append '0' forwhole numbers
        intensityStr = sprintf('%d0', intensityIndex);  
    else
        % multiply by 10 otherwise
        intensityStr = sprintf('%d', intensityIndex * 10);  
    end

    % creating the structure name stored in a variable 'structName'.
    structName = sprintf('Struct_%smW100X05s', intensityStr);

    % access the structure and retrieve the y data
    if isfield(loadedData, structName)
        % we know that in a matrix it's 'row' x 'column' so we can denote 
        % that notation using parenthesis. So here I'm telling it that I
        % want the 1st column and the colon is denoting that I want all 
        % the rows.
        yData = loadedData.(structName).data(1, :);

        % we're converting the second element of the 'axisscale' field 
        % w/in the structure from a "cell" to a "numeric". The fxn
        % 'axisscale' can store numeric data in a cell format so
        % we are making this conversion.
        x1 = cell2mat(loadedData.(structName).axisscale(2, 1));

        % we're doing calculations and storing it as a new variable named 
        % 'x2'using the values we know from 'x1'.
        x2 = ((1./(532*10^-7))-(1./(x1*10^-7)));

        % defining our range of x-values we want our graph to display. 
        % This will be the peak of hBN approximately.
        xlim([1050 1500]);

        % this fxn does what it sounds like, we're keeping the current plot
        % and the subsequent iterations will be drawn over it. Good for 
        % analyzing data and looking at trends as we're increasing the
        % intensity/power of our laser which I have data for 1mW -> 20mW.
        hold on;

        % the actual plotting fxn. We are plotting a 2-D plot where we're 
        % plotting 'y' against 'x2'.
        plot(x2, yData);
    else
        warning('The structure %s does not exist in the file %s.', structName, fileName);
    end
end

% releasing the plot hold, no further data points to be made on current
% plot.
hold off;
