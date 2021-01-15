function demo_folder()
%find the location of the asmita demo folder and open it
% appinfo = matlab.apputil.getInstalledAppInfo;
toolboxes = matlab.addons.toolbox.installedToolboxes;
idx = find(strcmp({toolboxes.name},'ModelUI'));
fpath = [toolboxes(idx(1)).location,'/DemoModels'];
winopen(fpath)