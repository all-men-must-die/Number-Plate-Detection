%% NUMBER PLATE DETECTION
% Program for detecting the number plate and the registration number of a
% car. The detection is done using horizontal and vertical histogram
% analysis. The algorithm is based on the fact that for a number plate,
% dark pixels are located in a very small region. Hence, using the
% histogram analysis, we locate the regions which have a high change in
% light and dark pixels. Then the region is selected using an appropriate
% threshold value.

tic;
I = imread('car.png');
Igray = rgb2gray(I);

% figure, imshow(I)

%% Image dilation
% Image dilation for removing any noise

[m, n] = size(Igray);
Idilated = Igray;

for i = 1:m
    for j = 2:n-1
        temp = max(Igray(i, j - 1), Igray(i, j));
        Idilated(i, j) = max(temp, Igray(i, j + 1));
    end
end

figure, imshow(Idilated)
I = Idilated;

%% Horizontal and Vertical histogram analysis
% Horizontal and vertical edge processing

difference = 0;
sum = 0;
total_sum = 0;

% Horizontal edge processing
max_horizontal = 0;
maximum = 0;
for i = 2:n
    sum = 0;
    for j = 2:m
        if (I(j, i) > I(j - 1, i))
            difference = uint32(I(j, i) - I(j - 1, i));
        else
            difference = uint32(I(j - 1, i) - I(j, i));
        end
        if (difference > 10)
            sum = sum + difference;
        end
    end
    horz(i) = sum;
    if(sum > maximum)
        max_horizontal = i;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end
average = total_sum/n;

% figure, plot(horz);

% Applying low pass filter

sum = 0;
horizontal_edge = horz;
for i = 21:(n - 21)
    sum = 0;
    for j = (i - 20):(i + 20)
        sum = sum + horz(j);
    end
    horizontal_edge(i) = sum/41;
end

% figure, plot(horizontal_edge);


% Filtering using dynamic threshold

for i = 1:n
    if(horizontal_edge(i) < average)
        horizontal_edge(i) = 0;
        for j = 1:m
            I(j, i) = 0;
        end
    end
end


% figure, plot(horizontal_edge);

difference = 0;
sum = 0;
total_sum = 0;
difference = uint32(difference);
% Vertical edge processing
max_vertical = 0;
maximum = 0;
vert = 0;
for i = 2:m
    sum = 0;
    for j = 2:n
        if (I(i, j) > I(i, j - 1))
            difference = uint32(I(i, j) - I(i, j - 1));
        else
            difference = uint32(I(i, j - 1) - I(i, j));
        end
        if (difference > 10)
            sum = sum + difference;
        end
    end
    vert(i) = sum;
    if(sum > maximum)
        max_vertical = i;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end
average = total_sum/m;

% figure, plot(vert);

% Applying low pass filter

sum = 0;
vertical_edge = vert;
for i = 21:(m - 21)
    sum = 0;
    for j = (i - 20):(i + 20)
        sum = sum + vert(j);
    end
    vertical_edge(i) = sum/41;
end

% figure, plot(vertical_edge);


% Filtering using dynamic threshold

for i = 1:m
    if(vertical_edge(i) < average)
        vertical_edge(i) = 0;
        for j = 1:n
            I(i, j) = 0;
        end
    end
end


% figure, plot(vertical_edge);

%% Region extraction        
% Find probable regions which may contain the number plate

j = 1;
for i = 2:n - 2
    if(horizontal_edge(i) ~= 0 && horizontal_edge(i - 1) == 0 && horizontal_edge(i + 1) == 0)
        column(j) = i;
        column(j + 1) = i;
        j = j + 2;
    elseif((horizontal_edge(i) ~= 0 && horizontal_edge(i-1) == 0) || (horizontal_edge(i) ~= 0 && horizontal_edge(i+1) == 0))
            column(j) = i;
            j = j + 1;
    end
end

j = 1;
    for i = 2:m - 2
        if(vertical_edge(i) ~= 0 && vertical_edge(i - 1) == 0 && vertical_edge(i + 1) == 0)
            row(j) = i;
            row(j + 1) = i;
            j = j + 2;
        elseif((vertical_edge(i) ~= 0 && vertical_edge(i-1) == 0) || (vertical_edge(i) ~= 0 && vertical_edge(i+1) == 0))
                row(j) = i;
                j = j + 1;
        end
    end
    
        
[~, column_size] = size(column);
if(mod(column_size, 2))
    column(column_size + 1) = n;
end

[~, row_size] = size(row);
if(mod(row_size, 2))
    row(row_size + 1) = m;
end

for i = 1:2:row_size
    for j = 1:2:column_size
        if(~((max_horizontal >= column(j) && max_horizontal <= column(j+1)) && (max_vertical >= row(i) && max_vertical <= row(i+1))))
            for m = row(i):row(i + 1)
                for n = column(j):column(j + 1)
                    I(m, n) = 0;
                end
            end
        end
    end
end


figure, imshow(I)
toc;