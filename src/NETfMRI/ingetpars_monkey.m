function [ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = rpgetpars_monkey(SesName, ANAP, ARGS)
%RPGETPARS_MONKEY - Global structures and parameters of the monkey NET-fMRI experiments
%
% NKL 13.10.2013

%      strcmpi(DIRS.HOSTNAME,'workbook-nikos') | strcmpi(DIRS.HOSTNAME,'ultrabook-nikos'),

DIRS = getdirs;
if  strcmpi(DIRS.HOSTNAME,'workbook-nikos'),
  ANAP.ClusterMode = 0;
  ANAP.project.datadir = 'Ext.DataDisk\DataHipp\'; %%% ??????????????
  ANAP.project.datadir = 'D:\DataMatlab\';
end;
  
ANAP.clnpar.HIGHPASS   = 4;  % Cutoff freq for high pass (in Hz)
ANAP.clnpar.LOWRECOVER = 1;  % Recover low-freq componet(s) removed by any highpass.
ANAP.clnpar.OUTLIERS   = 0;  % Set if check for outliers is desired
ANAP.clnpar.REMOVE_ECG = 0;  % try to remove hear-beat artifact

%=========================================================================================
% BLP EXTRACTION
%=========================================================================================
% UDS(Up-Down States) - Freq [0.5- 1.0Hz], Steriade-work, recent, e.g. Mayank etc.
% KCOMPLEX w/ frequency [2-6Hz], periodic occurrence 0.5 to 0.7 Hz (0.5 seconds
% duration). Rodents show 6–10 Hz theta oscillations (Vanderwolf, 1969), whereas these
% oscillations are 4–6 Hz in carnivores (Grastyan et al., 1959; Arnolds et al., 1979). Out of
% all investigated species, humans have the slowest theta frequency (1–4 Hz; Arnolds et al.,
% 1980; Kahana et al., 2001).
% THETA  Monkeys (3-11Hz), Rats (4-7Hz)
% [ 3 - 12 Hz]  Jutras, Fries and Buffalo & Killian-Buffalo define "Theta" in the range of 3-12 Hz
% [ 4 -  7 Hz]  Tsujimoto, Shimazu, Isomura, see review of Schachter, 1977 (Human-theta)
% [ 7 -  9 Hz]  Stewart & Fox 1991, 
% [ 2 -  6 Hz]  Low-Theta: Moise & Costin, 1974 (Hippocampus) Low-theta [2-6 Hz]
% [ 6 - 10 Hz]  High-Theta: Moise & Costin, 1974 (Hippocampus) Low-theta [2-6 Hz]
% [ 6 -  9 Hz]  Brian BLand 1986, 
% SPINDLES   Monkeys (10-15Hz), Rats (11-16Hz)
% [ 7 - 14 Hz] Ushimaru, Phys
% [09 - 15 Hz] Fried, Nirs, Tononi, … Intracrianl EEG, fast spindles [13-15 Hz].
% [10 - 15 Hz] Buzsaki, Phys
% [11 - 15 Hz] Florian Holsboer EEG (11-13 slow; 13-15 fast spindles)
% [11 - 15 Hz] Maquet, fMRI Study
% [12 - 15 Hz] Steriade, Phys
% [12 - 15 Hz] Luba-Sara-Born, Phys
% [10 - 16 Hz] Dehghani, Cash, Halgren, 2011
% [10 - 16 Hz] Achermann, Brain 2001
% [10 - 16 Hz] Tononi, EEG
% [11 - 16 Hz] Born, Phys; Foramen Ovale Electrodes
% ----------------------------
% EVENTS(KComplex Spindle, Duration 0.5 & 1 sec, in freq-range [1 4] [11 13] Hz)
% PARS(Low frequency cutoffs = [2 10] Hz, minw = 0.3-0.5 second)
% ----------------------------
% EVENTS(KComplex Spindle, Duration 0.5 & 1 sec, in freq-range [1 4] [11 13] Hz)
% PARS(Low frequency cutoffs = [2 10] Hz, minw = 0.3-0.5 second)
 
ANAP.siggetblp.NewFs    = 660;
ANAP.siggetblp.lcutoff  = 660;
ANAP.siggetblp.conv2sdu = 0;        % Before 13.03.2014 ANAP.siggetblp.conv2sdu = 0;
ANAP.siggetblp.detrend  = 1;

% COMPARISON - BLPs IN RATS
% ANAP.siggetblp.band{ 1} = {[   0.00   325.0] 'cln'     'LFP', 0};   % Cln (low res)
% ANAP.siggetblp.band{ 2} = {[   0.05     3.0] 'delta'   'LFP', 0};   % Standard EEG...
% ANAP.siggetblp.band{ 3} = {[   3.10     8.0] 'theta'   'LFP', 3};   % Alpha 8-13Hz !!
% ANAP.siggetblp.band{ 4} = {[   8.50    15.0] 'spindle' 'LFP', 4};   % Spindles.. 10-18Hz!!
% ANAP.siggetblp.band{ 5} = {[  16.00    29.0] 'sigma'   'LFP', 5};   % Also Beta 13-30Hz!!
% ANAP.siggetblp.band{ 6} = {[  30.00    80.0] 'gamma'   'LFP', 20};
% ANAP.siggetblp.band{ 7} = {[  81.00   129.0] 'hgamma'  'LFP', 20};
% ANAP.siggetblp.band{ 8} = {[ 130.00   250.0] 'ripple'  'LFP', 30};
% ANAP.siggetblp.band{ 9} = {[ 251.00   324.0] 'hfo'     'LFP', 30};
% ANAP.siggetblp.band{10} = {[ 325.00   800.0] 'mefp'    'MUA', 100};
% ANAP.siggetblp.band{11} = {[ 801.00  3000.0] 'mua'     'MUA', 60};         % MB 06.05.2014 for SpkCoh
% ANAP.siggetblp.lBands   = [1:9];          % Bands in the LFP range
% ANAP.siggetblp.mBands   = [10 11];        % mEFP and MUA Bands
% ANAP.siggetblp.despike  = 0;              % 0|1 to despike or not

ANAP.siggetblp.band{ 1} = {[   0.00   325.0] 'cln'     'LFP', 0};   % Cln (low res)
ANAP.siggetblp.band{ 2} = {[   0.05     3.0] 'delta'   'LFP', 0};   % Standard EEG...
ANAP.siggetblp.band{ 3} = {[   3.50     8.0] 'theta'   'LFP', 3};   % Alpha 8-13Hz !!
ANAP.siggetblp.band{ 4} = {[   9.00    15.0] 'spindle' 'LFP', 4};   % Spindles.. 10-18Hz!!
ANAP.siggetblp.band{ 5} = {[  16.00    29.0] 'sigma'   'LFP', 5};   % Also Beta 13-30Hz!!
ANAP.siggetblp.band{ 6} = {[  29.00    55.0] 'gamma'   'LFP', 20};
ANAP.siggetblp.band{ 7} = {[  56.00    79.0] 'hgamma'  'LFP', 20};
ANAP.siggetblp.band{ 8} = {[  80.00   200.0] 'ripple'  'LFP', 30};
ANAP.siggetblp.band{ 9} = {[ 201.00   324.0] 'hfo'     'LFP', 30};
ANAP.siggetblp.band{10} = {[ 325.00   800.0] 'mefp'    'MUA', 100};
ANAP.siggetblp.band{11} = {[ 801.00  2000.0] 'mua'     'MUA', 200}; % MB 06.05.2014 for SpkCoh
ANAP.siggetblp.lBands   = [1:9];            % Bands in the LFP range
ANAP.siggetblp.mBands   = [10 11];          % mEFP and MUA Bands
ANAP.siggetblp.despike  = 0;                % 0|1 to despike or not

for N=1:length(ANAP.siggetblp.band),
  range = sprintf('%.0f %.0f', ANAP.siggetblp.band{N}{1});
  txt = sprintf('%s(%s)/%d', ANAP.siggetblp.band{N}{2},range,ANAP.siggetblp.band{N}{4});
  ANAP.siggetblp.blpinfo{N} = txt;
end;

ANAP.eeg.siggetblp.conv2sdu = 0;
ANAP.eeg.siggetblp.NewFs    = 660;
ANAP.eeg.siggetblp.lcutoff  = 660;
ANAP.eeg.siggetblp.band{ 1} = {[   0    300] 'cln'    'LFP',  0};
ANAP.eeg.siggetblp.band{ 2} = {[   0.2    4] 'delta'  'LFP',  2};
ANAP.eeg.siggetblp.band{ 3} = {[   5     10] 'theta'  'LFP',  2};
ANAP.eeg.siggetblp.band{ 4} = {[  11     22] 'sigma'  'LFP',  2};
ANAP.eeg.siggetblp.band{ 5} = {[  25     75] 'gamma'  'LFP', 20};
ANAP.eeg.siggetblp.band{ 6} = {[  80    160] 'ripple' 'LFP', 20};
ANAP.eeg.siggetblp.band{ 7} = {[ 800   1200] 'mefp'   'MUA', 50};
ANAP.eeg.siggetblp.decimate = 4;
ANAP.eeg.siggetblp.despike  = 0;                % 0|1 to despike or not


%=========================================================================================
% VIEWBANDS parameters for viewband-display
%=========================================================================================
% ATTENTION The "Event" menu selects the "event" to be shown
%           The menu below the "Event" selects the "jump" from event-to-event. The latter
%           can be the one selected in the Event-Menu, or any other event.  So, one can
%           select to see (vertical line) spindles, every time one moves from one "ripple"
%           to another(!).
ANAP.viewbands.band = {};
% {NAME, DEC, FILTERHZ, NORMALIZE, ENVELOPE, YSCALE, RGB, RGB,RGB)}
% These are the ONLY signals you will be observing with the program
% NOTE(NKL_YM): The definition of bands can be ARBITRARY. Different BANDS can be associcated
% to different recording sites (channels), but setting .site_band (see below)
ANAP.viewbands.band{end+1}  = {'ripple',   8, [ 81 190], 'zscore', 1,1,[0 0 0],[1 0 0],[1 .93 .93]};
ANAP.viewbands.band{end+1}  = {'sigma',   12, [ 11  28], 'zscore', 1,1,[0 0 0],[0.4 0 1],[1 .93  1 ]};
ANAP.viewbands.band{end+1}  = {'hfo',      8, [ 70 300], 'zscore', 1,1,[0 0 0],[1 0 1],[1 .93 .93]};
ANAP.viewbands.band{end+1}  = {'spindle', 12, [ 13  16], 'zscore', 1,1,[0 0 0],[.4 0 .4],[1 .93  1 ]};

% The CHAN selects the "channels" to display (each will have ripple-spindle)
ANAP.viewbands.chan         = {'pl'};
ANAP.viewbands.site_average = 1;        % IF YOU SET THIS =1, WILL SHOW THE AVERAGE OF EACH CHAN
ANAP.viewbands.tepoch       = 4;
ANAP.viewbands.site_band    = {};       % Selects between "ripple" and "spindle" (in this case)
ANAP.viewbands.site_band{1} = {'pl'   {'sigma',   'ripple'}   };
ANAP.viewbands.site_band{2} = {'lgn'  {'spindle', 'hfo'   }   };

%=========================================================================================
% SPIKE EXTRACTION -----------------------------------------------------------------------
%=========================================================================================
% YM USE a spike threshold of 3.0
% If .spkselect is set, then ...  sesgetspk() will do spike selection by the Michel-Method
%     Spkt.times is updated while keeping the original as Spkt.times_spkcdt.
% If .despike is set as 'selected' then sesgetblp() removes only selected spikes
% If .despike is 1, removes all spikes (without selection).
ANAP.siggetspk.highpassHz   = 1000;         % DO NOT USE lower cutoff; it peaks mEFP
ANAP.siggetspk.conv2sdu     = 0;            % No normalization - direct spike-count
ANAP.siggetspk.binwidth     = 0.025;        % 10ms binwidth for peristimulus histograms
ANAP.siggetspk.sdfrate      = ANAP.siggetblp.NewFs;  % Resampling rate for SDF
ANAP.siggetspk.sdfkernel    = 0.010;        % 5ms X 3 (SD) X 2 = kernel size
ANAP.siggetspk.threshold    = 3.0;          % Threshold for spike selection
ANAP.siggetspk.base_period  = 'blank';      
ANAP.siggetspk.spkselect    = 0;            % runs spike selection.

%=========================================================================================
% GENERAL PHYSIOLOGY/FMRI PARAMETES ------------------------------------------------------
%=========================================================================================
ANAP.aval       = 0.5;      % p-value for selecting time series
ANAP.rval       = 0.05;     % r (Pearson) coeff. for selecting time series
ANAP.shift      = 0;        % nlags for xcor in seconds
ANAP.clustering = 1;        % apply clustering after voxel-selection
ANAP.bonferroni = 0;        % Correction for multiple comparisons

GRPP.expinfo    = {'imaging','recording'};
GRPP.daqver     = 2.00;		% DAQ program version: 2=nl+ym; 1=nl;
GRPP.hwinfo     = '';		% hardware info
GRPP.hardch     = [1];	    % electrode numbers for ADF_CHANNELs ch1 = visual
GRPP.softch     = [];		% invalidated channels for analysis
GRPP.neusig     = 'blp';
GRPP.mrisig     = 'froiTs';

% ELECTRODE(ROI DEFINITION)
% THELE - LGN or Pulvinar
% PELE  - Pons
% HELE  - Hippocampus
GRPP.ele.name   =  '';
GRPP.ele.roi    =  {'hele','thele'};
GRPP.ele.ap     = [];
GRPP.ele.ml     = [];
GRPP.ele.depth  = [];
GRPP.ele.site   = [];
GRPP.ele.color  = {[1 0 0],[0 0 0],[0 0 1],[0 1 1],[0 .5 0],[.7 .7 .6],[0 1 0],[1 0 1],[1 1 0]};

%=========================================================================================
% ROIS(Regions of Interest in Monkeys, see below subGetMonkeyRois)
%=========================================================================================
tmproi      = {'FOV' 'Brain','LEFT','RIGHT', 'roi1','roi2','roi3','roi4','roi5','roi6','roi7','roi8','daIns_L','daIns_R'...
               'ele_Ins','ele_InsL','ele_InsR', 'ele_contL', 'ele_contR'...
              'ele_HP','ele_LGN','ele_Pul','ele_BG','ele_PBn','ele_V1f','ele_V1pf','ele_V1p'... 
              'Vermis_L' 'Vermis_R' 'IntHemCb_L' 'IntHemCb_R' 'LatHemCb_L' 'LatHemCb_R'...
              'pflCb_L' 'pflCb_R' 'DCbN_L' 'DCbN_R' 'alCb_L' 'alCb_R'...
              'Brainstem_L' 'Brainstem_R' 'ParabrachialN_L'  'ParabrachialN_R' ...
              'PontReg_L' 'PontReg_R' 'Raphe_L' 'Raphe_R' 'LC_CGn_L' 'LC_CGn_R'...
              'RN_L' 'RN_R' 'STh_L' 'STh_R'...
              'MesE_L' 'MesE_R' 'SC_L' 'SC_R' 'InfCol_L' 'InfCol_R'...
              'PAG_L' 'PAG-R' 'SN_L' 'SN_R' 'VTA_L' 'VTA_R' ...
              'Tha_L' 'Tha_R' 'LGN_L' 'LGN_R' 'Pul_L' 'Pul_R' 'MD_L' 'MD_R'...
              'VL_L' 'VL_R' 'VP_L' 'VP_R' 'VA_L' 'VA_R' 'VM_L' 'VM_R' 'MdTha_a_R' 'MdTha_a_L' 'MdTha_a'...
              'BNST_L' 'BNST_R' 'HTh_L' 'HTh_R'...
              'MSDB_L' 'MSDB_R' 'NBM_L' 'NBM_R' 'DS_L' 'DS_R' 'VS_L' 'VS_R' 'NAcc_L' 'NAcc_R' 'GP_L' 'GP_R' ...
              'Amy_L' 'Amy_R' 'HP_L' 'HP_R' 'Ent_L' 'Ent_R' 'PirFo_L' 'PirFo_R'...
              'Ins_L' 'Ins_R' 'dIns_L' 'dIns_R' 'iIns_L' 'iIns_R' 'vIns_L' 'vIns_R' 'aIns_L' 'aIns_R' 'Cl_L' 'CL_R'...
              'ACC_L' 'ACC_R' 'MCC_L' 'MCC_R' 'PCC_L' 'PCC_R' 'RetroSp_L' 'RetroSp_R' ...
              'fV1_L' 'fV1_R' 'pfV1_L' 'pfV1_R'  'pV1_L' 'pV1_R'...
              'V2V3_L' 'V2V3_R' 'V4_L' 'V4_R' 'V5_L' 'V5_R'...
              'S1_L' 'S1_R' 'S2_L' 'S2_R' 'Motor_L' 'Motor_R' 'Premotor_L' 'Premotor_R' ...
              'TmpAu_L' 'TmpAu_R' 'TmpVis_L' 'TmpVis_R' 'TmpSTS_L' 'TmpSTS_R' 'TmpPol_L' 'TmpPol_R'...
              'ParLat_L' 'ParLat_R'  'ParIntra_L' 'ParIntra_R' 'ParPrec_L' 'ParPrec_R' ...
              'oPFC_L' 'oPFC_R' 'mPFC_L' 'mPFC_R' 'dPFC_L' 'dPFC_R'};
% roi1 = IM_R
% roi2 = IM_L
% roi3 = Hab_R
% roi4 = Hab_L
% VL_R/L = VP_R/L

ROI.groups  = {'All'};                      % SuperAvg (see HROI)
ROI.model   = 'hele';                       % Group to use as model
ROI.names   = {};
ROI.names   = paxroigroups('ROI','monkey');  
ROI.names   = cat(2,tmproi, ROI.names);

% [2] Anatomically ordered ROIs
%     H.E. (13.02.2013) 1. Rhomb, 2. Mete, 3. Mese, 4. Diencephalon, 5. Limbic, 6-8 Neocortex
% ANAP.SELROI = {'Brainstem',...
%                'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg' 'Raphe' 'LC_CGn'...
%                'MesE' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
%                'Tha' 'LGN' 'GP' 'VS' 'DS' 'HTh' 'MSDB' 'BNST' ...
%                'Amy' 'basalAmy' 'PirFo'  'HP' 'Ent' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
%                'fV1' 'pfV1' 'pV1' 'V1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
%                'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
%                'orbPFC' 'medPFC' 'dlPFC'};

% MANY NEW SESSIONS DO NOT HAVE THE OLFMesE ROIs, so I TEMPORARILY REMOVE IT FROM THE LIST
% ANAP.SELROI = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg' 'Raphe' 'LC_CGn'...
%                'MesE' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
%                'Tha' 'LGN' 'GP' 'VS' 'DS' 'HTh' 'MSDB' 'BNST' ...
%                'Amy' 'basalAmy' 'PirFo'  'HP' 'Ent' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
%                'fV1' 'pfV1' 'pV1' 'V1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
%                'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
%                'orbPFC' 'medPFC' 'dlPFC'};

% BEFOREUPDATE(SELROI USED UNTIL THE LATEST (05.08.2014 ROI-UPDATE By HENRY EVRARD)
% ANAP.SELROI = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg' 'Raphe' 'LC_CGn'...
%                'MesE' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
%                'Tha' 'LGN' 'GP' 'VS' 'DS' 'HTh' 'MSDB' 'BNST' ...
%                'Amy' 'basalAmy' 'PirFo'  'HP' 'Ent' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
%                'fV1' 'pfV1' 'pV1' 'V1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
%                'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
%                'orbPFC' 'medPFC' 'dlPFC'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE(05.08.2014 FINAL VERSION OF ROI-LIST; updated by HE and YM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROIS ordered by standard ontogentic anatomical categorization (NBM=Nuc Lbasalis Meynert)
ANAP.SELROI = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' ...
               'Brainstem' 'ParabrachialN' 'PontReg' 'Raphe' 'LC_CGn'...
               'MesE' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
               'Tha' 'LGN' 'Pul'  'BNST' 'HTh' 'MSDB' 'NBM' 'DS' 'VS' 'GP'  ...
               'Amy' 'basalAmy'   'HP' 'Ent' 'PirFo' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
               'fV1' 'pfV1' 'pV1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
               'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
               'orbPFC' 'medPFC' 'dlPFC'};


ANAP.HPLGN = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' ...
               'Brainstem' 'PontReg' 'Raphe' 'LC_CGn'...
               'MesE' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
               'Tha' 'LGN' 'Pul' 'GP' 'VS' 'DS' 'HTh' 'MSDB' 'BNST' 'NBM' ...
               'Amy' 'basalAmy'   'HP' 'Ent' 'PirFo' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
               'fV1' 'pfV1' 'pV1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
               'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
               'orbPFC' 'medPFC' 'dlPFC'};

ANAP.POLROI = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' ...
               'PontReg' 'Raphe' 'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
               'Tha' 'LGN' 'Pul' 'GP' 'VS' 'DS' 'HTh' ...
               'Amy' 'HP' 'Ent' 'PirFo' 'ACC' 'PCC' 'RetroSp'  ...
               'V1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
               'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
               'orbPFC' 'medPFC' 'dlPFC'};

% ROIS ordered by synaptic distance
ANAP.SYNPROI = {'MSDB' 'Amy' 'HTh' 'VS' 'DS' 'Thal' 'PCC' 'orbPFC' 'medPFC' 'Ent' ...
                'TmpVis' 'RetroSp' 'PirFo' 'TmpSTS' ...
                'LGN' 'basalAmy' 'HP' 'TmpPol' 'dlPFC' 'ACC' 'dACC' 'Ins' 'aIns' ...
                'V4' 'ParLat' ...
                'GP' 'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg' 'SC' ...
                'InfCol' 'PAG' 'LC_CGn' 'Raphe'...
                'SN' 'VTA' 'V1' 'V2V3' 'V5' 'S1' 'S2' 'Motor' 'Premotor' 'ParIntra' ...
                'ParPrec' 'TmpAu'};

% ROIS ordered alphabetically
ANAP.ALLROI = { 'ACC','aIns','alCb','Amy','basalAmy','BNST','Brainstem','dACC','DBMS',...
                'DCbN','dlPFC','DS','Ent','GP','HP','HTh','InfCol','Ins','IntHemCb',...
                'LCCGn','LGN','LatHemCb','medPFC','MesE','Motor','orbPFC',...
                'PAG','PCC','pflCb','ParIntra','ParLat','ParPrec','PirFo','PontReg',...
                'Premotor','Raphe','RetroSp','S1','S2','SC','SN','Tha','TmpAu',...
                'TmpPol','TmpSTS','TmpVis','V1','V2V3','V4','V5','VS','VTA','Vermis'};

% ROIS (subselection) used by NETBLP
ANAP.NETBLP.SELROI = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' ...
               'ParabrachialN' 'PontReg' 'Raphe' 'LC_CGn'...
               'SC' 'InfCol' 'PAG' 'SN' 'VTA' ...
               'Tha' 'LGN' 'Pul' 'GP' 'VS' 'DS' 'HTh' 'MSDB' 'BNST' 'NBM' ...
               'Amy' 'basalAmy'   'HP' 'Ent' 'PirFo' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'  ...
               'fV1' 'pfV1' 'pV1' 'V2V3' 'V4' 'V5' 'TmpAu' 'S1' 'S2' 'Motor' 'Premotor' ...
               'TmpVis'  'TmpSTS' 'TmpPol'  'ParLat' 'ParIntra' 'ParPrec' ...
               'orbPFC' 'medPFC' 'dlPFC'};

% ==========================================================================================
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Developmental Anatomical Brain Characterization 
% ==========================================================================================

ANAP.RoiDef = {};

% BRAINSTEM 
ANAP.RoiDef{end+1} =  {'Brainstem', 'Brainstem','Brainstem'};    

% METENCEPHALON
ANAP.RoiDef{end+1} =  {'Vermis','Vermis','Metencephalon'};                       % CEREBELLUM
ANAP.RoiDef{end+1} =  {'IntHemCb','Intermediate_cerebellar_hemisphere','Metencephalon'};
ANAP.RoiDef{end+1} =  {'LatHemCb','Lateral_cerebellar_hemisphere','Metencephalon'};
ANAP.RoiDef{end+1} =  {'pflCb','Parafloculonodular','Metencephalon'};
ANAP.RoiDef{end+1} =  {'alCb','Anterior_cerebellar_lobe','Metencephalon'};
ANAP.RoiDef{end+1} =  {'DCbN', 'Deep_cerebellar_nuclei','Metencephalon'};

ANAP.RoiDef{end+1} =  {'PontReg','Pontine_Region','Metencephalon'};              % PONS
ANAP.RoiDef{end+1} =  {'Raphe', 'Raphe','Metencephalon'};
ANAP.RoiDef{end+1} =  {'ParabrachialN', 'PBn','Metencephalon'};

% MIDBRAIN 
ANAP.RoiDef{end+1} =  {'MesE','Mesencephalon','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'LC_CGn', 'Locus_Coeruleus_Central_Gray','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'SC', 'Superior_Colliculus','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'InfCol',  'Inferior_Colliculus','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'PAG', 'Periaqueductal_Gray','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'SN','Substantia_Nigra','Mesencephalon'};
ANAP.RoiDef{end+1} =  {'VTA','Ventral_Tegmental_Area','Mesencephalon'};

% Diencephalon is made up of four distinct components: the THALAMUS, the SUBTHALAMUS, the
% HYPOTHALAMUS, and the EPITHALAMUS
ANAP.RoiDef{end+1} =  {'Tha', 'Thalamus','Diencephalon'}; % Interbrain
ANAP.RoiDef{end+1} =  {'LGN', 'Lateral_Geniculate','Diencephalon'};
ANAP.RoiDef{end+1} =  {'Pul', 'Pulvinar','Diencephalon'};

% BASAL FOREBRAIN is a collection of structures located to the front of and below the
% striatum. It includes the nucleus accumbens, nucleus basalis, diagonal band of Broca,
% substantia innominata, and medial septal nuclei. These structures are important in the
% production of acetylcholine, which is then distributed widely throughout the brain. It The
% basal forebrain is considered to be the major cholinergic output of the central nervous
% system (CNS).
ANAP.RoiDef{end+1} =  {'BNST', 'Stria_Terminalis_Meynert_Substantia_Innominata','BasalForebrain'};
ANAP.RoiDef{end+1} =  {'MSDB', 'Diagonal_Band_Septum','BasalForebrain'};

% LIMBIC SYSTEM
ANAP.RoiDef{end+1} =  {'HTh', 'Hypothalamus', 'Limbic'};
ANAP.RoiDef{end+1} =  {'Amy', 'Amygdala','Limbic'};
ANAP.RoiDef{end+1} =  {'basalAmy', 'Basal_Amygdala','Limbic'};
ANAP.RoiDef{end+1} =  {'HP', 'Hippocampus','Limbic'};
ANAP.RoiDef{end+1} =  {'Ent', 'Entorhinal_Cortex','Limbic'};
ANAP.RoiDef{end+1} =  {'PirFo','Piriform_Cortex','Limbic'};

% CEREBRUM refers to the parts of the brain containing the cerebral cortex, as well as
% several subcortical structures, including the hippocampus, basal ganglia, and olfactory
% bulb.
ANAP.RoiDef{end+1} =  {'NBM', 'Nucleus_Basalis_Meynert','Cerebrum'};
ANAP.RoiDef{end+1} =  {'VS',  'Ventral_Striatum','Cerebrum'};
ANAP.RoiDef{end+1} =  {'DS',  'Dorsal_Striatum','Cerebrum'};
ANAP.RoiDef{end+1} =  {'GP',  'Globus_Pallidus','Cerebrum'};

% NEOCORTEX
ANAP.RoiDef{end+1} =  {'Olf','Olfactory','Neocortex'};
ANAP.RoiDef{end+1} =  {'Premotor','Premotor_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'Motor','Motor_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'S1', 'Primary_Somatosensory_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'S2', 'Other_Somatosensory_Cortices','Neocortex'};
ANAP.RoiDef{end+1} =  {'Ins', 'Insular_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'aIns', 'Anterior_Insular_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'ACC','Anterior_Cingulate_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'dACC','Dorsal_Anterior_Cingulate_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'PCC','Posterior_Cingulate_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'RetroSp','Retrosplenial_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'orbPFC','Orbital_Prefrontal_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'medPFC','Medial_Prefrontal_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'dlPFC','Dorsolateral_Prefrontal_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'V1','Primary_Visual_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'fV1','Foveal_Primary_Visual_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'pfV1','Parafoveal_Primary_Visual_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'pV1','Peripheral_Primary_Visual_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'V2V3','V2V3','Neocortex'};
ANAP.RoiDef{end+1} =  {'V4','V4','Neocortex'};
ANAP.RoiDef{end+1} =  {'V5','V5','Neocortex'};
ANAP.RoiDef{end+1} =  {'TmpAu','Auditory_Temporal','Neocortex'};
ANAP.RoiDef{end+1} =  {'TmpPol','Polar_Temporal_Cortex','Neocortex'};
ANAP.RoiDef{end+1} =  {'TmpSTS','Superior_Temporal_Sulcus','Neocortex'};
ANAP.RoiDef{end+1} =  {'TmpVis','Inferior_Temporal_Sulcus','Neocortex'};
ANAP.RoiDef{end+1} =  {'ParLat','Parietal_Lateral','Neocortex'};
ANAP.RoiDef{end+1} =  {'ParIntra','Intraparietal','Neocortex'};
ANAP.RoiDef{end+1} =  {'ParPrec','Parietal_Precuneus','Neocortex'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SITES AND SITE_ROIS FOR THE MONKEY HIPP-THAL PROJECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEMORY 
ANAP.MemDeclarative = {'dlPFC','medPFC'};
ANAP.MemProcedural  = {'Vermis', 'IntHemCb','LatHemCb','pflCb','DCbN','alCb','DS','VS'};
ANAP.MemEmotional   = {'Amy','PCC','RetroSp','dlPFC','orbPFC','medPfc'};
ANAP.MemWorking     = {'orbPFC','TmpSTS','Ins','PCC','ACC','RetroSp','TmpVis','V4'};

% HIPPOCAMPAL MONOSYNAPTIC PROJECTIONS (FOR EACH FIELD) 'SUBICULUM', 'SUB'
ANAP.MonSynSub      = {'medPFC', 'orbPFC', 'ACC', 'RetroSp', 'Ent', 'TmpVis', 'Amy', ...
                    'DS','VS','DB','Septum', 'Tha'};
ANAP.MonSynPreSub   = {'dlPFC', 'ParLat', 'PCC','TmpVis','TmpSTS','orbPFC','RetroSp','Septum','Tha'};
ANAP.MonSynParaSub  = {'TmpSTS','orbPFC','ACC','Tha'};
ANAP.MonSynEnt      = {'orbPFC', 'PCC', 'Ins', 'dlPFC', 'medPFC', 'RetroSp', 'TmpVis','TmpSTS', ...
                    'DS','VS','Amy','Tha','DB','PirFo'};
ANAP.MonSynDG       = {'HP','TmpPol'};
ANAP.MonSynCA1      = {'RetroSp','TmpVis','PCC','ACC','medPFC','ParLat','Septum','DS','VS', ...
                    'Hth','Amy'};
ANAP.MonSynCA2      = {'Septum','Raphe'};
ANAP.MonSynCA3      = {'Septum','Raphe'};
ANAP.CAMonSyn       = {'RetroSp','TmpVis','PCC','ACC','medPFC','ParLat','Septum','DS','VS', ...
                    'Hth','Amy','Raphe'};
ANAP.HFMonSyn       = {'Tha','DB','Ent','PirFo','TmpSTS','dlPFC'};
ANAP.PolSynCtx      = {'V1' 'V2V3' 'V4' 'V5' 'S1' 'S2' 'Motor' 'Premotor' ...
                    'TmpAu' 'ParIntra' 'ParPrec'};
ANAP.MonSynPerirhinal= {'orbPFC','Ins','TmpSTS','TmpVis','TmpPol','Amy','Tha'};
ANAP.MonSynParahipp  = {'medPFC','dlPFC','TmpSTS','RetroSp','V4','Ins','ParLat','Tha'};

% GROUPROIS Used for the tkCCA analysis
ANAP.HF             = {'HP', 'Ent'};
ANAP.HippMonSynP    = {'RetroSp','TmpVis','PCC','ACC','medPFC','ParLat','Septum',...
                       'Amy','PirFo','TmpSTS','dlPFC'};
ANAP.HippMonSynN    = {'VS','DS', 'Hth', 'Raphe','Tha','LGN','DB'};
ANAP.HippPolSyn     = {'V1' 'V2V3' 'V4' 'V5' 'S1' 'S2' 'Motor' 'Premotor' ...
                       'TmpPol' 'TmpAu' 'ParIntra' 'ParPrec'};
ANAP.Metencephalon  = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg'};
ANAP.Mesencephalon  = {'SC' 'InfCol' 'PAG' 'LC_CGn'};
ANAP.Diencephalon   = {'VTA' 'Tha' 'LGN' 'MSDB' 'HTh' 'VS' 'DS' 'GP' 'SN'};
ANAP.Limbic         = {'Ent','Amy','basalAmy' 'PirFo' 'Ins' 'aIns' 'dACC' 'ACC' 'PCC' 'RetroSp'};
ANAP.Neocortex      = {'Premotor' 'Motor' 'S1' 'S2' 'orbPFC' 'medPFC' 'dlPFC' ...
                       'TmpPol' 'TmpAu' 'TmpSTS' 'TmpVis' 'ParLat' 'ParIntra'...
                       'ParPrec' 'V1' 'V2V3' 'V4' 'V5' };
ANAP.SubCortical    = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'PontReg' 'SC'...
                       'InfCol' 'PAG' 'LC_CGn' 'VTA' 'Tha' 'LGN' 'MSDB' 'HTh' 'VS' 'DS' 'GP' 'SN'};
ANAP.Cerebellum     = {'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb'};
ANAP.Tectum         = {'SC' 'InfCol'};
ANAP.Thalamus       = {'Tha' 'LGN'};
ANAP.BasalGanglia   = {'VS' 'DS' 'GP' 'SN'};
ANAP.Pons           = {'PontReg','Raphe'};
ANAP.Cingulate      = {'ACC' 'PCC' 'RetroSp'}; 
ANAP.Sensorimotor   = {'Premotor' 'Motor' 'S1' 'S2'};
ANAP.VisCtx         = {'fV1' 'pfV1' 'pV1' 'V2V3' 'V4' 'V5' 'TmpPol' 'TmpSTS' 'TmpVis'};
ANAP.VisSys         = {'LGN' 'Pul' 'SC' 'fV1' 'pfV1' 'pV1' 'V2V3' 'V4' 'V5' 'TmpPol' 'TmpSTS' 'TmpVis'};
ANAP.Occipital      = {'V1' 'V2V3' 'V4' 'V5' };
ANAP.Extrastriate   = {'V2V3' 'V4' 'V5' 'TmpPol' 'TmpSTS' 'TmpVis'};
ANAP.Temporal       = {'TmpPol' 'TmpSTS' 'TmpVis' 'TmpAu'};
ANAP.Parietal       = {'ParLat' 'ParIntra' 'ParPrec'};
ANAP.Prefrontal     = {'medPFC' 'dlPFC' 'orbPFC'};
ANAP.SensoryCortex  = {'V1','A1','S1','TmpAu','Ins','S2','Motor'};
ANAP.MemSystems     = {'DS','VS','GP' 'SN' 'Vermis' 'IntHemCb' 'LatHemCb' 'pflCb' 'DCbN' 'alCb' 'SC' ...
                       'InfCol' 'Tha' 'LGN'};

GRPP.grproi = 'RoiGrp';

%=========================================================================================
% IMAGE LOADING AND ROI DEFINITION -------------------------------------------------------
%=========================================================================================
ANAP.imgload.ICROP                  = 1;		% Crop images
ANAP.imgload.INORMALIZE             = 0;
ANAP.imgload.INORMALIZE_THR         = 10;
ANAP.imgload.ISUBSTITUTE            = 0;		% Substitute initial images if no DUMMIES exist
ANAP.imgload.IDETREND               = 0;		% Detrend images
ANAP.imgload.IDETREND_AND_DENOISE   = 0;
ANAP.imgload.ITMPFLT_LOW            = 0;
ANAP.imgload.ITMPFLT_HIGH           = 0;
ANAP.imgload.IDENOISE               = 0;
ANAP.imgload.IFILTER                = 0;

%================================================================================================
% ROITS(MONKEY) Time series of ROIs (in Roi.mat); Parameters used by SESAREATS/MAREATS
% ISUBSTITUTE is only used for scans without dummies; here should be always ZERO
% RESPIRATORY ARTIFACTS
% Respiration at 24 strokes/min, i.e. 0.4 Hz (RespFr)
% Until 12.09.2013 TR = 2 seconds, Sampling Freq = 0.5Hz, Nyquist = 0.25 Hz
% Expected interference AliasedRespFr = NyqF - (RespFr - NyqF)
% ResidualRespFr = 0.38-0.42 Hz (visible after resampling)
% AliasedRespFr = 0.25 - (0.4 - 0.25) = 0.1 Hz
% We usually see interference in the 0.075 to 0.120 Hz Range!
% UPDATE(Last changes on 08 July 2013)
%================================================================================================
% FILTIERING(ICUTOFF/ICUTOFFHIGH Values obtained by running)
% RPANA('monkey','spont','clust_monkey',{'hp','mr1'});
% SIGPSD(SesName,'spont','sig','rproiTs','func','pwelch','recalc',1,'dsp',0);
% SIGPSD({'monkey','hp','mr1'},'spont','sig','rproiTs','func','pwelch','recalc',0,'scale','linear');
% Bandpass range = [0.017 0.17] Hz
% Values used earlier [0.010 0.200] Hz
%================================================================================================
ANAP.mareats.IEXCLUDE           = {'Brain','LEFT','RIGHT'};
ANAP.mareats.ICONCAT            = 1;          % 1= concatanate ROIs before creating roiTs
ANAP.mareats.SMART_UPDATE       = 0;          % smart update checks parameters
ANAP.mareats.ISUBSTITUTE        = 0;          % DO not use this if you have dummy scans
ANAP.mareats.IHEMODELAY         = 0;          % usually 2 sec, but here is shorter
ANAP.mareats.IHEMOTAIL          = 0;          % usually 6 sec, but here also shorter
ANAP.mareats.IFFTFLT            = 0;          % Respiratory artifact removal I
ANAP.mareats.IROIFILTER         = 0;          % spatial filter with ROI masking
ANAP.mareats.IROIFILTER_KSIZE   = 0;          % Filter within ROI-boundaries
ANAP.mareats.IROIFILTER_SD      = 0;          % Size and SD.. of filters
ANAP.mareats.IFILTER3D          = 0;          % Voxel Size:  [0.75 0.75 2];
ANAP.mareats.IFILTER3D_KSIZE_mm = [];         % [5 5 7]  Kernel size in mm
ANAP.mareats.IFILTER3D_FWHM_mm  = [];         % [2.5 2.5 3]; FWHM of Gaussian in mm
ANAP.mareats.IARTHURFLT         = [];         % = [0.11 0.13]; % UNFORTUNATELY VERY SLOW
ANAP.mareats.IGAMMA             = 0;          % NO gamma-correction in these sessions
ANAP.mareats.IRADIUS            = 0;          % Radius (mm) for dispersion-derivative
ANAP.mareats.INOTCH             = 1;          % Def: 4; Threshold for resp-art removal
ANAP.mareats.IRESPTHR           = 0;          % Def: 4; Threshold for resp-art removal
ANAP.mareats.IRESPBAND          = [];         % Def: subGetRespBand(SesName); TOO SLOW...
ANAP.mareats.IDETREND           = 0;          % Remove linear trends
ANAP.mareats.ICUTOFF            = 0;          % Lowpass filtering cutoff
ANAP.mareats.ICUTOFFHIGH        = 0.01;       % Highpass filtering cutoff
ANAP.mareats.IREMBRAINMEAN      = 1;          % Remove brain's average (phys artifacts)
ANAP.mareats.ITOSDU             = {'zerobase','blank'};   % Normalization
ANAP.mareats.IRESAMPLE          = 1;          % Resample scans with DX = 1sec
%================================================================================================
ANAP.mareats.IMIMGPRO           = 1;          % Minimal Image processing
ANAP.mareats.IFILTER            = 0;          % 1=to spatially filter; 0=no filter at all
ANAP.mareats.IFILTER_KSIZE      = 3;          % Kernel size (previously 3)
ANAP.mareats.IFILTER_SD         = 1.25;       % Kernel SD (90% of flt in kernel) (previously 1.5)
%================================================================================================
ANAP.froiTs.mareats               = ANAP.mareats;
ANAP.froiTs.mareats.IREMBRAINMEAN = 1;      % Remove brain's average (phys artifacts)
ANAP.froiTs.mareats.IFILTER       = 1;      % 1=to spatially filter; 0=no filter at all
ANAP.froiTs.mareats.IFILTER_KSIZE = 5;      % Kernel size (previously 3)
ANAP.froiTs.mareats.IFILTER_SD    = 2.0;    % Kernel SD (90% of flt in kernel) (previously 1.5)
ANAP.froiTs.mareats.ICUTOFFHIGH   = 0.010;  % remove very slow oscillations
ANAP.froiTs.mareats.ICUTOFF       = 0.200;  % 0.5 is Nyquist..
%================================================================================================
% GETTRIAL - PRE-PROCESSING
%================================================================================================
ANAP.gettrial.status        =   1;          % IsTrial
ANAP.gettrial.Average       =   1;          % Do not average tblp, but concat
ANAP.gettrial.trial2obsp    =   0;          % Obsp with multiple ripple-events
ANAP.gettrial.Xmethod       =   'evtsdu';   % No transformation to SD units
ANAP.gettrial.Xepoch        =   'prestim';  % Argument (Epoch) to xfrom in gettrial
ANAP.gettrial.sort          =   'trial';    % sorting with SIGSORT, can be 'none|stimulus|trial
ANAP.gettrial.HemoDelay     =   1;          % Here much shorter than usually!
ANAP.gettrial.HemoTail      =   4;          % Same for tail
ANAP.gettrial.RefChan       =   2;          % Reference channel (for DIFF... not used here!)
ANAP.gettrial.PreT          = -20;          % Beginning of trial window w/ respect to event 
ANAP.gettrial.PostT         = +20;          % End of trial window w/ respect to event
ANAP.gettrial.IBRAINMEAN    =   0;          % 1=(dat-mean)/std, 2=(dat-mean)/1
ANAP.gettrial.ICUTOFF       =   0.000;      % plroiTs/plfroiTs-specific lowpass filtering
ANAP.gettrial.ICUTOFFHIGH   =   0.000;      % plroiTs/plfroiTs-specific highpass filtering
%================================================================================================

GRPP.anap.gettrial = ANAP.gettrial;         % Generalize..
if ANAP.gettrial.status,                    % Overwrites GrpPhySigs/GrpImgSigs for each group
  GRPP.grpsigs = {'plblp','plroiTs','plfroiTs'};
else
  GRPP.grpsigs = {'blp','roiTs','froiTs'};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVENT( DETECTION & IDENTIFICATION)
% ==========================================================================================
% blp.band{ 1} = {[   0    325] 'cln'     'LFP', 0};
% blp.band{ 2} = {[   0.03 3.0] 'delta'   'LFP', 0};
% blp.band{ 3} = {[   3.5   12] 'theta'   'LFP', 3};
% blp.band{ 4} = {[  13     16] 'spindle' 'LFP', 4};
% blp.band{ 5} = {[  17     28] 'sigma'   'LFP', 5};
% blp.band{ 6} = {[  30     80] 'gamma'   'LFP', 30};
% blp.band{ 7} = {[  81    190] 'ripple'  'LFP', 30};
% blp.band{ 8} = {[ 255    750] 'hfo'     'MUA', 30};
% blp.band{ 9} = {[ 755   3000] 'mua'     'MUA', 200};
% ==========================================================================================
ANAP.getevent.def.animal        = 'monkey';     % Exp Animal
ANAP.getevent.def.cdm           = 'supervised'; % Detection method
ANAP.getevent.def.frange        = [1 300];      % Frequency range used for spec/TF displays
ANAP.getevent.def.tfwin         = [-2 2];       % Start-window for TF-plot
ANAP.getevent.def.evtwin        = [-10 10];     % Used by getevent/dspevent
ANAP.getevent.def.pxxwin        = [-0.1 0.1];   % Window used to compute pmtm
ANAP.getevent.def.dspwin        = [-0.5 0.5];   % Final display window for TF reps
ANAP.getevent.def.mriwin        = [ANAP.gettrial.PreT ANAP.gettrial.PostT];

ANAP.getevent.def.bname         = {'theta','spindle','sigma','gamma','ripple','hfo'};
ANAP.getevent.def.nclust        = length(ANAP.getevent.def.bname);
ANAP.getevent.def.brange        = [10 300];     % Entire range (Spindle-Ripple)
ANAP.getevent.def.dtlow         = 40;           % lowpass cutoff for envelop
ANAP.getevent.def.dtthr         = 5;            % Peak-threshold
ANAP.getevent.def.maxpeak       = 15;           % Event-Peaks > maxpeak-STD are ignored
ANAP.getevent.def.gap           = 0.5;          % Gaps are computed after clustering!!
ANAP.getevent.def.nnmfthr       = 2;            % Unsuperivsed: Ratio of BandPeak to RestPeak

% LFO EVENTS
ANAP.getevent.def.lfo.brange    = [1 6];        % Get range from BLP
ANAP.getevent.def.lfo.dtlow     = 3;            % lowpass cutoff for envelop
ANAP.getevent.def.lfo.dtthr     = 4;            % Peak-threshold
ANAP.getevent.def.lfo.gap       = 0.5;          % Gap between this type of events
% SPW EVENTS
ANAP.getevent.def.spw.brange    = [1 10];       % Get range from BLP
ANAP.getevent.def.spw.dtlow     = 4;            % lowpass cutoff for envelop
ANAP.getevent.def.spw.dtthr     = 4;            % Peak-threshold
ANAP.getevent.def.spw.gap       = 0.5;          % Gap between this type of events
% THETA EVENTS
ANAP.getevent.def.theta.brange    = [];           % Get range from BLP
ANAP.getevent.def.theta.dtlow     = 4;            % lowpass cutoff for envelop
ANAP.getevent.def.theta.dtthr     = 4;            % Peak-threshold
ANAP.getevent.def.theta.gap       = 0.5;          % Gap between this type of events
% PGO EVENTS
ANAP.getevent.def.pgo.brange    = [1 12];       % Get range from BLP
ANAP.getevent.def.pgo.dtlow     = 6;            % lowpass cutoff for envelop
ANAP.getevent.def.pgo.dtthr     = 3;            % Peak-threshold
ANAP.getevent.def.pgo.gap       = 0.5;          % Gap between this type of events
% SPINDLE EVENTS
ANAP.getevent.def.spindle.brange= [];           % Get range from BLP
ANAP.getevent.def.spindle.dtlow = 10;           % lowpass cutoff for envelop
ANAP.getevent.def.spindle.dtthr = 3;            % Peak-threshold
ANAP.getevent.def.spindle.gap   = 0.5;          % Gap between this type of events
% SIGMA EVENTS
ANAP.getevent.def.sigma.brange  = [];           % Get range from BLP
ANAP.getevent.def.sigma.dtlow   = 10;           % lowpass cutoff for envelop
ANAP.getevent.def.sigma.dtthr   = 3;            % Peak-threshold
ANAP.getevent.def.sigma.gap     = 0.5;          % Gap between this type of events
% GAMMA EVENTS
ANAP.getevent.def.gamma.brange  = [];           % Get range from BLP
ANAP.getevent.def.gamma.dtlow   = 30;           % lowpass cutoff for envelop
ANAP.getevent.def.gamma.dtthr   = 4;            % Peak-threshold
ANAP.getevent.def.gamma.gap     = 0.5;          % Gap between this type of events
% RIPPLE EVENTS
ANAP.getevent.def.ripple.brange = [];           % Get range from BLP
ANAP.getevent.def.ripple.dtlow  = 30;           % lowpass cutoff for envelop
ANAP.getevent.def.ripple.dtthr  = 4;            % Peak-threshold
ANAP.getevent.def.ripple.gap    = 0.5;          % Gap between this type of events
% HRIPPLE EVENTS
ANAP.getevent.def.hripple.brange= [185 325];    % Get range from BLP
ANAP.getevent.def.hripple.dtlow = 30;           % lowpass cutoff for envelop
ANAP.getevent.def.hripple.dtthr = 4;            % Peak-threshold
ANAP.getevent.def.hripple.gap   = 0.5;          % Gap between this type of events
% HFO EVENTS
ANAP.getevent.def.hfo.brange    = [190 325];    % Get range from BLP
ANAP.getevent.def.hfo.dtlow     = 30;;          % lowpass cutoff for envelop
ANAP.getevent.def.hfo.dtthr     = 4;            % Peak-threshold
ANAP.getevent.def.hfo.gap       = 0.5;          % Gap between this type of events
% ==========================================================================================
STRUCT_SPECIFIC = 0;
if STRUCT_SPECIFIC,
  % SITES(Set Parameters for Hippocampus)
  ANAP.getevent.pl              = ANAP.getevent.def;
  ANAP.getevent.pl.bname        = {'spw', 'sigma', 'gamma', 'ripple'};
  ANAP.getevent.pl.nclust       = length(ANAP.getevent.def.bname);
  ANAP.getevent.hp              = ANAP.getevent.pl;
  ANAP.getevent.sr              = ANAP.getevent.pl;
  % ==========================================================================================
  % SITES(And for other Standard Recording Sites)
  ANAP.getevent.lgn             = ANAP.getevent.pl;
  ANAP.getevent.lgn.bname       = {'pgo', 'spindle',  'gamma', 'hfo'};
  ANAP.getevent.lgn.nclust      = length(ANAP.getevent.lgn.bname);
  % ==========================================================================================
  ANAP.getevent.st              = ANAP.getevent.lgn;
  ANAP.getevent.cer             = ANAP.getevent.lgn;
  ANAP.getevent.cx              = ANAP.getevent.lgn;
  ANAP.getevent.vcx             = ANAP.getevent.lgn;
  ANAP.getevent.eeg             = ANAP.getevent.lgn;
  ANAP.getevent.at              = ANAP.getevent.lgn;
  ANAP.getevent.pul             = ANAP.getevent.lgn;
  ANAP.getevent.po              = ANAP.getevent.lgn;
  ANAP.getevent.pbl             = ANAP.getevent.po;
else
  ANAP.getevent.pl              = ANAP.getevent.def;
  ANAP.getevent.hp              = ANAP.getevent.def;
  ANAP.getevent.sr              = ANAP.getevent.def;
  ANAP.getevent.lgn             = ANAP.getevent.def;
  ANAP.getevent.st              = ANAP.getevent.def;
  ANAP.getevent.cer             = ANAP.getevent.def;
  ANAP.getevent.cx              = ANAP.getevent.def;
  ANAP.getevent.vcx             = ANAP.getevent.def;
  ANAP.getevent.eeg             = ANAP.getevent.def;
  ANAP.getevent.at              = ANAP.getevent.def;
  ANAP.getevent.pul             = ANAP.getevent.def;
  ANAP.getevent.po              = ANAP.getevent.def;
  ANAP.getevent.pbl             = ANAP.getevent.def;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MRIEVENT( DETECTION & IDENTIFICATION )
% ==========================================================================================
% Calculating contrasts (not used here...)
% con = {};
% for N=1:NREG,
%   con{end+1} = zeros(1,NREG+1); con{end}(N) = 1;
%   con{end+1} = zeros(1,NREG+1); con{end}(N) = -1;
% end;
% ==========================================================================================
% PCA(the following definitions should be tried in Ruhe.. after the Tokyo trip)
% ==========================================================================================
% ANAP.mrigetevent.pl.pcawins      = {[-18 -12], [-1 3], [4 8], [12 18]};
% ANAP.mrigetevent.pl.contname     = {'PC1','PC2','PC3','PC4','PC5'};
% ANAP.mrigetevent.pl.nclust       = length(ANAP.mrigetevent.pl.contname);
% ANAP.mrigetevent.pl.conts        = {};
% ANAP.mrigetevent.pl.conts{end+1} = [ 1  0  0  0  0  0]; 
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  1  0  0  0  0]; 
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  0  1  0  0  0];
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  0  0  1  0  0];
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  0  0  0  1  0];

ANAP.mrigetevent.pl.seslist      = {'monkey','hp','th1'};
ANAP.mrigetevent.pl.sites        = {'lgn','pl','st'};
ANAP.mrigetevent.pl.bands        = {'theta','sigma','gamma','ripple','hfo','mua'};
ANAP.mrigetevent.pl.msaevt       = {'mean','pc1'};
ANAP.mrigetevent.pl.bname        = {'theta', 'sigma',  'gamma',  'ripple'};

% NOTE Spatial PCA is computed in multiple windows, which are then concatenated to have a
% better representation of the peri-event MSA
ANAP.mrigetevent.pl.mriwin       = [-20 20];
ANAP.mrigetevent.pl.xcorwin      = [-10 10];
ANAP.mrigetevent.pl.xcorbinw     = 0.5;
ANAP.mrigetevent.pl.thr          = 5;
ANAP.mrigetevent.pl.gap          = 0.1;

ANAP.mrigetevent.pl.pcawins      = {[-20 -12], [-2 5], [12 20]};
ANAP.mrigetevent.pl.pcawins ={[1:25],[26:50],[56:80]};


ANAP.mrigetevent.pl.contname     = {'ripMSA','pgoMSA','PBR','NBR'};
ANAP.mrigetevent.pl.nclust       = length(ANAP.mrigetevent.pl.contname);
ANAP.mrigetevent.pl.conts        = {};
ANAP.mrigetevent.pl.conts{end+1} = [ 1  0  0]; 
ANAP.mrigetevent.pl.conts{end+1} = [-1  0  0]; 
ANAP.mrigetevent.pl.conts{end+1} = [ 0  1  0]; 
ANAP.mrigetevent.pl.conts{end+1} = [ 0 -1  0]; 
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  0  1  0];
% ANAP.mrigetevent.pl.conts{end+1} = [ 0  0 -1  0];

ANAP.mrigetevent.lgn             = ANAP.mrigetevent.pl;
ANAP.mrigetevent.lgn.seslist     = {'monkey','hp','th1'};
ANAP.mrigetevent.lgn.sites       = {'lgn','pl'};
ANAP.mrigetevent.lgn.bname       = {'theta', 'sigma',  'gamma', 'mua'};

ANAP.mrigetevent.vcx             = ANAP.mrigetevent.lgn;
ANAP.mrigetevent.vcx.seslist     = {'monkey','spont','cx1'};
ANAP.mrigetevent.vcx.sites       = {'hp','lgn','vcx'};

% NKL(03.12.2014)
% T11RZ1 [22] - pul  (15)
% S11KZ1 [ 6] - pul  ( 6)  
% C13PA1 [25] - pul  (25)  
% T11QX1 [14] - pul  (10)
ANAP.mrigetevent.pul             = ANAP.mrigetevent.lgn;
ANAP.mrigetevent.pul.seslist     = {'monkey','spont','pul'};
ANAP.mrigetevent.pul.sites       = {'pul'};

% NKL(03.12.2014 ) - sesgrplist({'monkey','pons','spont'});
%   CM029PQ1 (lgn-pons) 1 2 3 4 5 6    SIG(qual/site): OK
%   CM029QF1 (lgn-pons) 1 2 3 4 5 6:10 SIG(qual/site): OK
%   CM029QT1 (lgn-pons) 1 2 3 4 5 6:17 SIG(qual/site): OK
%   CM029RX1 (lgn-pons) 4 5 6 7 8 9:20 SIG(qual/site): OK
%   CM031RE1 (lgn-pons) 4 5 6 7 8 9:11 SIG(qual/site): OK
% Single Hipp-Pons session
%   CM029SD1 (hip-pons) 1 2 3 4 5 6:11 SIG(qual/site): OK
ANAP.mrigetevent.po              = ANAP.mrigetevent.lgn;
ANAP.mrigetevent.po.seslist      = {'monkey','pons','lgn1'};
ANAP.mrigetevent.po.sites        = {'lgn','pbl','po'};
ANAP.mrigetevent.po.sites        = {'pbl','pl'};
ANAP.mrigetevent.po.bname        = {'theta', 'sigma',  'mua'};

ANAP.mrigetevent.pbl             = ANAP.mrigetevent.po;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATTENTION 
% recsites & recrois were meant to determine the ROIs corresponding to the usual electrode
% sites. This can be still used for questions pertaining to the relationship of local neural
% activity to the entire brain structure. For IRF studies and investigation of "pulse"
% responses on the basis of detected event we now have the ele_XXXX ROIs that are maximally
% 100 voxel size and can be used for system identification
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ANAP.recsites={'pl','hp','lgn','st','at','cx','vcx','eeg','pul','po','pbl','cer','v1','v2'};
ANAP.recrois ={'HP','Ent','LGN','Tha','Pul','Ent','fV1','pV1','Pul','PontReg','ParabrachialN','Vermis'};

ANAP.structure.hipp = {'pl','hp','sr','dg'};
ANAP.structure.thal = {'lgn','st','at','pul'};
ANAP.structure.cx   = {'cx','vcx','v1','v2'};
ANAP.structure.pons = {'po','pbl'};

ANAP.excludesites = {'NaN','NA','eeg','cc','nolc'};

%=========================================================================================
% GLM ANALYSIS
%=========================================================================================
GRPP.anap.HemoDelay = 1;                % Note used here...
GRPP.anap.HemoTail =  3;                % Note used here...

GRPP.anap.glm.IARESTIMATION  = 0;       % AR estimation
GRPP.anap.glm.ISATTERWAITH   = 0;       % Satterwaith
GRPP.anap.glm.ICONVWITHGAMMA = 0;       % No convolution is need (done by mkmodel)

GRPP.anap.glm.glmpreproc = '';          % GRPP.anap.glm.glmpreproc = 'usrtransforms';
GRPP.anap.glm.doplot     = 0;

GRPP.glmgrppval     = 0.05;                 % for SESGLMANA
GRPP.glmgrpmode     = 'mean';               % for SESGLMANA (and, or, bin...)
GRPP.glmana         = [];                   % GLM analysis details
GRPP.glmsigs        = '';                   % Standard input arg for all functions
GRPP.glmseeds       = {'hp','lgn','pfc'};    % Used in PRMKMODEL
GRPP.glmele         = {'elepl','eleth'};    % Used in PRMKMODEL

GRPP.glmdesign  = ARGS.glmdesign;   % Default in rpgetpars.m and ses-def in descr. file

tmp = fieldnames(ANAP.getevent);
for K=1:length(tmp)
  GRPP.glmstruct{K}{1} = tmp{K};
  GRPP.glmstruct{K}{2} = {sprintf('%sroiTs',tmp{K}),sprintf('%sfroiTs',tmp{K})};
end;

GLM_MODELS = {};
for K=1:length(GRPP.glmstruct),
  V = GRPP.glmstruct{K}{1};
  ANAP.getevent.(V).contrasts = {'fVal'};    % First item... continues below..
  for N=1:length(ANAP.getevent.(V).bname),
    ANAP.getevent.(V).contrasts{end+1} = ANAP.getevent.(V).bname{N};
    ANAP.getevent.(V).contrasts{end+1} = strcat(ANAP.getevent.(V).bname{N},'-');
    GLM_MODELS{K}{N} = sprintf('%s/%s_%s.mat[%d]', 'spont', GRPP.glmdesign, V, N);
  end;
end;

%=========================================================================================
% GLM ANALYSIS
%=========================================================================================
GROUPGLM = 'before glm';
switch lower(GRPP.glmdesign),
 case 'siggamrip',
  DNO = 1;
  for K=1:length(GRPP.glmstruct),
    SigName = GRPP.glmstruct{K}{2};
    for S=1:length(SigName),
      GRPP.glm.(SigName{S}).groupglm  = GROUPGLM;
      GRPP.glm.(SigName{S}).glmana = {};
      evt = ANAP.getevent.(GRPP.glmstruct{K}{1});
      GRPP.glm.(SigName{S}).glmana{DNO}.mdlsct = GLM_MODELS{K};

      clear con tst; con{1} = []; tst{1}='f';
      for N=1:length(evt.bname),
        tst{end+1} = 't'; tst{end+1} = 't';
        con{end+1}=zeros(1,length(evt.bname)+1); con{end}(N) = 1;
        con{end+1}=zeros(1,length(evt.bname)+1); con{end}(N) = -1;
      end;
      GRPP.glm.(SigName{S}).glmconts = {};
      for N=1:length(con),
        GRPP.glm.(SigName{S}).glmconts{end+1}=...
            setglmconts(tst{N}, evt.contrasts{N},con{N},'pVal',1.0,'WhichDesign',DNO);
      end;
    end;
  end;

 case 'seed',
  DNO = 1;
  GRPP.glm.glmana = {};
  GRPP.glm.groupglm = 'after glm';
  GRPP.glm.glmana{DNO}.mdlsct = {'wmal','wmar','wmpl','wmpr'};
  GRPP.glm.glmconts = {};
  GRPP.glm.glmconts{end+1}=setglmconts('f','fSeed',  [], 'pVal',0.1,'WhichDesign',DNO);
  GRPP.glm.glmconts{end+1}=setglmconts('t','wmal', [ 1  0  0  0  0],'pVal',1.0,'WhichDesign',DNO);
  GRPP.glm.glmconts{end+1}=setglmconts('t','wmar', [ 0  1  0  0  0],'pVal',1.0,'WhichDesign',DNO);
  GRPP.glm.glmconts{end+1}=setglmconts('t','wmpl', [ 0  0  1  0  0],'pVal',1.0,'WhichDesign',DNO);
  GRPP.glm.glmconts{end+1}=setglmconts('t','wmpr', [ 0  0  0  1  0],'pVal',1.0,'WhichDesign',DNO);
  GRPP.glm.froiTs = GRPP.glm;
  GRPP.glmana     = GRPP.glm.glmana;
  GRPP.glmconts   = GRPP.glm.glmconts;
  
 otherwise,
  fprintf('rpgetpars_monkey: unknown GLMDESIGN\n'); keyboard
end;

%=========================================================================================
% Monkey-Data-Atlas Registration
%=========================================================================================
GRPP.anap.mrhesusatlas2ana.atlas                = 'CoCoMac(brain)';  % Paxinos
GRPP.anap.mrhesusatlas2ana.permute              = [];
GRPP.anap.mrhesusatlas2ana.flipdim              = [2];
GRPP.anap.mrhesusatlas2ana.minvoxels            = 10;
GRPP.anap.mrhesusatlas2ana.spm_coreg.cost_fun   = 'ecc';

MASK_BRAIN_ONLY = 1;
if MASK_BRAIN_ONLY,
  % ====================================================================================
  % ATTENTION: For this to work, we have to run MANA2BRAIN AGAIN for all sessions...
  % ====================================================================================
  GRPP.anap.mana2brain.brain   = 'CoCoMac(brain)';  % Paxinos
end;
GRPP.anap.mana2brain.permute                    = [];
GRPP.anap.mana2brain.flipdim                    = [2];
%=========================================================================================
% **************************************** tkCCA  ****************************************
%=========================================================================================
% ppSigSelect = 'all' is the standard (and best) selection; to see event-effects
% ppSigSelect should be RIPPLE, GAMMA and NOISE
% ppNorm, ppDspDeriv and ppFilt should be as indicated below
% ANAP.tkcca.AllRois includes all ROI-Groups to test for examining effective connectivity
% ANAP.tkcca.AllSelect includes all selections used for this analysis
% ANAP.tkcca.AllSelect    = {'ripple', 'gamma', 'all'}; First run w/out selection...
ANAP.tkcca.AllRois      = {'HF','HippMonSynP', 'HippMonSynN', 'HippPolSyn'};
ANAP.tkcca.AllSelect    = {'all','ripple','gamma'};
ANAP.tkcca.mrisig       = 'roiTs';          % And roiTs/froiTs for fMRI signal
ANAP.tkcca.neusig       = 'blp';            % Use BLP for neural signal
ANAP.tkcca.rois         = 'HF';             % Compute maps for entire brain
ANAP.tkcca.chans        = [];               % Group each type, e.g. pl, sr, cx...
ANAP.tkcca.bands        = [2:6];            % Relevenat BLP-Bands: Delta,Spindle,Gamma,Ripple
ANAP.tkcca.maxlagsec    = 15;               % Lags
ANAP.tkcca.resamplehz   = 1;                % Resample at the freq of fMRI signal
ANAP.tkcca.thr          = 1;                % Threshold for RES.fmri
ANAP.tkcca.addsdf       = 0;                % No need to use SDF        

ANAP.tkcca.ppMode       = 'chan';           % BLPs for each Ch. "blp" Chans for each BLP
ANAP.tkcca.ppNorm       = 'zscore';         % tosdu, zscore, dispderiv
ANAP.tkcca.ppRoiLimit   = 0;                % Use limited portion of ROI
ANAP.tkcca.ppDspDeriv   = 0;                % Dispersion derivative w/ radius=5
ANAP.tkcca.ppFilt       = [0 0];            % [0 0.3] is used for rpgettrial...
ANAP.tkcca.ppSigSelect  = 'all';            % ALL, NOISE, RIPPLE, GAMMA, SPINDLE
ANAP.tkcca.ppTrialWin   = [-5 10];          % Window around ONSET to consider for tkCCA

%=========================================================================================
% **************************************** BPIA ******************************************
%=========================================================================================
% E.G. sesbpia('rat7e1','mtm','spont','pftrboldinfo');
GRPP.bpi.ananame        = 'default'; % Analysis name
GRPP.bpi.smartupdate    = 0;         % Compute only what's missing
GRPP.bpi.grpname        = {};        % Group for which the analysis is run
GRPP.bpi.maxfreq        = 200;       % Max frequency value
GRPP.bpi.maxpcind       = 200;       % Max PC index
GRPP.bpi.nexpperblock   = 5;         % It's a compromise (CM says 2hours!! recordings)
GRPP.bpi.exptime        = [];        % Considering the whole experiment
GRPP.bpi.bold.tsname    = 'roiTs';
GRPP.bpi.bold.decfrac   = 1;         % BOLD decimation factor
GRPP.bpi.bold.roiname   = {'hp','ent','ass','lmb','etc','tha','sc','me','vis', ...
                           'aud','som','mot','striatum','cer'};
GRPP.bpi.bold.alpha     = 1;
GRPP.bpi.bold.model     = '';
GRPP.bpi.bold.cutofflow = 0.30;
GRPP.bpi.bold.cutoffhigh= 0.00;
GRPP.bpi.phys.ch        = [1:3];  % SESSION SPECIFIC
GRPP.bpi.phys.bndedg    = {[.5 5];[6 11];[11 15];[16 40];[40 90];[100 240];[800 3400]};
GRPP.bpi.phys.bndname   = {'cln';'delta';'theta';'sigma';'nmod';'gamma';'ripple';'mua'};

GRPP.bpi.info.pftrstim.method    = 'dr';    % STIMULATION
GRPP.bpi.info.pftrstim.bias      = 'pt';
GRPP.bpi.info.pftrstim.btsp      = 20;
GRPP.bpi.info.pftrstim.npftrbin  = 5;
GRPP.bpi.info.pftrbold.method    = 'dr';    % SPONTANEOUS ACTIVITY
GRPP.bpi.info.pftrbold.bias      = 'pt';
GRPP.bpi.info.pftrbold.corrtype  = 'all';
GRPP.bpi.info.pftrbold.btsp      = 20;
GRPP.bpi.info.pftrbold.npftrbin  = 5;
GRPP.bpi.info.pftrbold.nboldbin  = 5;
GRPP.bpi.info.pftrbold.timerange = [-20 20];

%=========================================================================================
% **************************************** HRF SI ****************************************
%=========================================================================================
ANAP.hrf.method     = 'cra';
ANAP.hrf.roiname    = 'ceL';
ANAP.hrf.chan       = [3 4 5];
ANAP.hrf.pwhitorder = 5;
ANAP.hrf.hrflensec  = 15;
ANAP.hrf.doplot     = 1;

%=========================================================================================
% INDEPENDENT COMPONENT ANALYSIS: PARAMETERS AND BASIC DEFINITIONS
%=========================================================================================
C={[1 0 0],[0 1 1],[0 0 1],[1 0 1],[0 .7 .7],[.7 0 .7],[0 0 .4],[.4 .4 0],[.3 .6 .3],[1 .6 .3]};
GRPP.anap.ica.COLORS            = cat(2,C,C,C);   
GRPP.anap.ica.dim               = 'spatial';        % Temporal does not really work...
GRPP.anap.ica.type              = 'bell';           % The Tony Bell algorithm
GRPP.anap.ica.normalize         =  'none';          % No normalization (e.g. to SD etc.)
GRPP.anap.ica.period            = 'all';            % Blank, stim, all...
GRPP.anap.ica.slices            = [];               % Slices to show
GRPP.anap.ica.SIGNAME           = 'roiTs';        % Signals to analyzie (e.g. roiTs, blp, troiTs)
GRPP.anap.ica.evar_keep         = 15;               % Number of ICs (i.e. PCs) to keep
GRPP.anap.ica.icomp             = [];               % Number of ICs to show with SHOWICA
GRPP.anap.ica.DISP_THRESHOLD    = 1.3;              % For SHOWICA only (ca. 2 SDs)
GRPP.anap.ica.mdlidx            = [];               % E.g. NeuModel.mat[1]...
GRPP.anap.ica.pVal              = 0.01;             % pVal for corr(mixica,IComponent)
GRPP.anap.ica.rVal              = 0.3;              % rVal-thr for corr(mixica,IComponent)
GRPP.anap.ica.roinames          = {'HP','Ent','Tha','Ass'};
GRPP.anap.ica.mdlname           = {'ica'};          % Name for ICs used as models
GRPP.anap.ica.ic2mdl            = [];               % Models, e.g.{[1 3 4], [7 8]} []=averaged
%=========================================================================================
% Parameters used by MVIEW
%=========================================================================================
ANAP.mview.viewmode         = 'lightbox-trans';
ANAP.mview.viewpage         = 1;
ANAP.mview.anascale         = [0  5000  1.3];
ANAP.mview.roi              = 'All';
ANAP.mview.datname          = 'response';
ANAP.mview.alpha            = 0.0001;
ANAP.mview.statistics       = 'glm';
ANAP.mview.glmana.model     = 2;
ANAP.mview.glmana.minmax    = [-3 3];
ANAP.mview.glmana.trial     = 1;
ANAP.mview.cluster          = 0;
ANAP.mview.clusterfunc      = 'mcluster';
ANAP.mview.negcorr          = 1;
ANAP.mview.mcluster3.B      = 3;
ANAP.mview.mcluster3.cutoff =  round((2*(ANAP.mview.mcluster3.B-1)+1)^3*0.3);
ANAP.mview.slices           = [];
%=========================================================================================
% Parameters used by SHOWSPONT
%=========================================================================================
ANAP.showmap.STDERROR   = 1;             % If set uses errorbar otherwise CI
ANAP.showmap.CIVAL      = [1 99];        % low and high confidence interval
ANAP.showmap.BSTRP      = 200;
ANAP.showmap.TRIAL      = [];
ANAP.showmap.FUNCSCALE  = [0 10 1.5];
ANAP.showmap.ANASCALE   = [0 10000 1.2];
ANAP.showmap.DRAW_ROI   = {};
ANAP.showmap.COL_FACE   = [];            % shading color for CI plots
ANAP.showmap.COL_LINE   = 'rgbmckyrgbmck';
ANAP.showmap.MASKNAME   = {'fVal', 'fVal', 'fVal','fVal'};
ANAP.showmap.MODELNAME  = {'fVal', 'fVal', 'fVal','fVal'};
ANAP.showmap.MSKP       = [1  1  1  1];
ANAP.showmap.MDLP       = [1e-4 1e-4 1e-4 1e-4];

ANAP.showspont.ROINAME = {'hp','ent','ass','lmb','tha','sc','me','lc','vis','aud','som','mot','cer'};
ANAP.showspont.CMAP    = {[1 0 0], [.7 0 0], [1 .5 .5],[.8 .7 .2],[1 0 1],[0 0 1],[.5 .5 1],[.3 .3 .7],...
                          [0 1 0],[0 .6 0],[0 .3 0],[0 .6 .3],[.3 0 .3],[.3 .2 .5]};
ANAP.showspont.FACECOL    = [.8 .8 .8];
ANAP.showspont.FUNCSCALE  = [-10 20 1.3];
ANAP.showspont.ANASCALE   = [1000 10000 1.3];
ANAP.showspont.DRAWROI    = 1;
ANAP.showspont.ROINAME    = {'hele','HP','Tha','Vis','Striatum', 'Cer'};
ANAP.showspont.CMAP       = {'r','g','b','m','c','k'};
ANAP.showspont.FACECOL    = [.85 .85 .85];
ANAP.showspont.FUNCSCALE  = [-10 20 1.3];
ANAP.showspont.ANASCALE   = [1000 10000 1.3];
ANAP.showspont.DRAWROI    = 1;
ANAP.showtrois = ANAP.showspont;
% -------------------------------------------------------------------------------------------------------
% CSD parameters
% -------------------------------------------------------------------------------------------------------
GRPP.csdp.csdtype = 'delta-icsd';     % CSD method type
GRPP.csdp.docheck = 1;                % Check on par structure
GRPP.csdp.dosave  = 1;                % Save the CSD
GRPP.csdp.elepos  = [0.01:0.1:1.51];  % Ele position along z-axis from surface
GRPP.csdp.skipch  = [];               % Indices of channels to ignore
GRPP.csdp.interp  = 0;                % Interpolate missing channels
GRPP.csdp.conv2mv = 'adcu2v2au';      % Conversion to mV
GRPP.csdp.vaknin  = 1;                % Apply Vaknin condition (for 'stdcsd' only)
GRPP.csdp.zcond   = 0.3;              % Conductivity along z-axis
GRPP.csdp.scond   = 0;                % Conductivity at surface
GRPP.csdp.ccdiam  = 0.5;              % Diameter of the cortical column 
GRPP.csdp.sfltp   = 1;                % Parameters of (three-point) spatial filter
GRPP.csdp.tfltp   = [0 150];          % Parameters of temporal filter
% -------------------------------------------------------------------------------------------------------
% FLICKER GROUPS - CONTROL FOR BOLD QUALITY AND AREA REGISTRATION
% -------------------------------------------------------------------------------------------------------
FLICK.grproi            = GRPP.grproi;
FLICK.anap.globaldir    = ANAP.project.flicker_dir;
FLICK.anap.allsesmodel  = sprintf('%s/allsesmodel.mat',FLICK.anap.globaldir);
% -------------------------------------------------------------------------------------------------------
% MAREATS - PARAMETERS: DO NOT Change! IFILTER, CUTOFFs etc are the best selection
% -------------------------------------------------------------------------------------------------------
FLICK.anap.mareats        = ANAP.mareats;
FLICK.anap.froiTs.mareats = ANAP.froiTs.mareats;
% -------------------------------------------------------------------------------------------------------
% SESGETTRIAL CONVERSION TO TRIALS
% -------------------------------------------------------------------------------------------------------
FLICK.anap.gettrial.status      = 1;            % We convert to trials
FLICK.anap.gettrial.Average     = 1;            % And average them
FLICK.anap.gettrial.trial2obsp  = 1;            % And the concatenate in a single obsp
FLICK.anap.gettrial.PreT        = 0;            % No PreT (stimulus rather than trial type)
FLICK.anap.gettrial.PostT       = 0;            % No PostT
FLICK.anap.gettrial.IBRAINMEAN  = 0;            % 1=removes mean,2=zscore(dat,[],2)
FLICK.anap.gettrial.Xmethod     = 'none';       % set to zero if IBREANMEAN > 0...
FLICK.anap.gettrial.Xepoch      = 'prestim';    % Normlization-base
FLICK.anap.gettrial.HemoDelay   = 1.0;          % XFORM: Here much shorter than usually!
FLICK.anap.gettrial.HemoTail    = 6;            % XFORM: Same for tail
% -----------------------------------------------------------------------------------------------------
% SESGROUPGLM GLM-ANALYSIS
% -----------------------------------------------------------------------------------------------------
FLICK.anap.glm.IARESTIMATION    = 0;            % AR estimation
FLICK.anap.glm.ISATTERWAITH     = 0;            % Satterwaith
FLICK.anap.glm.ICONVWITHGAMMA   = 0;
FLICK.groupglm                  = 'before glm';
FLICK.anap.glm.glmpreproc       = '';
FLICK.glmsigs                   = {'troiTs'};

% NOTE In contrast to monkey-coronal!!!
% Left part of the image is left side of the BRAIN
ACTIVATION_SPECIFICITY_TEST=1;
if ACTIVATION_SPECIFICITY_TEST,
  if ACTIVATION_SPECIFICITY_TEST==1,
    FLICK.glmconts                  = {};
    J=1; FLICK.glmana{J}.mdlsct     = {'trialhipp[0]','trialhipp[1]'};
    FLICK.glmconts{end+1} = setglmconts('f','fHipp',  [],'pVal',  0.1, 'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','pbr1', [  1   0   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','pbr2', [  0   1   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','nbr1', [ -1   0   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','nbr2', [  0  -1   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','L>R',  [  1  -1   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','R>L',  [ -1   1   0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','RL+',  [ .5  .5  -1], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','RL-',  [-.5 -.5   1], 'pVal',1,'WhichDesign',J);
    J=2; FLICK.glmana{J}.mdlsct     = {'trialcohen[0]','trialcohen[1]'};
    FLICK.glmconts{end+1} = setglmconts('f','fCohen',  [],'pVal',  0.1, 'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','pbr1', [ 1  0  0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','pbr2', [ 0  1  0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','nbr1', [-1  0  0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','nbr2', [ 0 -1  0], 'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','L>R',  [ 1 -1  0],'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','R>L',  [-1  1  0],'pVal',1,'WhichDesign',J);
  else
    % ACTIVATION_SPECIFICITY_TEST==2, means it's a single stimulus... (CHANGE..)
    FLICK.glmconts                  = {};
    J=1; FLICK.glmana{J}.mdlsct     = {'hipp'};
    FLICK.glmconts{end+1} = setglmconts('f','fV1',  [],'pVal',  0.1, 'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','pbr',  [ 1 0],'pVal',1,'WhichDesign',J);
    FLICK.glmconts{end+1} = setglmconts('t','nbr',  [-1 0],'pVal',1,'WhichDesign',J);
  end;  
else
  FLICK.glmconts                  = {};
  J=1; FLICK.glmana{J}.mdlsct     = {'fhemo'};
  FLICK.glmconts{end+1} = setglmconts('f','fV1',  [],'pVal',  0.1, 'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','pbr',  [ 1 0],'pVal',1,'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','nbr',  [-1 0],'pVal',1,'WhichDesign',J);
  J=2; FLICK.glmana{J}.mdlsct     = {'hipp','dtfhemo'};
  FLICK.glmconts{end+1} = setglmconts('f','fV2',  [],'pVal',  0.1, 'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','hipp',   [ 1  0  0],'pVal',1,'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','hipp-',  [-1  0  0],'pVal',1,'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','dthemo', [ 0  1  0],'pVal',1,'WhichDesign',J);
  FLICK.glmconts{end+1} = setglmconts('t','dthemo-',[ 0 -1  0],'pVal',1,'WhichDesign',J);
end;
% -------------------------------------------------------------------------------------------------------
% MVIEW DISPLAY PARAMETERS
% -------------------------------------------------------------------------------------------------------
FLICK.anap.mview.alpha          = 0.001;
FLICK.anap.mview.glmana.model   = 1;
FLICK.anap.mview.cluster        = 0;
FLICK.anap.mview.clusterfunc    = 'mcluster';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ELECTRICAL STIMULAION/FOOTSHOCK GROUPS - CONTROL FOR BOLD QUALITY AND AREA REGISTRATION
% ----------------------------------------------------------------------------------------
% NOTE(TO CHECK STIMULATION PARAMETERS)
% p = expgetpar('e10aw1',26)
% p.stm
%    v: {[1x270 double]}        % Stimulus ID (e.g. 0=red-stimulus, 1=green..)
%  val: {[1x270 double]}        % Value 0=blank, 1, stimulus is on
%   dt: {[1x270 double]}        % duration of each epoch, blank=2s, Stim=4s...
%    t: {[1x271 double]}        % The exact onset-time (increasing function)
% tvol: {[1x271 double]}        % Onset time in volumes
% time: {[1x270 double]}        % Onset time in seconds with msec-resolution
% MODEL(To see the model, one can type):
% EXPMKMODEL('e10aw1',26,'fhemo')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ESTIM.anap.mareats                      = ANAP.mareats;
ESTIM.anap.froiTs.mareats               = ANAP.froiTs.mareats;
ESTIM.anap.froiTs.mareats.IRESAMPLE     = 0.5;
ESTIM.anap.froiTs.mareats.IREMBRAINMEAN = 1;      % Remove brain's average (phys artifacts)
ESTIM.anap.froiTs.mareats.IFILTER       = 1;      % 1=to spatially filter; 0=no filter at all
ESTIM.anap.froiTs.mareats.IFILTER_KSIZE = 5;      % Kernel size (previously 3)
ESTIM.anap.froiTs.mareats.IFILTER_SD    = 2.0;    % Kernel SD (90% of flt in kernel) (previously 1.5)
ESTIM.anap.froiTs.mareats.ICUTOFFHIGH   = 0.020;  % remove very slow oscillations
ESTIM.anap.froiTs.mareats.ICUTOFF       = 0.200;  % 0.5 is Nyquist..

ESTIM.anap.globaldir           = ANAP.project.estim_dir;
ESTIM.anap.allsesmodel         = sprintf('%s/allsesmodel.mat',ESTIM.anap.globaldir);

ESTIM.anap.mview.alpha         = 0.001;         % MVIEW for visualization of results
ESTIM.anap.mview.datname       = 'beta';
ESTIM.anap.mview.cluster       = 1;
ESTIM.anap.mview.clusterfunc   = 'mcluster';
ESTIM.anap.mview.glmana.model  = 2;

ESTIM.anap.gettrial.status     = 1;             % We convert to trials
ESTIM.anap.gettrial.Average    = 1;             % And average them
ESTIM.anap.gettrial.trial2obsp = 1;             % And the concatenate in a single obsp

ESTIM.anap.gettrial.sort       = 'stimulus';
ESTIM.anap.gettrial.PreT       = -5;            % No PreT (stimulus rather than trial type)
ESTIM.anap.gettrial.PostT      = 10;            % No PostT
ESTIM.anap.gettrial.IBRAINMEAN = 0;             % 1=removes mean,2=zscore(dat,[],2)
ESTIM.anap.gettrial.Xmethod    = 'none';        % set to zero if IBREANMEAN > 0...
ESTIM.anap.gettrial.Xepoch     = 'prestim';     % Normlization-base
ESTIM.anap.gettrial.HemoDelay  = 2;             % XFORM: Here much shorter than usually!
ESTIM.anap.gettrial.HemoTail   = 4;             % XFORM: Same for tail

ESTIM.anap.glm.IARESTIMATION   = 0;             % AR estimation
ESTIM.anap.glm.ISATTERWAITH    = 0;             % Satterwaith
ESTIM.anap.glm.ICONVWITHGAMMA  = 0;

ESTIM.grpsigs                  = {'tblp','tfroiTs'};
ESTIM.glmseeds                 = {'hp'};        % Used in PRMKMODEL
ESTIM.glmele                   = {'hp'};        % Used in PRMKMODEL
ESTIM.groupglm                 = 'before glm';  % average experiments before running GLM
ESTIM.glmsigs                  = {'tfroiTs'};   % will be overwritten by 'sigs','tfroiTs'...
ESTIM.glmdesign                = 'estim';       % Regressors: BLP sigs or Seed Regions
ESTIM.glmstruct                = {};
ESTIM.glmconts                 = {};
ESTIM.glmana                   = {};

DNO = 1;
if ischar(ESTIM.glmdesign),
  % TO LOAD AN ALREADY GENERATED MODEL:
  % ESTIM.glmana{DNO}.mdlsct = {sprintf('mdl%s.mat[1]', ESTIM.glmdesign)};
  ESTIM.glmana{DNO}.mdlsct = {'fhemo'};
else
  for N=1:length(ESTIM.glmdesign),
    ESTIM.glmana{N}.mdlsct = ESTIM.glmdesign;
  end;
end;

if iscell(ESTIM.glmdesign),
  ESTIM.anap.glm.modnum = length(ESTIM.glmana{DNO}.mdlsct);
  ESTIM.glmconts{end+1} = setglmconts('f','fVal',  [],        'pVal', 0.1, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','PBR',   [ 1  1  0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','NBR',   [-1 -1  0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','hipp',  [ 1  0  0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','hipp-', [-1  0  0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','cohen', [ 0  1  0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','cohen-',[ 0 -1  0],'pVal', 1.0, 'WhichDesign',DNO);
else
  ESTIM.anap.glm.modnum = length(ESTIM.glmana{DNO}.mdlsct);
  ESTIM.glmconts{end+1} = setglmconts('f','fVal',  [],    'pVal', 0.1, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','PBR',   [ 1 0],'pVal', 1.0, 'WhichDesign',DNO);
  ESTIM.glmconts{end+1} = setglmconts('t','NBR',   [-1 0],'pVal', 1.0, 'WhichDesign',DNO);
end;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VISUAL STIMULAION GROUPS - CONTROL FOR BOLD QUALITY AND AREA REGISTRATION
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout > 5,
  POLAR = ESTIM;        % UPDATED NKL, 30.07.2014
  POLAR.anap.mareats = ANAP.mareats;
  POLAR.anap.mareats.ICUTOFF            = 0.30;       % Lowpass filtering cutoff
  POLAR.anap.mareats.ICUTOFFHIGH        = 0.01;       % Highpass filtering cutoff
  POLAR.anap.mareats.IREMBRAINMEAN      = 0;          % Remove brain's average (phys artifacts)
  POLAR.anap.mareats.ITOSDU             = {'zerobase','prestim'};   % Normalization
  POLAR.anap.mareats.IRESAMPLE          = 1;          % Resample scans with DX = 1sec
  POLAR.anap.mareats.IMIMGPRO           = 1;          % Minimal Image processing
  POLAR.anap.mareats.IFILTER            = 0;          % 1=to spatially filter; 0=no filter at all
  
  POLAR.anap.froiTs.mareats  = POLAR.anap.froiTs.mareats;
  POLAR.anap.froiTs.mareats.IREMBRAINMEAN = 0;      % Remove brain's average (phys artifacts)
  POLAR.anap.froiTs.mareats.IFILTER       = 1;      % 1=to spatially filter; 0=no filter at all
  POLAR.anap.froiTs.mareats.IFILTER_KSIZE = 3;      % Kernel size (previously 3)
  POLAR.anap.froiTs.mareats.IFILTER_SD    = 1.5;    % Kernel SD (90% of flt in kernel) (previously 1.5)
  POLAR.anap.froiTs.mareats.ICUTOFFHIGH   = 0.015;  % remove very slow oscillations
  POLAR.anap.froiTs.mareats.ICUTOFF       = 0.250;  % 0.5 is Nyquist..
  
  POLAR.anap.gettrial.status      = 1;
  POLAR.anap.gettrial.average     = 1;
  POLAR.anap.gettrial.trial2obsp  = 1;
  POLAR.anap.gettrial.IBRAINMEAN  = 0;
  POLAR.anap.gettrial.sort        = 'trial';
  POLAR.anap.gettrial.PreT        = [];
  POLAR.anap.gettrial.PostT       = [];

  POLAR.anap.gettrial.blp.Xmethod = 'zerobase';
  POLAR.anap.gettrial.blp.Xepoch  = 'prestim';
  POLAR.anap.gettrial.Xmethod     = 'zerobase';      
  POLAR.anap.gettrial.Xepoch      = 'prestim';  

  POLAR.anap.gettrial.HemoDelay   = 1;
  POLAR.anap.gettrial.HemoTail    = 6;          
  POLAR.anap.gettrial.ICUTOFF     = 0;
  POLAR.anap.gettrial.ICUTOFFHIGH = 0;
  POLAR.anap.froiTs.gettrial = POLAR.anap.gettrial;
  
  POLAR.anap.glm.glmpreproc = '';
  POLAR.groupglm            = 'before glm'; 
  POLAR.glmsigs             = {'tfroiTs'};
  POLAR.glmana              = {};
  POLAR.glmana{1}.mdlsct    = {'mdlpolar.mat[1]'}; % average(Gamma,Mua)

  POLAR.glmconts            = {};
  POLAR.glmconts{end+1} = setglmconts('f','fVal',  [], 'pVal', 0.1);
  POLAR.glmconts{end+1} = setglmconts('t','pbr',  [ 1  0],'pVal', 1.0);
  POLAR.glmconts{end+1} = setglmconts('t','nbr',  [-1  0],'pVal', 1.0);
  
  POLAR.anap.mview.alpha            = 0.001;
  POLAR.anap.mview.datname          = 'response';
  POLAR.anap.mview.glmana.model     = 2;
  POLAR.anap.mview.cluster          = 1;
  POLAR.anap.mview.clusterfunc      = 'mcluster';
  POLAR.anap.mview.response.minmax  = [-15 15];
end;
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bnd = subGetRespBand(SesName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(SesName),
 case {'e10aw1'}, bnd = [0.0645 0.1007];
 case {'i11bb1'}, bnd = [0.0784 0.1167];
 case {'g10bg1'}, bnd = [0.0826 0.1178];
 case {'e10bv1'}, bnd = [0.0805 0.1199];
 case {'i11bu1'}, bnd = [0.0752 0.1199];
 case {'g10a21'}, bnd = [0.0762 0.1199];
 case {'e10bf1'}, bnd = [0.0773 0.1231];
 case {'i02a11'}, bnd = [0.0805 0.1146];
 case {'e10a31'}, bnd = [0.1402 0.1743];
 case {'g10ax1'}, bnd = [0.0677 0.1007];
 case {'e10ea1'}, bnd = [0.1210 0.1530];
 case {'e10ed1'}, bnd = [0.0784 0.1178];
 case {'i11es1'}, bnd = [0.0762 0.1263];
 case {'i11ef1'}, bnd = [0.0794 0.1178];
 case {'g10gq1'}, bnd = [0.1082 0.1498];
 case {'e10fv1'}, bnd = [0.1039 0.1455];
 case {'g10g41'}, bnd = [0.0773 0.1189];
 case {'e10gb1'}, bnd = [0.0784 0.1231];
 case {'g10gi1'}, bnd = [0.0762 0.1221];
 case {'e10gt1'}, bnd = [0.0784 0.1221];
 case {'g10gd1'}, bnd = [0.1242 0.1626];
 case {'e10gh1'}, bnd = [0.1103 0.1498];
 case {'e10gw1'}, bnd = [0.1093 0.1445];
 case {'e10ha1'}, bnd = [0.0943 0.1349];
end;
return;

