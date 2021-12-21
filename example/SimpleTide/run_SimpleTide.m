function st = run_SimpleTide
    %intialise environment settings to run SimpleTide
    muimsg = 'ModelUI not found. Check that App is installed';
    ok = initialise_mui_app('ModelUI',muimsg,'example');
    if ok<1, return; end
    st = SimpleTide;
end