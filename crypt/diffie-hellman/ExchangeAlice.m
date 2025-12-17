function ExchangeAlice(app)
    a = app.AlicePrivateEditField.Value;
    
    if a<=0
        app.UI.('DiffHellPanel').Status.Text = 'a is empty';
        uialert(app.UIFigure,'a cannot be empty','Error');
        return;
     end

    app.DH.a = a;


    if app.DH.p<=0 || app.DH.g<=0
        app.UI.('DiffHellPanel').Status.Text = 'global params are not set';
        uialert(app.UIFigure,'Set Global params first','Error');
        return;
    end

    app.DH.A = powmod(app.DH.g, a, app.DH.p);
    app.AlicePublicLabel.Text = num2str(app.DH.A);

            app.BobsComputeSecretKeyButton.Enable = 'on';
end
