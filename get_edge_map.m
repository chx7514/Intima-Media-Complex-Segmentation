function f = get_edge_map(I, s1)
I1 = double(I); % image used for calculating force

% s1 = 1; s2 = 15;

pw = 1:50; % possible widths
width1 = max(find(exp(-(pw.*pw)/(2*s1*s1))./(sqrt(2*pi)*s1)>0.0001));

[x,y] = meshgrid(-width1:width1,-width1:width1);
dgau2D = -y.*exp(-(x.*x+y.*y)/(2*s1^2))/(2*pi*s1^2); % first derivative of gaussian

f1 = imfilter(I1, dgau2D, 'conv','replicate');
f1(f1<0) = 0;
f=f1;

f = f./max(f(:));
figure;imagesc(f);colormap(gray);axis image;hold on;