function example_folder()
%find the location of the example folder and open it
appinfo = matlab.apputil.getInstalledAppInfo;
idx = find(strcmp({appinfo.Name},'ModelUI'));
fpath = [appinfo(idx(1)).location,'/example'];
open(fpath)