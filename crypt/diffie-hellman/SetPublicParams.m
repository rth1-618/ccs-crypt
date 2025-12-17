function SetPublicParams(app)
    panelName = 'DiffHellPanel';

    p = app.pDHEditField.Value;
    g = app.gDHEditField.Value;

    if p==0 || g==0
        app.UI.(panelName).Status.Text = 'p or g empty';
        uialert(app.UIFigure,'p or g cannot be empty','Error');
        return;
    end

    if ~isprime(p)
        app.UI.(panelName).Status.Text = 'p must be prime';
        uialert(app.UIFigure,'p must be prime','Error');
        return;
    end



    app.DH.p = p;
    app.DH.g = g;
    app.UI.(panelName).Status.Text = 'Public parameters set';
    app.PublishBtoAliceButton.Enable = 'on';
    app.PublishAtoBobButton.Enable = 'on';
end
