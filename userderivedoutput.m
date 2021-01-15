function result = userderivedoutput(t,x,y,z,flag)
    %function to be called as a user equation in CreateVar of DataManip class
    %example compute the volume under surface at each time step for the
    %output from the Diffusion model (t,x,y)
    %find dimensions to match arrary input and map to Z(T,X,Y)=array with
    %dimensions of Time and X and Y.
    %flag is 'integral' or 'gradient'
    nrecs = length(t);
    xyz = {x,y,z};
    varnumel = cellfun(@numel,xyz);
    [~,isarrayvar] = max(varnumel);
    Z = xyz{isarrayvar};
    arraydims = size(Z);
    X = xyz{varnumel==arraydims(2)};
    Y = xyz{varnumel==arraydims(3)};
    switch flag
        %(NB must maintain rows to match t)
        case 'integral'
            %compute volume under the surface             
            for i=1:nrecs
                result(i,1) = trapz(Y,(trapz(X,Z(i,:,:))));
            end
        case 'gradient'
            hf = figure('Name','Results Plot', ...
                'Units','normalized', ...
                'Resize','on','HandleVisibility','on', ...
                'Tag','PlotFig');
            for i=1:nrecs
                [FX,FY] = gradient(squeeze(Z(i,:,:)),Y,X);
                result(i,:,:) = sqrt(FX.^2+FY.^2);
                %animate the results             
                contour(Y,X,squeeze(Z(i,:,:)));
                hold on
                quiver(Y,X,-FX,-FY);
                hold off
                drawnow; 
            end
    end
end