# Scripts, functions and open platform (Akebia) for sensing Ultrasound Localization Microscopy (sULM)

![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)

<p align="center">
<img src="/Images/logo_akebia.png" height="300">
<img src="/Images/Rat14Kidney_Density.png" height="300">
</p>
<p align ="center">
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

## Folder's organization
* `/Example script`

  This folder contains an example script of sULM and all functions called in the <em>Akebia</em> software. The script generates 3 composite images, i.e. slow and rapid tracking are superimposed: 

  * Image density based on microbubbles counts: pixel intensity codes the number of microbubbles crossing this pixel

  * Image density with axial color encoding: pixel intensity codes the number of microbubbles crossing upward/downward

  * Velocity magnitude image: pixel intensity represents the average bubble velocity in _mm/s_

  More details in the `README` inside this folder.

* `/Software_Akebia`

  This folder contains the open platform <em>Akebia</em>. It is a standalone application and there's no need to own Matlab to install this software. More details in the `README` and the `User Guide` inside this folder.

* `/Results`

  Example of images generated by the example script `Akebia_example_script.m` or by the <em>Akebia</em> software after processing the _In-vivo rat 14_ dataset : blocks 10 to 20 and 27 to 32 of 800 frames each.

  `Density.tif`, `Directivity.tif` and `Velocity.tif` are presented here. But you can also find `HumanDensity.tif`, `HumanDirectivity.tif` and `HumanVelocity.tif` of patient number 1 (same as in the article). More details in the `README` inside `/Example script` and `/Software Akebia`.

## Disclaimer
THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

by LD, JB, OC.