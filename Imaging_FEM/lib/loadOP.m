%% v.1 03-06-2025 DR and ChatGPT.03 


function Operator = loadOP(nameOP, loadFlag)
%LOADOP  Load / refresh Operator; embed qxyz, volVoxel; keep workspace tidy.
%
%   OP = LOADOP(NAMEOP)              loads NAMEOP.mat only if needed:
%       •  If Operator is missing, loads Operator, qxyz, volVoxel.
%       •  If Operator exists but lacks qxyz or volVoxel fields, loads just
%          the missing pieces and adds them into Operator.
%
%   OP = LOADOP(NAMEOP, LOADFLAG)    with LOADFLAG==true forces a full
%   reload (Operator, qxyz, volVoxel) even if everything is present.
%
%   After loading, OP contains the extra fields
%       qxyz, volVoxel, X, Y, Z   (X/Y/Z are 3-D grids in mm).
%
%   NOTE: The workspace variables qxyz and volVoxel are cleared (or never
%   introduced), so they reside only inside Operator.
%
%   Example
%   -------
%       Op = loadOP('myOp');        % load only what is missing
%       Op = loadOP('myOp',true);   % force full reload
%

% -------- arguments & file check ----------------------------------------
arguments
    nameOP   (1,:) char
    loadFlag (1,1) logical = false
end
fileOP = [nameOP '.mat'];
if ~isfile(fileOP)
    error('File "%s" not found.', fileOP);
end

% -------- does Operator already exist? ----------------------------------
opExists = evalin('caller','exist(''Operator'',''var'')');

if opExists
    Operator = evalin('caller','Operator');
else
    Operator = [];     
end

% -------- check if qxyz / volVoxel are inside Operator ------------------
hasQ   = opExists && isfield(Operator,'qxyz');
hasVol = opExists && isfield(Operator,'volVoxel');

% -------- decide what to load -------------------------------------------
loadOpVar   = loadFlag || ~opExists;
loadQVar    = loadFlag || ~hasQ;
loadVolVar  = loadFlag || ~hasVol;

varsToLoad = {};
if loadOpVar,  varsToLoad{end+1} = 'Operator'; end
if loadQVar,   varsToLoad{end+1} = 'qxyz';     end
if loadVolVar, varsToLoad{end+1} = 'volVoxel'; end

if ~isempty(varsToLoad)
    s = load(fileOP, varsToLoad{:});
    
    % Merge/overwrite as requested
    if isfield(s,'Operator'), Operator = s.Operator; end
    if isfield(s,'qxyz'),     Operator.qxyz = s.qxyz;     end
    if isfield(s,'volVoxel'), Operator.volVoxel = s.volVoxel; end
    
    fprintf('[loadOP] Loaded %s from "%s".\n', ...
            strjoin(fieldnames(s),', '), fileOP);
else
    fprintf('[loadOP] Operator already in workspace — no reload performed.\n');
end

% -------- sanity check ---------------------------------------------------
if ~isfield(Operator,'qxyz') || ~isfield(Operator,'volVoxel')
    error('Operator structure still lacks qxyz or volVoxel after loading.');
end

% -------- build X/Y/Z grids ---------------------------------------------
qxyz = Operator.qxyz;
nMesh = uint8(round(length(qxyz)^(1/3)));            % cubic mesh size

Operator.X = reshape(qxyz(:,1), nMesh, nMesh, nMesh) * 1000;  % [mm]
Operator.Y = reshape(qxyz(:,2), nMesh, nMesh, nMesh) * 1000;
Operator.Z = reshape(qxyz(:,3), nMesh, nMesh, nMesh) * 1000;

% -------- put updated Operator into caller ------------------------------
assignin('caller','Operator',Operator);

% -------- ensure qxyz / volVoxel not left outside -----------------------
evalin('caller','clear qxyz volVoxel');

end
