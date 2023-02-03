# Scripts, functions and open platform (Akebia) for sensing Ultrasound Localization Microscopy (sULM)

![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)

<p align="center">
<img src="/Images/logo_akebia.png" height="300">
<img src="/Images/Rat14Kidney_Density.png" height="300">
</p>
<p align = "center">
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

## 1. Data selection
As detailed in the article, sULM has been used to highlight glomeruli in rats and in humans. Patients imaging data are not available due to ethical, medical and legislative considerations toward personal information. 

Nevertheless, you can choose in the <em>Akebia</em> software (details in `User Guide`) if you work with interpolated data (clinical ultrasound scanner, i.e. humans' data here) or with non-interpolated data (research ultrasound scanner, such as Verasonics, i.e. rats' data here). In general, if your beamformed pixel is bigger than $\frac{\lambda}{2}$, consider your data as non-interpolated.

Please name your data as explained in <em>Zenodo</em> :

* For interpolated data, i.e. humans’ data, your variable inside `xx.mat` must be called `bubbles`, with `xx` the number of the block.

* For non-interpolated data, i.e. rats’ data, your variable inside `xx.mat` must be called `IQ` for linear data, with `xx` the number of the block.

Please refer to the `User Guide` for a step by step explanation

## 2. Minimum requirements

<em>Akebia</em> software integrates MATLAB Runtime R2021a (9.10) (MathWorks). We recommend using Microsoft Windows 10 (version 1803 or higher), with 8 GB RAM minimum, and 5 GB of free space. This space does not include the space required for data.

For a computation for the example of the rat's blocks 10 to 20 and 27 to 32, the RAM needed is 8GB. You need to have [Windows C++ redistributable](https://docs.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170) to make the <em>Akebia</em> software work properly. If it's not the case, click into the link to download it.

## 3. Installation
1. Launch the installer `Akebia_v1_installer.exe`
1. Follow the installers' instructions
1. Restart your computer
1. <em>Akebia</em> should be now available for use in the start-up menu

## 4. Use
Please refer to the `User Guide` for a step by step explanation.

## Disclaimer
THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

by LD, JB, OC.
