function loadRSAKeys(app)
    panelName = 'RSAPanel';
    resetModule(app, panelName);
    [f,p] = uigetfile('*.txt','Load Private Key');
    if isequal(f,0)
        n = []; d = []; return;
    end

    fid = fopen(fullfile(p,f),'r');
    header = fgetl(fid);
    if ~strcmp(header,'RSA_PRIVATE_KEY')
        fclose(fid);
        uialert(app.UIFigure,'Invalid RSA private key file.','Error'); return;
    end

    skipLine = fgetl(fid);
    nLine = fgetl(fid);
    dLine = fgetl(fid);
    fclose(fid);

    n = sscanf(nLine,'n=%d');
    d = sscanf(dLine,'d=%d');
    
    if isempty(n), return; end

    app.RSA.n = n;
    app.RSA.d = d;
    app.RSA.hasPrivateKey = true;


    app.nLabel.Text = sprintf('SECRET LOADED:\n \t d = %d\n \t n = %d',d,n);
    app.UI.(panelName).Btn_Decrypt.Enable = 'on';
    app.UI.(panelName).Status.Text ='Private key loaded';
end

