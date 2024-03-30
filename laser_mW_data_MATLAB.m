% Define the specific file numbers that correspond to the desired
% intensities
fileNumbers = [1, 9, 19, 29, 39];

% Create a new figure window explicitly
figure;
hold on; % Hold on to add multiple plots to the same figure

% starting my loop - we're going to loop over each file number from 1 to 39
% each iteration represents one '.mat' file that will be processed.
for i = 1:length(fileNumbers)
    fileNumber = fileNumbers(i);
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
    disp(whos('-file', fileName)); % Display variables in the .mat file
    disp(fieldnames(loadedData)); % Display field names of the loaded data
    
    % Determine the intensityValue based on fileNumber
    intensityValue = switchIntensityValue(fileNumber);
    
    % Correctly format the intensityStr
    intensityStr = formatIntensityStr(intensityValue);
    
    structName = sprintf('Struct_%smW100X05s', intensityStr);
    
    if isfield(loadedData, structName)
        yData = loadedData.(structName).data(1, :);
        % we're converting the second element of the 'axisscale' field 
        % w/in the structure from a "cell" to a "numeric". The fxn
        % 'axisscale' can store numeric data in a cell format so
        % we are making this conversion.
        x1 = cell2mat(loadedData.(structName).axisscale(2, 1));
        % we're doing calculations and storing it as a new variable named 
        % 'x2'using the values we know from 'x1'.
        x2 = ((1./(532*10^-7))-(1./(x1*10^-7)));
        
        % Filter for x values between 1300 and 1500
        validIndices = x2 >= 1300 & x2 <= 1500;
        x2Filtered = x2(validIndices);
        yDataFiltered = yData(validIndices);
        
        % Plot the filtered data
        plot(x2Filtered, yDataFiltered);
        
        % Annotate each plot with its laser power
        text(mean(x2Filtered), max(yDataFiltered), sprintf('%dmW', intensityValue), 'HorizontalAlignment', 'center');
    else
        warning('The structure %s does not exist in the file %s.', structName, fileName);
    end
end

% Customize the plot
xlabel('Raman shift (cm^-1)');
ylabel('Intensity');
xlim([1300 1500]); % Set the x-axis limits to focus on the 1300 - 1500 range
hold off; % Release the hold on the figure

% Helper functions to determine intensityValue and format intensityStr
function iv = switchIntensityValue(fn)
    switch fn
        case 1
            iv = 1;
        case 9
            iv = 5;
        case 19
            iv = 10;
        case 29
            iv = 15;
        case 39
            iv = 20;
        otherwise
            warning('Unexpected file number: %d', fn);
            iv = -1; % Return a flag for an unexpected value
    end
end

function is = formatIntensityStr(iv)
    if iv == 1
        is = sprintf('%d', iv); % For 1mW case
    else
        is = sprintf('%d0', iv); % For all other cases
    end
end
