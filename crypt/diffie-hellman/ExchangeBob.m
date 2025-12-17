function ExchangeBob(app)
    b = app.BobPrivateEditField.Value;

     if b<=0 
        app.UI.('DiffHellPanel').Status.Text = 'b is empty';
        uialert(app.UIFigure,'b cannot be empty','Error');
        return;
     end

    app.DH.b = b;

    if app.DH.p<=0 || app.DH.g<=0
        app.UI.('DiffHellPanel').Status.Text = 'global params are not set';
        uialert(app.UIFigure,'Set Global params first','Error');
        return;
    end

    app.DH.B = powmod(app.DH.g, b, app.DH.p);
    app.BobPublicLabel.Text = num2str(app.DH.B);

            app.AlicesComputeSecretKeyButton.Enable = 'on';
end
