function open_manual()
%find the location of the asmita app and open the manual
appinfo = matlab.apputil.getInstalledAppInfo;
idx = find(strcmp({appinfo.name},'ModelUI'));
fpath = [appinfo(idx(1)).location,'/doc/ModelUI manual.pdf'];
open(fpath)
