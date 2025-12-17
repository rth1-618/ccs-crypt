function generateRSAKeys(app)
    panelName = 'RSAPanel';
    e = str2double(app.eDropDown.Value);
    phi = app.RSA.phi;
    n = app.RSA.n;

    d = modInverse(e, phi);

    app.RSA.e = e;
    app.RSA.d = d;
    app.RSA.hasPublicKey = true;
    app.RSA.hasPrivateKey = true;

    savePrivateKey(n, d);

    app.UI.(panelName).Btn_Encrypt.Enable = 'on';
    app.UI.(panelName).Status.Text = 'Private key saved';

end
