function open_manual()
%find the location of the asmita app and open the manual
% appinfo = matlab.apputil.getInstalledAppInfo;
toolboxes = matlab.addons.toolbox.installedToolboxes;
% idx = find(strcmp({toolboxes.Name},'ModelUI'));
idx = find(strcmp({appinfo.name},'ModelUI'));
fpath = [toolboxes(idx(1)).location,'/doc/ModelUI manual.pdf'];
open(fpath)
