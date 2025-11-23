function addReusablePreviewArea(app)
% create PreviewAxes and PreviewTextArea only if not already present
    if isempty(app.PreviewAxes) || ~isvalid(app.PreviewAxes)
        app.PreviewAxes = uiaxes(app.UIFigure, 'Position', [420 80 360 320], 'Visible', 'off');
    end
    if isempty(app.PreviewTextArea) || ~isvalid(app.PreviewTextArea)
        app.PreviewTextArea = uitextarea(app.UIFigure, 'Position', [420 80 360 320], 'Visible', 'off');
    end
end
