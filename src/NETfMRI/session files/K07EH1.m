% K07EH1 - 23. Nov 16: fMRI+Neurophys (2 Shanks, AIC) in 7T
% SESSION: K07EH1
% EXPDATE:  23. Nov 16
% PROJECT:  NET-fMRI AIC
%
%==========================================================================
%
% NOTE:
%
%   - Insula-R, ele #3-Green, Dev 1, F2
%   - Insula-L, ele #4-green, Dev 2, F3
%   - Physiology, Dev 3
%
%   - Insula-R ele #3-Green (F3 amp)
%     Ele          1     2     3     4     5     6     7     8     9    10
%     kOhm         25    200   70    190   50    50    120   190   50   100
%     ADF                      4     5                 4           7
%     RecGain                  6     10                6           30      (fMRI)
%
%   - Insula-L ele #4-Green (F2 amp)
%     Ele          1     2     3     4     5     6     7     8     9    10
%     kOhm         170   160   160   150   240   110   320   160   320  200
%     ADF          1     1     2     5     1     2     4     1     1    7
%     RecGain      1     1     2     10    1     2     6     1     1    30 (fMRI)
%
%   - ADF 5-gradient
%
%
% AUTHOR: JS/CK 13.01.2020
%
%% ========================================================================
%   BASIC INFORMATION
%  ========================================================================

% Raw data directories & meta information
SYSP.DataMri   = '\\wks8\mridata_wks6';
SYSP.DataNeuro = SYSP.DataMri;
SYSP.dirname   = 'K07.EH1';
SYSP.date      = '23. Nov 16';

ARGS.StateIDX  = 0;
ARGS.Animal    = 'monkey';

% Common parameters
[ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = ingetpars('K07EH1', ARGS);

% Processed data directories
SYSP.matdir     = ANAP.project.datadir;
SYSP.DataMatlab = SYSP.matdir;
if isfield(ANAP.project, 'DataMri')
    SYSP.DataMri = ANAP.project.DataMri;
end

if isfield(ANAP.project, 'DataNeuro')
    SYSP.DataNeuro = ANAP.project.DataNeuro;
end

SYSP.VERSION = ANAP.SYSP.VERSION; % EACH SESSION GETS, and then we run sesconvert(SesName);
SYSP.VERSION = 2.0;

%% ========================================================================
%   DISPLAY OF ANATOMY SCANS
%  ========================================================================

% Anatomical parameters used by mview
ANAP.mview.anascale = [0 12000 1.5];
ANAP.mview.funscale = [-5 30];
ANAP.mview.alpha    = 0.01;
ANAP.mview.slices   = [];
ANAP.Quality        = -1; % Percent (all exps good activation)
ANAP.ImgDistort     =  0; % EPI-Anatomy can't be registered due2distortions

EPICROP = [1 1 128 128]; % cropping as [x y width height]
EPI2ANA =  2;

% Anatomy scan information
% Rare scan
ASCAN.rare{1}.info     = 'In-plane Anatomy';
ASCAN.rare{1}.scanreco = [29 1];
ASCAN.rare{1}.imgcrop  = [(EPICROP(1)-1)*EPI2ANA+1 (EPICROP(2)-1)*EPI2ANA+1 EPICROP(3:4)*EPI2ANA];

% Flash scan 
ASCAN.flash{1}.info     = 'Electrode (Coronal), AIC';
ASCAN.flash{1}.scanreco = [10 1];
ASCAN.flash{1}.imgcrop  = [];

% Display information
GRPP.ana                                      = {'rare'; 1; 2:2:40}; % inplane anatomy
GRPP.imgcrop                                  = EPICROP;
GRPP.condition                                = {'normal'};
GRPP.anap.mrhesusatlas2ana.permute            = [];
GRPP.anap.mrhesusatlas2ana.flipdim            = 2;
GRPP.anap.mrhesusatlas2ana.spm_coreg.cost_fun = 'nmi';
GRPP.anap.mrhesusatlas2ana.use_epi            = 0;
GRPP.anap.mana2brain.use_epi                  = 1; % COREG from session data into the template brain.

%% ========================================================================
%   GROUP INFORMATION
%  ========================================================================

% Channel/electrode information (empty space = channel wasn't working)
GRPP.daqver = 2.00;
GRPP.hardch = [1:4 6:15]; % electrode numbers for ADF_CHANNELs
GRPP.gradch = 5;
GRPP.namech = {                 'inR03' 'inR04'                 'inR07'         'inR09'         ...
                'inL01' 'inL02' 'inL03' 'inL04' 'inL05' 'inL06' 'inL07' 'inL08' 'inL09' 'inL10'};

GRPP.recgain = [          2    10             6         1      ...
                20   10   6    10   10   6    6    20   30   20];

GRPP.elekohm = [NaN  NaN  70   190  NaN  NaN  120  NaN  50   NaN ...
                170  160  160  150  240  110  320  160  220  200];

GRPP.anap.clnpar.METHOD                     = 'pca'; % faster singular values decomposition for pca
GRPP.anap.clnpar.HIGHPASS                   = 1;     % Cutoff freq for high pass (in Hz)
GRPP.anap.clnpar.USE_LANSVD                 = 1;
GRPP.anap.clnpar.PLOT                       = 1;     % save spectrum figures before/after cleaning
GRPP.anap.clnpar.DECFRAC                    = 2;     % originally in decmain.m, needs to be changed if smaplef from 20k to 15k

GRPP.anap.clnpar.AVR_NOISE                  = 'mean';  % faster singular values decomposition for pca
GRPP.anap.clnpar.NOPCS                      = 32;      % GRPP.anap.clnpar.METHOD      = 'regress';
GRPP.anap.clnpar.NOREM                      = 28;
GRPP.anap.clnpar.PCACOEF                    = 0.25;    % 0.25 standard value. Can be set to 0.15 to potentially improve.
GRPP.anap.clnpar.PCACOEF                    = 0.12;

% Spont group information
GRP.spont                            = GRPP;
GRP.spont.ana                        = {'rare'; 2; [2:2:40]}; % inplane anatomy
% GRP.spont.ana                               = {'rare'; 3; []};              % morphed anatomy
% GRP.spont.grproi                            = 'RoiGrp2';                    % use for the ROI map
GRP.spont.exps                       = 1:9;
GRP.spont.design                     = 'No stim';
GRP.spont.stminfo                    = 'spontaneous with fMRI 10 min';
GRP.spont.label                      = {'spont'};
GRP.spont.refgrp.grpexp              = 'spont';
GRP.spont.expinfo                    = {'imaging', 'recording'};
GRP.spont.anap.clnpar.HIGHPASS       = 1;    % Cutoff freq for high pass (in Hz)
GRP.spont.anap.mareats.IEXCLUDE      = {};   % {'brain'};
GRP.spont.anap.mareats.IREMBRAINMEAN = 0;    % Remove brain's average (phys artifacts)
GRP.spont.anap.mareats.IFILTER       = 1;    % 1 = to spatially filter; 0 = no filter at all; old 1
GRP.spont.anap.mareats.IFILTER_KSIZE = 3;    % Kernel size
GRP.spont.anap.mareats.IFILTER_SD    = 0.7;  % Kernel SD (90% of flt in kernel
GRP.spont.anap.mareats.ICUTOFFHIGH   = 0.01; % remove very slow oscillations
GRP.spont.anap.mareats.ICUTOFF       = 0.05;
GRP.spont.anap.mareats.INOTCH        = 0;    % Def: 4; Threshold for resp-art removal
GRP.spont.anap.mareats.ITOSDU        = 0;    % Normalization

%% ========================================================================
%   RUN INFORMATION
%  ========================================================================

for N = 1:9
    EXPP(N).physfile = sprintf('K07EH1_%03d.adfx', N);
    EXPP(N).scanreco = [N + 18 1];
end
