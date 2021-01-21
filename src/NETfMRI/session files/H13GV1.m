% H13GV1 - 10. Apr 17: fMRI+Neurophys (2 Shanks, AIC, Cortex) in 7T
% SESSION:  H13GV1
% EXPDATE:  10. Apr 17
% PROJECT:  NET-fMRI AIC
%==========================================================================
% NOTE:
%   - Physiology, Dev 1
%   - Cortex-R, ele #23-Red, Dev 2/1, F5
%   - Insula-L, ele #04-Green, Dev 2/2, F3
%   - Insula-R, ele #03-Green, Dev 3/1, F2
%   - Cortex-L, ele #13-Grey, Dev 3/2, F4
%
%   - Cortex-R ele #23-Red (F5 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm         170   230   150   210   180   160   160   160   150   140
%     ADF          5     5     5     5     4     5     4     4     4     4
%     RecGain      10    10    10    10    6     10    6     6     6     6 (fMRI)
%
%   - Insula-L ele #4-Green (F3 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm         140   140   90    120   30    20    130   110   30    150
%     ADF          3     3     2     2                 3     1           2
%     RecGain      3     3     2     2                 3     1           2 (fMRI)
%
%   - Insula-R ele #3-Green(F2 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm         160   140   90    140   90    160   140   110   140   180
%     ADF          3     1     1     2     1     2     2     1     2     2
%     RecGain      3     1     1     2     1     2     2     1     2     2 (fMRI)
%
%   - Cortex-L ele #13-Grey (F4 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm         130   120   100   130   120   140   130   140   110   140
%     ADF          3     3     3     3     3     3     2     3     3     4
%     RecGain      3     3     3     3     3     3     2     3     3     6  (fMRI)
%
%   - ADF 32-gradient
%
%
% AUTHOR: JS/CK, 13.01.2020
%
%% ========================================================================
%   BASIC INFORMATION
%  ========================================================================

% Raw data directories & meta information
SYSP.DataMri        = '\\wks8\mridata_wks6';
SYSP.DataNeuro      = SYSP.DataMri;
SYSP.dirname        = 'H13.GV1';
SYSP.date           = '10. Apr 17';

ARGS.StateIDX       = 0;
ARGS.Animal         = 'monkey';

% Common parameters
[ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = ingetpars('H13GV1',ARGS);

% Processed data directories
SYSP.matdir         = ANAP.project.datadir;
SYSP.DataMatlab     = SYSP.matdir;
    if isfield(ANAP.project,'DataMri')
      SYSP.DataMri      = ANAP.project.DataMri;
    end
    
    if isfield(ANAP.project,'DataNeuro')
      SYSP.DataNeuro    = ANAP.project.DataNeuro;
    end

SYSP.VERSION        = ANAP.SYSP.VERSION; % EACH SESSION GETS, and then we run sesconvert(SesName);
SYSP.VERSION        = 2.0;

%% ========================================================================
%   DISPLAY OF ANATOMY SCANS
%  ========================================================================

% Anatomical parameters used by mview
ANAP.mview.anascale         = [0 12000 1.5];
ANAP.mview.funscale         = [-5 30];
ANAP.mview.alpha            = 0.01;
ANAP.mview.slices           = [];
ANAP.Quality                = -1; % Percent (all exps good activation)
ANAP.ImgDistort             =  0;  % EPI-Anatomy can't be registered due2distortions

EPICROP                     = [1 1 128 128]; % cropping as [x y width height]
EPI2ANA                     =  2;

% Anatomy scan information
% Rare scan
ASCAN.rare{1}.info          = 'In-plane Anatomy';
ASCAN.rare{1}.scanreco      = [13 1];
ASCAN.rare{1}.imgcrop       = [(EPICROP(1)-1)*EPI2ANA+1 (EPICROP(2)-1)*EPI2ANA+1 EPICROP(3:4)*EPI2ANA];

% Flash scan 
ASCAN.flash{1}.info          = 'Electrode (Coronal), AIC';
ASCAN.flash{1}.scanreco      = [14 1];
ASCAN.flash{1}.imgcrop       = [];

% Display information
GRPP.ana                                        = {'rare'; 1; 2:2:40}; % inplane anatomy
GRPP.imgcrop                                    = EPICROP;
GRPP.condition                                  = {'normal'};
GRPP.anap.mrhesusatlas2ana.permute              = [];
GRPP.anap.mrhesusatlas2ana.flipdim              = 2;
GRPP.anap.mrhesusatlas2ana.spm_coreg.cost_fun   = 'nmi';
GRPP.anap.mrhesusatlas2ana.use_epi              = 0;
GRPP.anap.mana2brain.use_epi                    = 1;  % COREG from session data into the template brain.


%% ========================================================================
%   GROUP INFORMATION
%  ========================================================================

% Channel/electrode information (empty space = channel wasn't working)
GRPP.daqver        = 2.00;
GRPP.hardch        = [17:26, 33:36, 39:40, 42, 49:58, 65:74]; % electrode numbers for ADF_CHANNELs 
GRPP.gradch        = 31;
GRPP.namech        = { 'corR01'  'corR02'  'corR03'  'corR04' 'corR05' 'corR06' 'corR07' 'corR08' 'corR09' 'corR10'...
                       'insL01'  'insL02'  'insL03'  'insL04'                   'insL07' 'insL08'          'insL10'...
                       'insR01'  'insR02'  'insR03'  'insR04' 'insR05' 'insR06' 'insR07' 'insR08' 'insR09' 'insR10'...
                       'corL01'  'corL02'  'corL03'  'corL04' 'corL05' 'corL06' 'corL07' 'corL08' 'corL09' 'corL10'};

GRPP.recgain       = [ 10    10    10    10    6     10    6     6     6     6 ...
                       3     3     2     2                 3     1           2 ...
                       3     1     1     2     1     2     2     1     2     2 ...
                       3     3     3     3     3     3     2     3     3     6];

GRPP.elekohm       = [  170   230   150   210   180   160   160   160   150   140 ...
                        140   140   90    120   30    20    130   110   30    150 ...
                        160   140   90    140   90    160   140   110   140   180 ...
                        130   120   100   130   120   140   130   140   110   140];
                                      
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
GRP.spont                                   = GRPP;
GRP.spont.ana                               = {'rare'; 2; [2:2:40]}; % inplane anatomy
% GRP.spont.ana                               = {'rare'; 3; []};     % morphed anatomy
% GRP.spont.grproi                            = 'RoiGrp2';           % use for the ROI map
GRP.spont.exps                              = 1:52;
GRP.spont.design                            = 'No stim';
GRP.spont.stminfo                           = 'spontaneous with fMRI 10 min';
GRP.spont.label                             = {'spont'};
GRP.spont.refgrp.grpexp                     = 'spont';
GRP.spont.expinfo                           = {'imaging','recording'};
GRP.spont.anap.clnpar.HIGHPASS              = 1;    % Cutoff freq for high pass (in Hz)
GRP.spont.anap.mareats.IEXCLUDE             = {};   % {'brain'};
GRP.spont.anap.mareats.IREMBRAINMEAN        = 0;    % Remove brain's average (phys artifacts)
GRP.spont.anap.mareats.IFILTER              = 1;    % 1 = to spatially filter; 0 = no filter at all; old 1
GRP.spont.anap.mareats.IFILTER_KSIZE        = 3;    % Kernel size
GRP.spont.anap.mareats.IFILTER_SD           = 0.7;  % Kernel SD (90% of flt in kernel
GRP.spont.anap.mareats.ICUTOFFHIGH          = 0.01; % remove very slow oscillations
GRP.spont.anap.mareats.ICUTOFF              = 0.05;
GRP.spont.anap.mareats.INOTCH               = 0;    % Def: 4; Threshold for resp-art removal
GRP.spont.anap.mareats.ITOSDU               = 0;    % Normalization

%% ========================================================================
%   RUN INFORMATION
%  ========================================================================

NETfMRI_runs                                = 28:103;
ind                                         = zeros(1,length(NETfMRI_runs));
distension_runs                             = sort([45, 46, 4:4:76]);
ind(distension_runs)                        = 1;
distension_runs                             = NETfMRI_runs(logical(ind));
NETfMRI_runs                                = NETfMRI_runs(ind~= 1);

    % NET fMRI runs
for N = 1:length(NETfMRI_runs)
  EXPP(N).physfile = sprintf('H13_GV1_%03d.adfx',NETfMRI_runs(N)-26);
  EXPP(N).scanreco = [NETfMRI_runs(N) 2];
end
