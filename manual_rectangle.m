function [phi,pos,roi] = manual_rectangle(I)
% initialize a rectangle signed distance function
% input:
% I - input image
% output:
% phi - signed distance function
% pos - [x,y,w,h] (x,y) is the coordinate of left top corner. [w h] is
%       the width and height of the selected area.
% roi - roi of original image
% ZHOU Yuan 2009-7-17
figure;
imagesc(I);colormap(gray);axis image;hold on;
[r,c] = size(I(:,:,1));
set(gcf,'WindowButtonDownFcn',@defineStartPtr);
set(gcf,'WindowButtonMotionFcn',@drawRect);
set(gcf,'Pointer','arrow');
title('left click to define start point');
uiwait;
set(gcf,'WindowButtonDownFcn',[]);
set(gcf,'WindowButtonMotionFcn',[]);
% hold off;
rects = findobj(gca,'type','rectangle');
if isempty(rects)
    phi = [];
    return;
end
pos = get(rects,'Position');
ltx = round(pos(1)); lty = round(pos(2));
rbx = round(pos(1)+pos(3)); rby = round(pos(2)+pos(4));
ltx(ltx<1) = 1; ltx(ltx>c) = c;
rbx(rbx<ltx) = ltx; rbx(rbx>c) = c;
lty(lty<1) = 1; lty(lty>r) = r;
rby(rby<lty) = lty; rby(rby>r) = r;
mask = zeros(size(I));
mask(lty:rby,ltx:rbx) = 1;
phi = bwdist(mask)-bwdist(1-mask)+mask-.5;
pos = [ltx,lty,rbx-ltx+1,rby-lty+1];
roi = I(lty:rby,ltx:rbx);
pause(0.01);


function defineStartPtr(src,eventdata)
% get(gcf,'SelectionType')
if strcmp(get(gcf,'SelectionType'),'alt') % right click defines end point
    uiresume;
else % left click defines start point
    handles = guidata(gcf);
    curPt = get(gca,'CurrentPoint');
%     fprintf('define start point ! Current location = (%g, %g)\n', curPt(1,1), curPt(1,2));
    handles.SrcPt = curPt;
    guidata(gcf,handles);
    title('right click to define end point');
end

function drawRect(src,eventdata)
curPt = get(gca, 'CurrentPoint');
x = curPt(1,1);
y = curPt(1,2);
handles = guidata(gcf);
rects = findobj(gcf,'type','rectangle');
delete(rects);
if isfield(handles,'SrcPt')
    startPt = handles.SrcPt;
    ltx = startPt(1,1);
    lty = startPt(1,2);
    w = x - ltx;
    h = y - lty;
    if w < 0 ltx = x; w = -w; end
    if h < 0 lty = y; h = -h; end
%     fprintf('Mouse is moving! Current location = (%g, %g)\n', curPt(1,1), curPt(1,2));
    if w ~= 0 && h ~= 0
        % rectangle attributes
        rectangle('Position',[ltx,lty,w,h],'EdgeColor','g','LineStyle',':','Curvature',[0 0]);
%         drawnow;
    end
end