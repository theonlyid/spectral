function [ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = rpgetpars(SesName, ARGS)
%RPGETPARS - Defines Common Parameters for the NET-fMRI Project
% [ANAP, ROI, GRPP] = rpgetpars(SesName) is called from within each description file to set
% the basic parameters that are used by all sessions. For a detailed description of the
% analysis procedure see RPANA.M
%
% NKL 06.01.2011
% NKL 31.03.2013
%  
% See also RPGETPARS_MONKEY, RPGETPARS_RAT, RPANA
  
% ----------------------------------------------------------------------------------------
% GLOBAL DEFINITIONS FOR ALL SESSIONS, E.G. DIRECTORIES, MODELS, ETC.
% ----------------------------------------------------------------------------------------
ANAP.ClusterMode = 0;          % When using the office-cluster
DIRS = getdirs;  % Our directory structure
switch lower(DIRS.HOSTNAME)
 case {'nb-nikos' 'nb-nikos-travel' 'workbook-nikos' 'ultrabook-nikos'}
  ANAP.ClusterMode = 0;
 case {'win447' 'node4' 'node5' 'node6'}
  ANAP.ClusterMode = 0;
end

if ANAP.ClusterMode,
  DRV = '\\nkldata\YDISK';                  % All data are on the cluster disk
elseif exist('y:/','dir'),
  DRV = 'Y:/';
elseif strcmpi(DIRS.HOSTNAME,'ultrabook-nikos') | strcmpi(DIRS.HOSTNAME,'nb-nikos'),
  DRV = 'F:/';
else
  DRV = 'D:/';
end;

ANAP.project.GlobalDir      = fullfile(DRV,'Global/Ripples');
ANAP.project.imagefile      = fullfile(DRV,'Global/Anatomy/rathead16T.img');
ANAP.project.atlasfile      = fullfile(DRV,'GlobalAnatomy/rathead16T_AtlasROIs.mat');
ANAP.project.elesite        = fullfile(DRV,'Projects/Anatomy/RatEleSites');
ANAP.project.flicker_dir    = fullfile(DRV,'Global/Flicker');
ANAP.project.estim_dir      = fullfile(DRV,'Global/DES');
ANAP.project.datadir        = fullfile(DRV,'DataMatlab/');
ANAP.project.datadir        = fullfile(DRV,'DataInsula/');
ANAP.project.atlas.ds       = [0.1 0.1 0.1];
ANAP.project.atlas.bregma   = [147 134 36]; % AP, ML, DV coordinates of Bregma
ANAP.project.ExpList        = 'selected';   % Option(1) = 'original'; used by description files

% FOR TESTING CLUSTER MACHINES...
%ANAP.project.datadir        = fullfile(DRV,'DataTestCluster/');

% Directory of Raw Data for "Cluster" machines.
if any(ANAP.ClusterMode),
  ANAP.project.DataMri =   '//nkldata/DataRawHipp/';
  ANAP.project.DataNeuro = '//nkldata/DataRawHipp/';
end

if ~nargin, ANAP = ANAP.project.GlobalDir; return; end;

FILE_SAVING_UPDATE = 'OLD_FILE_SYSTEM_BEFORE_03-Jul-2012';
if strcmp(FILE_SAVING_UPDATE,'OLD_FILE_SYSTEM_BEFORE_03-Jul-2012'),
  ANAP.SYSP.VERSION = 1.0;  % 1:old version, 2:new since Feb.2012
else
  ANAP.SYSP.VERSION = 2.0;
end;

% CALL-MODES...
% info = rpgetpars([],'rat');
% info = rpgetpars([],'monkey');

if isempty(SesName) & nargin > 1,
  Animal = ARGS;
  clear ARGS;
  ARGS.Animal = Animal;
else
  if nargin < 2,
    ARGS.Animal = 'rat';
  end;
  if ~isfield(ARGS,'Animal'),
    ARGS.Animal = 'rat';
  end;
end;

if ~isfield(ARGS,'glmdesign'),
  % SET THIS IN THE DESCRIPTION FILE FOR RUNNING SEED-fMRI
  % ATTENTION - Here we must find a group-based definition....!! Because the very same
  % sesssion may have groups for NET and groups for Seed-fMRI
  ARGS.glmdesign = 'siggamrip';
end;

switch ARGS.Animal,
 case {'monkey','alert_monkey'},
  ANAP.project.datadir = fullfile(DRV,'DataInsula/');
  [ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = ingetpars_monkey(SesName, ANAP, ARGS);
 case 'rat',
  ANAP.project.datadir = fullfile(DRV,'DataInsula/');
  [ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = ingetpars_rat(SesName, ANAP, ARGS);
 otherwise,
  fprintf('Unknown animal-type!\n');
  keyboard;
end;
return;



