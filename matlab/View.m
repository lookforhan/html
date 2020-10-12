classdef View < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        BalanceEditFieldLabel  matlab.ui.control.Label
        ViewBalance            matlab.ui.control.NumericEditField
        RMBEditFieldLabel      matlab.ui.control.Label
        ViewRMB                matlab.ui.control.NumericEditField
        WithDrawButton         matlab.ui.control.Button
        DepositButton          matlab.ui.control.Button
    end

    
    properties (Access = private)
        Balance double % ��
    end
    
    properties (Access = public)
        controlObj % Control (2)
        modelObj   % Model   (2)
    end
    
  
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.controlObj = Controller(app,app.modelObj); % (3)
            app.attatchToController(app.controlObj);       % (3)
          
            app.modelObj.addlistener('balanceChanged',@app.updateBalance);    % (4)
        end
        
    end

    % Component initialization
    methods (Access = private)
        function attatchToController(app,controller) % (5)
            funcH = @controller.callback_withDrawButton;
            addlistener(app.WithDrawButton,'ButtonPushed',funcH)
            
            funcH = @controller.callback_depositButton;
            addlistener(app.DepositButton,'ButtonPushed',funcH)
        end
        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 233 173];
            app.UIFigure.Name = 'MATLAB App';

            % Create BalanceEditFieldLabel
            app.BalanceEditFieldLabel = uilabel(app.UIFigure);
            app.BalanceEditFieldLabel.HorizontalAlignment = 'right';
            app.BalanceEditFieldLabel.Position = [40 125 49 22];
            app.BalanceEditFieldLabel.Text = 'Balance';

            % Create ViewBalance
            app.ViewBalance = uieditfield(app.UIFigure, 'numeric');
            app.ViewBalance.Position = [104 125 100 22];

            % Create RMBEditFieldLabel
            app.RMBEditFieldLabel = uilabel(app.UIFigure);
            app.RMBEditFieldLabel.HorizontalAlignment = 'right';
            app.RMBEditFieldLabel.Position = [40 79 32 22];
            app.RMBEditFieldLabel.Text = 'RMB';

            % Create ViewRMB
            app.ViewRMB = uieditfield(app.UIFigure, 'numeric');
            app.ViewRMB.Position = [104 79 100 22];

            % Create WithDrawButton
            app.WithDrawButton = uibutton(app.UIFigure, 'push');
            app.WithDrawButton.Position = [38.5 30 68 22];
            app.WithDrawButton.Text = 'WithDraw';

            % Create DepositButton
            app.DepositButton = uibutton(app.UIFigure, 'push');
            app.DepositButton.Position = [139 30 65 22];
            app.DepositButton.Text = 'Deposit';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = View(modelObj)
            app.modelObj = modelObj;   %(6)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)
            app.updateBalance

            if nargout == 0
                clear app
            end
        end
        function updateBalance(app,src,data)           % (7)
            app.ViewBalance.Value = app.modelObj.balance;
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end