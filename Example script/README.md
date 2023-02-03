# Scripts, functions and open platform (Akebia) for sensing Ultrasound Localization Microscopy (sULM)

![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)

<p align="center">
<img src="/Images/logo_akebia.png" height="300">
<img src="/Images/Rat14Kidney_Density.png" height="300">
</p>
<p align = 'center'>
<b>Version 1.0, 15.01.2023</b>
</p>

Repository to share scripts and functions for "_Sensing Ultrasound Localization Microscopy reveals glomeruli in rats and humans_" article, and <em>Akebia</em> software. All functions are usable with agreement from their owner.

## Authors : Louise Denis, Jacques Battaglia. CNRS, Sorbonne Université, INSERM 
Directed by: Olivier Couture, Research Director CNRS, Sorbonne Université, INSERM.

Laboratoire d'Imagerie Biomédicale, Team PPM. 15 rue de l'Ecole de Médecine, 75006, Paris, France.

Code Available under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/)  

Partly funded by the European Research Council under the European Union Horizon H2020 programme / ERC Consolidator grant agreement No 772786-ResolveStroke

## Corresponding authors
* Article : [Louise Denis](mailto:louise.denis@sorbonne-universite.fr), [Sylvain Bodard](mailto:sylvain.bodard@aphp.fr) 

* Scripts, and codes : [Louise Denis](mailto:louise.denis@sorbonne-universite.fr), [Jacques Battaglia](mailto:jacques.battaglia@sorbonne-universite.fr)

* Materials, collaborations, rights and others: [Olivier Couture](mailto:olivier.couture@sorbonne-universite.fr)

## Academic references to be cited
Details of the code in the article by Denis, Bodard, Hingot, Chavignon, Battaglia, Renault, Lager, Aissani, Hélénon, Correas, and Couture. _Sensing Ultrasound Localization Microscopy reveals glomeruli in living rats and humans_, In prep, 2023. 

Inspired from <em>PALA</em> / <em>Lotus</em>: Heiles, Chavignon et al., [_Performance benchmarking of microbubble-localization algorithms for ultrasound localization microscopy_, Nature Biomedical Engineering, 2022 (10.1038/s41551-021-00824-8)](https://www.nature.com/articles/s41551-021-00824-8)

General description of super-resolution in: [Couture et al., _Ultrasound localization microscopy and super-resolution: A state of the art_, IEEE UFFC 2018.](https://doi.org/10.1109/TUFFC.2018.2850811)


## Related Dataset
_In-vivo rat 14_ dataset is available in <em>Zenodo</em>. Patients imaging data are not available due to ethical, medical and legislative considerations towards personal information. 

## 1. Path and location
Before running script, three paths are required and have to be added at the beginning of the `Akebia_example_script.m`: 


* `/src`: the folder with all `Akebia` dedicated functions for the proper running of the `Akebia_example_script.m`.

* `/lib`: the folder with all downloaded functions for the proper running of the example scripts.

* `/examples`: the folder with `akebia_human.m` and `akebia_rat.m` scripts detailed later in this document.

Functions are detailed later in this document.

## 2. Data selection
As detailed in the article, sULM has been used to highlight glomeruli in rats and in humans. Patients imaging data are not available due to ethical, medical and legislative considerations toward personal information. 

Nevertheless, you can choose in the `Akebia_example_script.m` (detailed below) if you work with interpolated data (clinical ultrasound scanner, i.e. humans' data here) or with non-interpolated data (research ultrasound scanner, such as Verasonics, i.e. rats' data here). In general, if your beamformed pixel is bigger than $\frac{\lambda}{2}$, consider your data as non-interpolated. 

Please name your data as explained in the `README` of <em>Zenodo</em>:

* For interpolated data, i.e. humans’ data, your file inside `xx.mat` must be called `bubbles`, with `xx` the number of the block.

* For non-interpolated data, i.e. rats’ data, your files inside `xx.mat` must be called `IQ` for linear data with `xx` the number of the block.

To choose your type of data in the `Akebia_example_script.m`, select:
* `Interpolated = 1`: for interpolated data, i.e. humans’ data. It will run the script `akebia_human.m`.

* `Interpolated = 0`: for non-interpolated data, i.e. rats data. It will run the script `akebia_rat.m`.

All your data must be the same size and must be located in `/DataFolder`. When you run the script, you have to choose the files you want to compute: choose blocs 10 to 20 and 27 to 32 rats files to have the same results as in the `/Results` folder. 

## 3. Parameters selection : Acquisition, sULM and display

You have to select your parameters inside the `akebia_human.m` script and the `akebia_rat.m` script. For this version of <em>Akebia</em>, we consider that pixel was isometric for interpolated data, i.e. pixel size along x-axis is equal to pixel size along z-axis. 

Parameters are defined as follows:

<table>
<thead>
  <tr>
    <th rowspan="6">Acquisition parameters</td>
    <td>frameRate </td>
    <td>Number of frames per second [Hz] </td>
  </tr>
  <tr>
    <td>xPix2Lambda, or xPix2mm</td>
    <td> Width of a pixel [pixel units]</td>
  </tr>
  <tr>
    <td>zPix2Lambda, or zPix2mm</td>
    <td>Height of a pixel [pixel units] </td>
  </tr>
  <tr>
    <td>transmitFreq </td>
    <td>Frequency of your probe acquisition [Hz] </td>
  </tr>
  <tr>
    <td>speedOfSound </td>
    <td>Speed of sound in your media [m/sec] </td>
  </tr>
  <tr>
    <td>lambda2mm </td>
    <td>Value of λ in [mm] </td>
  </tr>
</thead>
<tbody>
  <tr>
    <th rowspan="13">sULM parameters</th>
    <td>name</td>
    <td>Name of your tracking profile </td>
  </tr>
  <tr>
    <td>dataType </td>
    <td> Type of IQ data, interp for human or nointerp for rats </td>
  </tr>
  <tr>
    <td>numberOfParticles </td>
    <td>Estimated number of microbubbles to locate in a frame </td>
  </tr>
  <tr>
    <td>maxGapClosing </td>
    <td>Number of [frames] jumped to pair 2 microbubbles </td>
  </tr>
  <tr>
    <td>minLength </td>
    <td>Minimum duration of the track [frames] </td>
  </tr>
  <tr>
    <td>maxLinkingDistance </td>
    <td>Distance between 2 microbubbles to be paired [pixel unit] </td>
  </tr>
  <tr>
    <td>res </td>
    <td>Resolution factor, factor that multiplies initial grid size [without unit] </td>
  </tr>
  <tr>
    <td>fwhm </td>
    <td>Size [pixel units] of the mask for localization. (3x3 for pixel at λ, 5x5 at λ/2). [fmwhz fmwhx] </td>
  </tr>
  <tr>
    <td>locMethod </td>
    <td>Localization method, see LOTUS </td>
  </tr>
  <tr>
    <td>useBandpass, bandpassBounds </td>
    <td>Use or not of butter filter, Threshold for bandpass filter [Hz] </td>
  </tr>
  <tr>
    <td>useSVD, svdBounds </td>
    <td>Use or not of SVD, Threshold for SVD filter [eigen values] </td>
  </tr>
  <tr>
    <td>varNameInFile </td>
    <td> Name of the variable : 'IQ' for non-interpolated data, and 'bubbles' for interpolated data </td>
  </tr>
  <tr>
    <td>blockSize </td>
    <td>Number of frames in a block [frames] </td>
  </tr>
  <tr>
    <th rowspan="12">Display parameters</th>
    <td>denSig </td>
    <td>Smooth factor for density maps </td>
  </tr>
  <tr>
    <td>denExp </td>
    <td>Power factor for density maps </td>
  </tr>
  <tr>
    <td>denSat </td>
    <td>Saturation factor for density maps </td>
  </tr>
  <tr>
    <td>denSatForDirMap </td>
    <td>Saturation factor for directivity maps </td>
  </tr>
  <tr>
    <td>denExpForDirMap </td>
    <td>Power factor for directivity maps </td>
  </tr>
  <tr>
    <td>denSigForDirMap </td>
    <td>Smooth factor for directivity maps </td>
  </tr>
  <tr>
    <td>cDirExp </td>
    <td>Power factor for total directivity map </td>
  </tr>
  <tr>
    <td>cDirSig </td>
    <td>Smooth factor for total directivity map </td>
  </tr>
  <tr>
    <td>vMaxDisp </td>
    <td>Maximum velocity [mm/sec] to normalize velocity map </td>
  </tr>
  <tr>
    <td>cDenSat </td>
    <td>Saturation factor for velocity map </td>
  </tr>
  <tr>
    <td>cVelSig </td>
    <td>Smooth factor for velocity map </td>
  </tr>
  <tr>
    <td>cDenExp </td>
    <td>Power factor for velocity map </td>
  </tr>
</tbody>
</table>

You can define as many `trackingParams` you want (with sULM parameters completed) to have as many tracking profiles you want. By default, 2 tracking profiles are defined with same sULM parameters as in the article (one "Slow" and one "Rapid"). Similarly, acquisition parameters and display parameters are completed by default with same values as in the article. The display is intended to be the composite of 2 maps corresponding to 2 different tracking profiles.

## 4. Parallel execution 

Before running sULM with selected parameters, you need to choose your computing options, which corresponds to the selection of the number of workers that will work on parallel to accelerate the calculation. If you don't know how many workers your computer has, select "Sequential" execution.

* In `examples/akebia_human.m`, it corresponds to:

    * Parallel execution : `parfor iFile = 1:min(90,nFiles)`

    * Sequential execution : `for iFile = 1:nFiles`

* In `examples/akebia_rat.m`, it corresponds to:

    * Parallel execution : `parfor iFile = 1:min(90,nFiles)`

    * Sequential execution : `for iFile = 1:nFiles`

To select your computing option, comment the unwanted computing option while uncommenting the other.

## 5. Main example script
A main example script, called `Akebia_example_script.m`, of sULM is provided in the folder `examples/`. All functions are called from this main script. This script generates 3 composite images from 2 tracking profiles by superimposing them, as in the article for slow and rapid tracking : 

* Image density based on microbubbles counts: pixel intensity codes the number of microbubbles crossing this pixel.

* Image density with axial color encoding: pixel intensity codes the number of micro-bubbles crossing upward/downward.

* Velocity magnitude image: pixel intensity represents the average bubble velocity in _mm/s_.

## 6. Functions
All functions are called in the `Akebia_example_script.m`. These functions are divided into 3 subfolders. 

* `/lib`: specific functions that have been added to the path and that can be downloaded from :

  * SimpleTracker: Jean-Yves Tinevez (2020). simpletracker ([Retrieved April 22, 2020 on Github](https://www.github.com/tinevez/simpletracker) or available in [MATLAB Central File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/34040-simpletracker)).

  * ULM-PALA : Heiles (2022). PALA ([Retrieved February 22, 2022 on Github](https://github.com/AChavignon/PALA)).

* `/src`: main functions required for sULM processing are provided in this folder.

  * `/app`: contains 2 functions called to load the data (`LoadData.m`) and create a tracking profile (`CreateTrackingProfile.m`).

  * `/compute`: contains main sULM functions to filter, localize and track in the interpolated (`BlockInterp2Track.m`, `ULM_localization2D_interp.m`) and noninterpolated case (`BlockNoInterp2Track.m`). It also contains a function to display composite map (`Track2MatOut_multi.m`).

  * `/plot`: contains functions to display density map (`PlotDensity.m`), directivity map (`PlotDirectivity.m`) and velocity map (`PlotVelocity.m`) with adapted scale bar (`PlotScaleBar.m`).

* `/examples`: `Akebia_example_script.m` main script that calls `akebia_human.m` for interpolated data and `akebia_rat.m` for non-interpolated data.

## Disclaimer
THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

by LD, JB, OC.
