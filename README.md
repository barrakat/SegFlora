<div align="center">
<h2>Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments</h2>

**Caterina Barrasso**<sup>1,2</sup> · **Robert Krüger**<sup>3</sup> · **Anette Eltner**<sup>3</sup> · **Anna Cord**<sup>1,2,4</sup>

<sup>1</sup>Chair of Computational Landscape Ecology, TUD;&emsp;&emsp;&emsp;<sup>2</sup>ScaDS.AI;&emsp;&emsp;&emsp;
<sup>3</sup>Juniorprofessorship in Geosensor Systems, TUD;&emsp;&emsp;&emsp;<sup>4</sup>Agro-Ecological Modeling Group, University of Bonn

[![DOI](https://zenodo.org/badge/639127835.svg)](https://zenodo.org/doi/10.5281/zenodo.13325668)
</div>
<p align="center">
<img src="https://github.com/barrakat/SegFlora/blob/main/figures/logo.png" width="800"/>
</p>
</div> 

---

[📘 About](#-about)
[💻 Inference](#-inference)
[📊 Results](#-results)
[👏 Acknowledgments](#-acknowledgments)
[📝 Citation](#-citation)

---

## 📘 About
This repository contains code to reproduce the analyses presented in the publication *"Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments*". In this study, we conducted multiple UAV flights in an arable area in Germany with winter barley grown as the main crop under different management intensities. The objective was to develop an affordable monitoring system to facilitate the implementation of result-based payments in arable land, thereby contributing to the conservation of segetal flora species. The study investigates species detectability and ground sampling distance trade-offs to effectively monitor segetal flora using an off-the-shelf UAV-based RGB camera and the YOLO deep learning architecture. Data and trained YOLO models per species can be found in [zenodo](https://zenodo.org/records/13325668).

<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_1.png" width="800"/><br/>
    <b>Figure 1.</b> (a) Study area with training (blue) and test plots (sky blue) under two management types. (b) Onsite segetal flora species and winter barley cover per management type.
</p>

---

## 💻 Inference

The `Centaurea_cyanus_prediction.py` script in [here](https://github.com/barrakat/SegFlora/blob/main/code), for example, can be used for instance segmentation of *"Centaurea cyanus*" on UAV-based RGB imagery with a ground sampling distance of 1.22-4.88 mm. The following code illustrates how to utilize the trained model:

```python

import ultralytics
from ultralytics import YOLO
out = 'https://github.com/barrakat/SegFlora/blob/main/figures/'

# load the trained model stored in zenodo
model = '/zenodo/CBarrasso/UAV_SegetalFlora/models/Centaurea_cyanus/best.pt'

# load RGB images collected at 10, 20 and 40 m above-ground in one test plot. All test plots images are stored
# in zenodo

image_10m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X10.png"
image_20m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X20.png"
image_30m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X40.png"

# inference
!yolo predict model=$model source=$image_10m imgsz=864 conf=0.269 project=$out save_txt=True save_conf=True save=True line_width=1 retina_masks=True
!yolo predict model=$model source=$image_20m imgsz=864 conf=0.269 project=$out save_txt=True save_conf=True save=True line_width=1 retina_masks=True
!yolo predict model=$model source=$image_40m imgsz=864 conf=0.269 project=$out save_txt=True save_conf=True save=True line_width=1 retina_masks=True

```

And here the output results for one test plot:
<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_2.png" width="1000"/><br/>
</p>


The models were trained on the number of instances per species shown below:

<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_3.png" width="1000"/><br/>
</p>

---

## 📊 Results

|Species|mean mIoU - extensive management|mean mIoU - intensive management|
| --------- | ------- |  ------- | 
| *Anchusa arvensis* |0.7|0.7| 
| *Centaurea cyanus*  |0.8|1.0| 
| *Cirsium arvense*  |0.9|1.0| 
| *Equisetum arvense*  |0.9|0.9| 
| *Papaver dubium*  |0.8|1.0 | 
| *Tripleurospermum inodorum*  |0.9|1.0|
| *Vicia* spec.  |0.5|1.0|

In Figure 2, we can observe the relationship between mAP50 (mean Average Precision at IoU 0.50) and the duration and memory usage of the four trained YOLO nano models. The findings indicate that a lower number of epochs and a higher image size led to higher mAP50 scores for both the own instances and the full group instances.

---
## 👏 Acknowledgments

CB received financial support from the German Federal Ministry of Education and Research (BMBF) and the Saxon State Ministry of Science, Culture and Tourism (SMWK) by funding the “Center for Scalable Data Analytics and Artificial Intelligence Dresden/Leipzig”, project identification number: SCADS24B. RK was funded by the Horizon Europe project Earth Bridge (grant agreement no. 101079310). AFC was supported by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany’s Excellence Strategy – EXC 2070 – 390732324. Views and opinions expressed are, however, those of the authors only and do not necessarily reflect those of the European Union. Neither the European Union nor the granting authority can be held responsible for them. The authors gratefully acknowledge the GWK support for funding this project by providing computing time through the Center for Information Services and HPC (ZIH) at TU Dresden. We would like to thank the UNESCO biosphere reserve “Upper Lusatian Health and Pond Landscape” and the agricultural cooperative “Heidefarm Sdier eG” for allowing us to collect the data for this study and for logistic support. We further thank others who helped with data collection and labeling of the images, in particular Sophia Lewitz, Bela Rehnen, Stephanie Roilo and Anja Steingrobe.

---

## 📝 Citation

How to cite this work:

```
@article{BarrassoC.,
  title={Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments},
  author={Caterina Barrasso, Robert Krüger, Anette Eltner, Anna F. Cord},
  journal={under review in: Remote Sensing in Ecology and Conservation},
  year={}
}
```



---
