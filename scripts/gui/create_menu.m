function create_menu( h );
% test code -- figuring out right-click context menus.
% really silly -- changes font for now.
%
% TODO: embed all other functions in setting/ into context menus
%         that show up on right click of graphical elements.
%    
% (C) R. Das, Stanford University, 2017
    
c = uicontextmenu;

% Assign the uicontextmenu to the plot line
h.UIContextMenu = c;
r% Create child menu items for the uicontextmenu
m1 = uimenu(c,'Label','Times','Callback',{@setlinestyle, h});
m2 = uimenu(c,'Label','Helvetica','Callback',{@setlinestyle, h});

    function setlinestyle(source,callbackdata, h)
    switch source.Label
        case 'Times'
            h.FontName = 'Times';
        case 'Helvetica'
            h.FontName = 'Helvetica';
    end
    h
