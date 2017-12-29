function createLegend()

% colors
myRed  = [228 26 28] ./255;
myGreen = [77 175 74] ./255;
myGrey = [125 125 125] ./255;

% h = zeros(3,1);
figure
hold on
h(1) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed);
h(2) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen);
h(3) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGrey,'MarkerFaceColor',myGrey);
% h(1) = scatter(1,1,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed);
% h(2) = scatter(2,2,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen);
% h(3) = scatter(3,3,'o','filled','MarkerEdgeColor',myGrey,'MarkerFaceColor',myGrey);
axis off
legend(h,'No prior knowledge','With prior knowledge','NN with prior knowledge','Location','southwest');


end