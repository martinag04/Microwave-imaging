%% v.1 03-06-2025 DR and ChatGPT.03 

function mask = loadMask(maskName, loadFlag)
%LOADMASK  Conditionally load a vector called "mask" from a MAT-file.
%
%   mask = LOADMASK(maskName)              loads maskName.mat only when a
%   variable called "mask" is NOT already present in the caller workspace.
%
%   mask = LOADMASK(maskName, loadFlag)    if loadFlag is true, the file is
%   (re)loaded even when "mask" already exists.
%
%   Inputs
%   ------
%   maskName : char | string
%              Base filename (without ".mat") that stores a vector "mask".
%   loadFlag : logical (optional, default = false)
%              true  → force reload
%              false → skip when the variable already exists
%
%   Output
%   ------
%   mask     : vector loaded (or retrieved) from the caller workspace.
%
%   Example
%   -------
%       m = loadMask('mask_brain_65');      % load only if needed
%       m = loadMask('mask_brain_65',true); % force reload
%

% -------- arguments & file existence ------------------------------------
arguments
    maskName (1,:) char
    loadFlag (1,1) logical = false
end
fileMask = ['lib\' maskName '.mat'];
if ~isfile(fileMask)
    error('File "%s" not found.', fileMask);
end

% -------- does "mask" already exist in caller workspace? ----------------
maskExists = evalin('caller','exist(''mask'',''var'')');

if loadFlag || ~maskExists
    load(fileMask,'mask');                 % load into this function
    assignin('caller','mask',mask);        % push to caller
    fprintf('[loadMask] Loaded mask from "%s".\n', fileMask);
else
    fprintf('[loadMask] mask already in workspace — no reload performed.\n');
    mask = evalin('caller','mask');        % fetch existing variable
end
end
