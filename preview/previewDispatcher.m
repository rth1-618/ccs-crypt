function previewDispatcher(app)
% Shows ONLY what is appropriate for current mode (text or image)

    % Hide everything first
    try app.PreviewAxes.Visible = 'off'; catch; end
    try app.PreviewTextArea.Visible = 'off'; catch; end

    M = app.currentModule;
    ui = app.UI.(M);

    % ============================
    % IMAGE MODE
    % ============================
    if app.isInputImage
        % Never show text areas in image mode
        ui.UserOutput.Visible = 'off';

        if ~isempty(app.outputImage)
            % Show OUTPUT image
            app.PreviewAxes.Visible = 'on';
            imshow(app.outputImage, 'Parent', app.PreviewAxes);
            return;
        end

        if ~isempty(app.currentImage)
            % Show INPUT image if no output yet
            app.PreviewAxes.Visible = 'on';
            imshow(app.currentImage, 'Parent', app.PreviewAxes);
            return;
        end

        return;
    end

    % ============================
    % TEXT MODE
    % ============================
    % Never use PreviewTextArea at all for text modules
    app.PreviewTextArea.Visible = 'off';
    app.PreviewAxes.Visible = 'off';

    % Only show text inside the module's UserOutput text area
    if ~isempty(app.outputText)
        ui.UserOutput.Value = app.outputText;
    end
end


% function previewDispatcher(app)
% % PREVIEWDISPATCHER   Show app.outputImage (preferred) or app.outputText.
%     % hide both first
%     try app.PreviewAxes.Visible = 'off'; catch; end
%     try app.PreviewTextArea.Visible = 'off'; catch; end
% 
%     if ~isempty(app.outputImage)
%         app.PreviewTextArea.Visible = 'off';
%         app.PreviewAxes.Visible = 'on';
%         imshow(app.outputImage, 'Parent', app.PreviewAxes);
%         return;
%     end
% 
%     if ~isempty(app.outputText)
%         app.PreviewAxes.Visible = 'off';
%         app.PreviewTextArea.Visible = 'on';
%         % preview text as cellstr (TextArea expects cell or string array)
%         app.PreviewTextArea.Value = cellstr(app.outputText);
%         return;
%     end
% end
