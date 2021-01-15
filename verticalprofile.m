function output = verticalprofile(h_data)
    %test loading complete model definition from a single file   
            %run model and return results to Model.runModel
            nint = h_data.nint;
            d = h_data.WaterDepth;
            delz = d/nint;
            ev = {'Bowden','Kraav','Soulsby'};
            zi = 0:delz:d;
            zProfile = {zi'};
            uProfile = cell(1,3); uBar = zeros(1,3);
            for k=1:3
                [ubar,ui] = get_verticalProfile(h_data,zi,ev{k});
                %assign results for plotting
                uBar(1,k) = ubar;               
                uProfile{1,k} = ui;
            end
            time = {};
            metatxt = ev;  %cell array with same dimension as variables
            %output required is: results,time,xyzdata,addnprops,metatxt
            %xyzdata values are returned as cell arrays for {x,y,z}
            output = struct(...
                     'results',{uProfile},...
                     'time',{time},...
                     'xyzdata',{zProfile},...
                     'addnprops',{uBar},...
                     'metatxt',{metatxt});  
end
%% ------------------------------------------------------------------------
%  Model functions
%% ------------------------------------------------------------------------
function [ubar,ui] = get_verticalProfile(dobj,zi,but1)
    %   Compute the depth averaged current,given a value
    %   of tidal current amplitude at a particulat depth,Z.  The
    %   method is based of the work of D. Prandle, 1982, "The vertical
    %   structure of tidal currents and other oscillatory flows"
    %   in Continental Shelf Research,1,2,pp191-207.
    %
    %map properties to function variables
    cD = dobj.cDfriction;    %bed friction coefficient
    fr = dobj.NKfriction;    %Nikaurades friction coefficient
    T  = dobj.TidalPeriod;   %tidal period (hours)
    z0 = dobj.Rounghness;    %roughness length
    zu = dobj.zVelocity;     %height of velocity above bed(m)
    uz = dobj.uVelocity;     %velocity at depth z (m/s)
    d  = dobj.WaterDepth;    %water depth (m)

    %derived paramters
    freq = 2*pi()/(T*3600);
    uzz = complex(uz,0);
    uu = uz;
    uu1 = -999;
    % compute initial estimate of depth of boundary layer
    ustar = sqrt(cD)*uu;
    du = ustar/freq;
    %
    while (uu-uu1)>0.1   %iterate until depth av velocity converges
        %
        uu1 = uu;
        av = eddyVisc(uu,ustar,z0,d,freq,but1);
        %
        j = 3*pi()*sqrt(av*freq);
        j = j/(8*fr*uu);
        y = sqrt(freq/av)*d;
        if (y>35.0)
            y = 35.0;
        end
        xx = complex(0,1);
        xx = sqrt(xx);
        yy = y*xx;
        jj = j*xx;
        %
        ce = exp(2*yy);
        tt = (1-ce)*(jj-1/yy-1)-2*ce;
        qq = (jj*(1-ce)-1-ce)/tt;
        bb = yy/d;
        %
        ubar = exp(bb*zu)+exp(-bb*zu+2*yy);
        ubar = uzz/(ubar/tt+qq);
        %
        uzi = exp(bb*zi)+exp(-bb*zi+2*yy);
        uzi = ubar*(uzi/tt+qq);
        %
        uu = abs(ubar);
        ui = abs(uzi);
        phase = atan2(imag(ubar),real(ubar));
        phdif = -phase*180/pi();
        %
        %recalculate USTAR and the boundary layer depth
        if zu <= 0.2*du
            ustar = 0.4*uz/log(zu/z0);
        else
            ustar = sqrt(cD)*uu;
        end
        du = ustar/freq;
        %stro = uu*T*3600/d;  %Strouhal number
    end
end
%%
function av = eddyVisc(uu,ustar,z0,d,freq,but1)
    %compute eddy viscosity for selected model
    switch but1
        case 'Bowden'
        alpha = 0.0012;
        av = alpha*abs(uu)*d;
        case 'Kraav'
        beta = 0.00002;
        av = beta*uu^2/freq;
        case 'Soulsby'
        av = 0.4*ustar*z0;
    end
end
