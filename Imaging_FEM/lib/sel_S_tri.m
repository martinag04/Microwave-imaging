%% v.1 03-06-2025 DR
% It needs the itriu function
% S0_sf is a N-port by N-port scattering matrix
% Stri is an xtructure with:
% triUpper_wDiag
% triLower_wDiag
% triUpper_woDiag
% Lower_woDiag
%%%%%%%%%%%%%%%%%%%


function [STri,MaskTri] = sel_S_tri(S0_sf)
%% w diag
wI = itriu(size(S0_sf));
%[row,col] = ind2sub([nAntennas nAntennas],wI);
Mask_triUpper_wDiag = zeros(size(S0_sf));
Mask_triUpper_wDiag(wI) = 1;
Mask_triLower_wDiag = Mask_triUpper_wDiag'; 
%% wo diag
woI = itriu(size(S0_sf),1);
Mask_triUpper_woDiag = zeros(size(S0_sf));
Mask_triUpper_woDiag(woI) = 1;
Mask_triLower_woDiag = Mask_triUpper_woDiag';
%%
MaskTri.Upper_wDiag = Mask_triUpper_wDiag;
MaskTri.Lower_wDiag = Mask_triLower_wDiag;
MaskTri.Upper_woDiag = Mask_triUpper_woDiag;
MaskTri.Lower_woDiag = Mask_triLower_woDiag;
%%
STri.Upper_wDiag = S0_sf(wI);
STri.Lower_wDiag = S0_sf(logical(Mask_triLower_wDiag));

STri.Upper_woDiag = S0_sf(woI);
STri.Lower_woDiag = S0_sf(logical(Mask_triLower_woDiag));

Aux = zeros(size(S0_sf));
Aux(logical(Mask_triLower_woDiag)) = STri.Lower_woDiag;
Aux = Aux.';
STri.Lower_woDiag2image = Aux(woI); %This has the lower part matrix remapped to the upper part

Aux2 = zeros(size(S0_sf));
Aux2(logical(Mask_triLower_wDiag)) = STri.Lower_wDiag;
Aux2 = Aux2.';
STri.Lower_wDiag2image = Aux2(wI); %This has the lower part matrix remapped to the upper part


end