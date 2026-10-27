function dataProjection_CAL = artifactRemoval(dataProjection)
%% Averaging
data_avg = mean(dataProjection,2);

%% Realization of the masks
m1 = max(abs(dataProjection(:,1)));
m2 = max(abs(dataProjection(:,2)));

data_Nmag1 = abs(dataProjection(:,1))/m1;
data_Nmag2 = abs(dataProjection(:,2))/m2;

data_Nmag = data_Nmag1 .* data_Nmag2;

dataProjection_CAL = data_avg.*data_Nmag;
end