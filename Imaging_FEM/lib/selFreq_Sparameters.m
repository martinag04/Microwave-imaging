%% v.1 30-06-2025 DR
% S0 is a sparameter object, N-port by N-port by N-frequencies
% selFreq is a frequecy in Hz
% S_sel is N-port by N-port, Sparameters in the selFreq
%%

function [S_sel,idx] = selFreq_Sparameters(S0,selFreq)

% Find the index of a value in a vector, allowing for numerical tolerance.
tol  = 1e-12;                         % Relative tolerance (adjust as needed)

% ismembertol does the fuzzy comparison
[isMem, idx] = ismembertol(selFreq, S0.Frequencies, tol);

if isMem
    fprintf('The frequency %.3e Hz is found at index %d (tol = %.1e).\n', selFreq, idx, tol);
else
    fprintf('The frequency %.3e Hz is not found within tolerance %.1e.\n', selFreq, tol);
end

S_sel = squeeze(S0.Parameters(:,:,idx));
end