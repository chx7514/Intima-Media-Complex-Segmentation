function project()

close all;
clear all;

I1 = imread('image1.jpg');
% I1 = imread('image2.jpg');

if ndims(I1) == 3
    I1 = rgb2gray(I1);
end

[~,~,roi] = manual_rectangle(I1);

I = double(roi);
I = (I-min(I(:)))/(max(I(:))-min(I(:)))*255;
figure;imshow(I,[]);hold on;

% get rough edge map
% rough_edge_map = get_edge_map(I, 11, 11, 0);
% edge_map = get_edge_map(I, 5, 1, 0);

rough_edge_map = get_edge_map(I, 7);
edge_map = get_edge_map(I, 0.5);


% dynamic programming for the complex
lam = 0.1;
[x, rough_y] = dp(I, rough_edge_map, lam, 0);
figure;imshow(I,[]);hold on;
plot(x, rough_y, 'b');

[~, up_y] = dp(I, edge_map, lam, 2, rough_y, -3);
[~, down_y] = dp(I, edge_map, lam, 1, rough_y, 1);

plot(x, up_y, 'r');
plot(x, down_y, 'g');

% SNAKE
alpha = .2;
beta = 1.4;
iter = 200;
delta_t = 0.01;
% up_y_snake = snake_1d(x, up_y, edge_map, alpha, beta, delta_t, iter);
% down_y_snake = snake_1d(x, down_y, edge_map, alpha, beta, delta_t, iter);
[up_y_snake, down_y_snake] = snake_2(x, up_y, down_y, edge_map, alpha, beta, delta_t, iter);

figure;imshow(I,[]);hold on;
plot(x, up_y_snake', 'm');
plot(x, down_y_snake', 'c');
hold off;

% thickness
figure;imshow(I,[]);hold on;
[thickness] = get_thickness(up_y_snake, down_y_snake, 2);
thickness = thickness(thickness > 1e-3);
tmean = mean(thickness)
tstd = std(thickness)
tmin = min(thickness)
tmax = max(thickness)

