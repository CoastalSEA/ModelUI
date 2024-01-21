function st = run_SimpleTide
    %intialise environment settings to run SimpleTide
    muimsg = 'ModelUI not found. Check that App is installed';
    isok = initialise_mui_app('ModelUI',muimsg,'example');
    if ~isok, return; end
    st = SimpleTide;
end