function [newColor] = greyout(h,beta)
%GRAYOUT greys-out color data given by the handle by a factor of beta. It
%was designed to work for line plots, but was (poorly) adapted to work for
%some other markers and edge colors.  Give it a whirl--If you don't like
%it, I'll double your money back. 
% 
% 
% Syntax
% greyout(h)
% greyout(h,beta) 
% newColor = greyout(...)
% 
% 
% Description 
% greyout(h) lightens objects given by the handle(s) h. 
% 
% greyout(h,beta) lightens or darkens objects by a factor of beta. If
% beta = 1, the object becomes white.  If beta = -1, the object
% becomes black. Default beta is 0.5. 
% 
% newColor = greyout(...) returns rgb values of the new color(s). 
% 
% 
%% Example 
% Several often-used models exist to describe some observational data, but
% you've come up with your own brand new model that you want everyone to
% know is the best thing in science since sliced people in that Body Worlds
% exhibit.  In a presentation you may want to start out by showing the
% observational data and the old models like this: 
% 
% % Some data: 
% x = 1:10; 
% yData = x-5+x.^1.05; 
% y1 = x; 
% y2 = x-2; 
% y3 = x-3; 
% y4 = x-4; 
% 
% % Plot the data:
% figure
% hData = plot(x,yData,'mo','markersize',10,'markerfacecolor','g'); 
% hold on; 
% h1 = plot(x,y1,'r','linewidth',2); 
% h2 = plot(x,y2,'b','linewidth',2); 
% h34= plot(x,[y3;y4],'k','linewidth',2); 
% box off
% axis([1 10 -5 20])
% 
% legend('data','conventional model','some other guy''s old model','defunct model 1',...
%     'defunct model 2','location','northwest') 
% legend boxoff
% 
%% 
% And here's the part in your presentation where you say, "the old models
% are not good enough--don't you wish that someone could come up with a
% better way of describing the data?"  Then the crowd waits for the
% unveil...
% 
% When you plot your own model you want it to stand out. Below, we plot
% your new model, then grey-out those old models because they're a thing of
% the past.  We will also darken the observational data simply to show how
% to do it, and then bring the observational data to the front so it's not
% buried by the antequated models.  
% 
% myNewModel = x - 5.5 + x.^1.1; 
% plot(x,myNewModel,'r','linewidth',2); 
% 
% % Update the legend to include your new amazing model: 
% legend('data','conventional model','some other guy''s old model','defunct model 1',...
%     'defunct model 2','my new amazing model','location','northwest') 
% legend boxoff
% 
% greyout(h1)          % washes out "conventional model"
% greyout([h2;h34],.8) % washess out other models
% greyout(hData,-.5)   % darkens data
% 
% uistack(hData,'top') % brings data to front 
% 
%% Author Info
% The |greyout| function was written by Chad A. Greene of the Institute for
% Geophysics at the University of Texas at Austin.  July 2014. 


%% Check inputs and set defaults: 

if exist('beta','var')
    assert(beta>=-1&&beta<=1,'beta must lie between zero and 1'); 
end 

if ~exist('beta','var')
    beta = 0.5; 
end

%% Get current colors: 

try
    origColor = get(h,'color'); 
    if numel(h)>1
        origColor = cell2mat(origColor); 
    end
    newColor = NaN(length(h),3);

    for k = 1:length(h); 
        if beta>=0
            newColor(k,:) = origColor(k,:) + beta*(1-origColor(k,:)); 
        end
        if beta<0
            newColor(k,:) = origColor(k,:) + beta*origColor(k,:); 
        end
        set(h(k),'color',newColor(k,:)); 
    end
    
    if nargout==0
        clear newColor
    end

end

%% Try for more types of colors: 

try 
    origColor2 = get(h,'markerfacecolor'); 
    if numel(h)>1
        origColor2 = cell2mat(origColor2); 
    end

    for k = 1:length(h); 
        if beta>=0
            newColor2(k,:) = origColor2(k,:) + beta*(1-origColor2(k,:)); 
        end
        if beta<0
            newColor2(k,:) = origColor2(k,:) + beta*origColor2(k,:); 
        end
        set(h(k),'markerfacecolor',newColor2(k,:)); 
    end
    
end
try 
    origColor2 = get(h,'facecolor'); 
    if numel(h)>1
        origColor2 = cell2mat(origColor2); 
    end

    for k = 1:length(h); 
        if beta>=0
            newColor2(k,:) = origColor2(k,:) + beta*(1-origColor2(k,:)); 
        end
        if beta<0
            newColor2(k,:) = origColor2(k,:) + beta*origColor2(k,:); 
        end
        set(h(k),'facecolor',newColor2(k,:)); 
    end
    
end
try 
    origColor2 = get(h,'edgecolor'); 
    if numel(h)>1
        origColor2 = cell2mat(origColor2); 
    end

    for k = 1:length(h); 
        if beta>=0
            newColor2(k,:) = origColor2(k,:) + beta*(1-origColor2(k,:)); 
        end
        if beta<0
            newColor2(k,:) = origColor2(k,:) + beta*origColor2(k,:); 
        end
        set(h(k),'edgecolor',newColor2(k,:)); 
    end
    
end


end


