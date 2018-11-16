function [h,t]=addTSgamfits(ocean,conts,col)

% function [h,t]=addTSgamfits(ocean,conts,col)
%
% Inputs: 
%   ocean = 'SO'for the entire Southern Ocean
%   'RS" for just the Ross Sea area, and 'NR' for the
%   non-Ross Sea areas of the Southern Ocean.
%
%   conts =       
%    '22'       
%    '22.5'     '23'      '23.5'     '24'       '24.5'    '25'       '25.2'    '25.4'     '25.6'
%    '25.8'     '25.9'    '26'       '26.1'     '26.2'    '26.3'     '26.4'    '26.5'     '26.6'
%    '26.7'     '26.8'    '26.9'     '27'       '27.05'   '27.1'     '27.15'   '27.2'     '27.25'
%    '27.3'     '27.35'   '27.4'     '27.45'    '27.5'    '27.55'    '27.6'    '27.65'    '27.7'
%    '27.75'    '27.8'    '27.84'    '27.85'    '27.9'    '27.95'    '28'      '28.05'    '28.1'
%    '28.15'    '28.2'    '28.25'    '28.27'    '28.3'    '28.35'    '28.4'    '28.45'    '28.5'
%    '28.55'    '28.6'    '28.65'    '28.7'     '28.75'   '28.8'     '28.85'   '28.9'     '28.95'
%    '29'
%
%   col =
%   1: black      2: red          3: blue         4: green        5: magenta
%   6: cyan       7: yellow       8: gray         9: orange       10: tan
%   11: purple    12: lt blue     13: lt green    14: pink
%
% Example: 
%   [h,t]=addTSgamfits('SO',[27.80; 28; 28.20; 28.40],6);

if (nargin <2 | nargin > 3)
    eval(['help addTSgamfits']);
    return;
elseif (nargin == 2); 
col=[8];
end;

if (ocean(1:2) == 'RS');
    load ROSS_TSgamfits.mat;
    word=['Ross Sea gamma fits'];
elseif (ocean(1:2) == 'NR');
    load NONROSS_TSgamfits.mat;
    word=['Gamma fits outside the Ross Sea'];
elseif (ocean(1:2) == 'SO');
    load SO_TSgamfits.mat;
    word=['Southern Ocean gamma fits'];
else;
    eval(['help plotTSgamfits']);
    return;
end;

cbar={'k'; 'r'; 'b'; 'g'; 'm'; 'c'; 'y'; [.7 .7 .7]; [0.9882 0.6431 0.3255]; ...
        [.75 .5 .25]; [0.6824 0.3333 0.6510]; [0.6549 0.8706 0.9373]; ...
        [0.7255 0.8863 0.6000]; [0.9804 0.7333 0.7843]};

quote = '''';

grid on; hold on;

target=sort(conts);
target=target(:);

v=axis;
salmin=v(1);salmax=v(2);
ptmmin=v(3);ptmmax=v(4);

count=1;

for i=1:length(target);
    j=find(gamlevs==target(i));
    if isempty(j);
        disp([ num2str(target(i)) ' is not among the available gamma fits...']);
    else;
    
if ptmmax>ptmlims(j,2);
    ptmmaxposition=ptmlims(j,2);
else;
    ptmmaxposition=ptmmax;
end;
yy=[ptmlims(j,1):.1:ptmmax];
        xx=polyval(gamfit{j},yy);
        h(i)=plot(xx,yy,'-','color',cbar{col},'linewidth',0.5);
        t(i)=text(max(xx),max(yy),num2str(target(i)),'color',cbar{col});
    end; %if
end; %for

%xlabel('SALINITY');
%ylabel('THETA');
%title(word);
