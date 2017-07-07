% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                         %
%              The p53 network model by Hat et al. (2016).                %
%                                                                         %
%  This file contains only plotting commands and is intended to be used   %
%  by the main simulation script using the complete p53 network model.    %
%                                                                         %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function make_plots(T,Y)

figure

t_before_IR = 10;  % [h]
time_range = [-t_before_IR  max(T)];  % horizontal axis range
time_label = 'Time [h]';

plot_vars = {{'DNA DSB', 1} ; ...
             {'ATM_p',   2} ; ...
             {'Wip1',   15} ; ...
             {'PTEN',   17} ; ...
             {'AKT_p',  19} ; ...
             {'p21',    21} ; ...
             {'p53_{arrester}',6} ; ...
             {'p53_{killer}',  8} ; ...
             {'Mdm2_{cyt,tot}',[10 11]} ; ...
             {'Mdm2_{nuc,tot}',[12 13]} ; ...
             {'Cyclin E', 24} ; ...
             {'Caspase',  33}};
        
for i = 1:length(plot_vars)
  subplot(3,4,i)
  plot(T,sum(Y(:,plot_vars{i}{2}),2), 'r', 'LineWidth',2);
  xlim(time_range);
  title(plot_vars{i}{1})
  xlabel(time_label);
end

global IR_Gy;
annotation('textbox',[0.0 0.9 1 0.1], 'EdgeColor','none',...
           'String',sprintf('\\fontsize{12} IR = %.2f Gy ',IR_Gy),...
           'HorizontalAlignment','center');

end
