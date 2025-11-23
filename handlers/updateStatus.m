function updateStatus(app, message)
    try
        ui = app.UI.(app.currentModule);
        ui.Status.Text = message;
    catch
        % fallback: no-op
    end
end
