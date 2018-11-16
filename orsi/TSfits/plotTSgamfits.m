function plotTSgamfits(ocean)

% function plotTSgamfits(ocean)
%
% Input: 
%   ocean = 'SO'for the entire Southern Ocean
%   'RS" for just the Ross Sea area, and 'NR' for the
%   non-Ross Sea areas of the Southern Ocean.
%
% Examples:
%   plotTSgamfits('SO')

if (nargin ==0 | nargin > 1)
    eval(['help plotTSgamfits']);
    return;
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

target=[22;23;24;25;26;26.5;27;27.2;27.4;27.6;27.8;28;28.20;28.40;28.60;28.80];
count=1;

figure; grid on; hold on;

quote = '''';
col={'r','c','k','m','g','b','r','c','k','m','g','b','r','c','k','m','g','b'};

for ii=1:length(gamlevs);
xx=polyval(gamfit{ii},[ptmlims(ii,1):.1:ptmlims(ii,2)]);
yy=[ptmlims(ii,1):.1:ptmlims(ii,2)];
qq=plot(xx,yy,'-','color',[0.7 0.7 0.7],'linewidth',1);

if (gamlevs(ii) == 25.9 | gamlevs(ii) == 27.84  );delete(qq);end;
if (gamlevs(ii) == 28.27 );set(qq,'linewidth',0.5,'color','g');end;

if ( ~isempty(gamlevs(ii)) &  gamlevs(ii)==target(count));
    set(qq,'color','r');
    t=text(max(xx),max(yy),num2str(gamlevs(ii)));
    set(t,'color','r','fontsize',10);
    if(count ~= length(target));
        count=count+1;
    end;
end;

end; % for
xlabel('SALINITY');
ylabel('THETA');
axis([28 38 -2 30]);
title(word);
