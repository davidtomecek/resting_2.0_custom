# RESTING pipeline

## Description
This is a resting-state fMRI session.

## Data acqusition
### IKEM
The MRI data acquisition was performed on a 3 Tesla Siemens Trio scanner equipped with a standard 12-channel head coil.  

****Structural 3-dimensional (3D) images**** were obtained for anatomical reference using the T1-weighted (T1w) magnetization-prepared rapid gradient echo (MPRAGE) sequence with the following parameters: repetition time (TR) of 2300ms, echo time (TE) 4.6ms, flip angle 10°, voxel size of 1×1×1mm<sup>3</sup>, field of view (FOV) 256mm×256mm, matrix size 256×256, 224 sagittal slices.  
****Functional images**** were obtained using the T2\*-weighted (T2\*w) gradient echo-planar imaging (GR-EPI) sequence sensitive to the blood oxygenation level-dependent (BOLD) signal with following parameters: repetition time (TR) of 2000ms, echo time (TE) 30ms, flip angle 70°, voxel size of 3×3×3mm<sup>3</sup>, field of view (FOV) 144mm×192mm, matrix size 48×64, each volume with 35 axial slices (slice order: sequential decreasing), 400 volumes in total.

### NUDZ
The MRI data acquisition was performed on a 3 Tesla Siemens Prisma scanner equipped with a standard 64-channel/20-channel head coil.  

****Structural 3-dimensional (3D) images**** were obtained for anatomical reference using the T1-weighted (T1w) magnetization-prepared rapid gradient echo (MPRAGE) sequence with the following parameters: repetition time (TR) of 2400ms, echo time (TE) 2.3ms, flip angle 8°, voxel size of 0.7×0.7×0.7mm<sup>3</sup>, field of view (FOV) 224mm×224mm, matrix size 320×320, 240 sagittal slices.  
****Functional images (ver. 1)**** were obtained using the T2\*-weighted (T2\*w) gradient echo-planar imaging (GR-EPI) sequence sensitive to the blood oxygenation level-dependent (BOLD) signal with following parameters: repetition time (TR) of 2000ms, echo time (TE) 30ms, flip angle 70°, voxel size of 3×3×3mm<sup>3</sup>, field of view (FOV) 192mm×192mm, matrix size 64×64, each volume with 37 axial slices (slice order: alternating increasing), 300 volumes in total.  
****Functional images (ver. 2)**** were obtained using the T2\*-weighted (T2\*w) gradient echo-planar imaging (GR-EPI) sequence sensitive to the blood oxygenation level-dependent (BOLD) signal with following parameters: repetition time (TR) of 1000ms, echo time (TE) 30ms, flip angle 52°, voxel size of 3×3×3mm<sup>3</sup>, field of view (FOV) 222mm×222mm, matrix size 74×74, each volume with 60 axial slices (multiband sequence with factor 4), 400 volumes in total.

## Data pre-processing and analysis
This pipeline provides a set of tools for fMRI data preprocessing, signal extraction, and denoising. It uses the well-established CONN toolbox (Whitfield-Gabrieli et Nieto-Castanon, 2012) for MATLAB (The MathWorks, Inc., Massachusetts, USA) and basic FSL library tools (FMRIB, Oxford, UK).  

First, the structural and functional images were converted from DICOM to NIFTI format using the dcm2niix tool (Li et al., 2016). Following steps were performed with the functional data: bias field correction (if 64-channel head coil was used), functional realignment and unwarp; slice-timing correction; outlier identification; direct segmentation and normalization; and functional smoothing - pipeline labeled as "default preprocessing pipeline for volume-based analyses (direct normalization to MNI-space)" in CONN toolbox (Whitfield-Gabrieli et Nieto-Castanon, 2012).  

## Data denoising
### 'stringent'
To calculate the functional connectivity (FC), we used the AAL 116 atlas (Rolls et al., 2020) and extracted average time series from each of those 116 regions. For calculation of the functional network connectivity (FNC), we used Independent Component Analysis (ICA)-derived spatial masks that corresponded to anterior default mode network (aDMN), posterior default mode network (pDMN), and central executive network (CEN), as well as Gordon (Gordon et al., 2016) atlas-based regions that corresponded to the default mode network (DMN) and dorsal attention network (DAN) and extracted their 1st principal components. All time series were then orthogonalized against 5 principal components of: cerebrospinal fluid (CSF), white matter (WM), and 12 motion parameters (six original parameters and their temporal derivatives), linearly detrended and band-pass filtered using the Butterworth filter with a window of 0.008 - 0.09 Hz. Connectivity matrices are computed using a weighted Least Squares (WLS) linear model. The final connectivity values are represented by the Pearson's r correlation coefficients.  

### 'moderate'
To calculate the functional connectivity (FC), we used the AAL 116 atlas (Rolls et al., 2020) and extracted average time series from each of those 116 regions. For calculation of the functional network connectivity (FNC), we used Independent Component Analysis (ICA)-derived spatial masks that corresponded to anterior default mode network (aDMN), posterior default mode network (pDMN), and central executive network (CEN), as well as Gordon (Gordon et al., 2016) atlas-based regions that corresponded to the default mode network (DMN) and dorsal attention network (DAN) and extracted their 1st principal components. All time series were then orthogonalized against the average signal of: cerebrospinal fluid (CSF), white matter (WM), and 6 motion parameters, band-pass filtered using the Butterworth filter with a window of 0.008 - 0.09 Hz. Connectivity matrices are computed using a weighted Least Squares (WLS) linear model. The final connectivity values are represented by the Pearson's r correlation coefficients.  

### 'raw'
To calculate the functional connectivity (FC), we used the AAL 116 atlas (Rolls et al., 2020) and extracted average time series from each of those 116 regions. For calculation of the functional network connectivity (FNC), we used Independent Component Analysis (ICA)-derived spatial masks that corresponded to anterior default mode network (aDMN), posterior default mode network (pDMN), and central executive network (CEN), as well as Gordon (Gordon et al., 2016) atlas-based regions that corresponded to the default mode network (DMN) and dorsal attention network (DAN) and extracted their 1st principal components. No denoising was applied to the extracted time series - raw time series! Connectivity matrices are computed using a weighted Least Squares (WLS) linear model. The final connectivity values are represented by the Pearson's r correlation coefficients.  

To run the pipeline, follow the instruction below.

- Run the `run_resting_pipeline.sh` script with the inputs given below:

	- export # Hydra export directory
	- target # Target directory where the resulting data will be stored
	- scripts # Scripts
	- dependencies # atlases, ROIs, ...

```bash
$ ./run_resting_pipeline.sh <export> <target> <scripts> <dependencies>
```

The main outputs from this pipeline are:

`AAL116_fc_resting*.csv`
- AAL 116 (Rolls et al., 2020) atlas-based functional connectivity (FC) estimated for the "other-influenced" condition from the joystick task experiment.

`AAL116_ts_resting*.csv`
- Time series extracted from the corresponding regions of the AAL 116 (Rolls et al., 2020) atlas.

`rois_fnc_resting*.csv`
- ICA (Independent Component Analysis)-derived functional network connectivity (FNC) between anterior default mode network (aDMN), posterior default mode network (pDMN), and central executive network (CEN).
- Gordon (Gordon et al., 2016) atlas-based functional network connectivity (FNC) between default mode network (DMN) and dorsal attention network (DAN).

`rois_ts_resting*.csv`
- Time series extracted from the ICA (Independent Component Analysis)-derived brain networks.

## References
Gordon EM, Laumann TO, Adeyemo B, Huckins JF, Kelley WM, Petersen SE. Generation and Evaluation of a Cortical Area Parcellation from Resting-State Correlations. Cereb Cortex. 2016 Jan;26(1):288-303. doi: 10.1093/cercor/bhu239. Epub 2014 Oct 14. PMID: 25316338; PMCID: PMC4677978.  

Li X, Morgan PS, Ashburner J, Smith J, Rorden C. The first step for neuroimaging data analysis: DICOM to NIfTI conversion. J Neurosci Methods. 2016 May 1;264:47-56. doi: 10.1016/j.jneumeth.2016.03.001. Epub 2016 Mar 2. PMID: 26945974.  

Rolls ET, Huang CC, Lin CP, Feng J, Joliot M. Automated anatomical labelling atlas 3. Neuroimage. 2020 Feb 1;206:116189. doi: 10.1016/j.neuroimage.2019.116189. Epub 2019 Sep 12. PMID: 31521825.  

Whitfield-Gabrieli S, Nieto-Castanon A. Conn: a functional connectivity toolbox for correlated and anticorrelated brain networks. Brain Connect. 2012;2(3):125-41. doi: 10.1089/brain.2012.0073. Epub 2012 Jul 19. PMID: 22642651.  

