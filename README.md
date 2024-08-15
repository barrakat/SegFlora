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
This repository contains code to reproduce the analyses of the publication *"Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments*", where we conducted multiple UAV flights in an arable area in the eastern Germany with winter barley grown as the main crop under different management intensities. Our goal was to develop an affordable monitoring system for the mapping and conservation of segetal flora using an off-the-shelf UAV-based RGB camera and the YOLO deep learning architecture. Data and trained YOLO models per species can be found in [zenodo](https://zenodo.org/doi/10.5281/zenodo.13325668/).

<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_1.png" width="800"/><br/>
    <b>Figure 1.</b> (a) Study area with training (blue) and test plots (sky blue) under two management types. (b) Onsite segetal flora species and winter barley cover per management type.
</p>

---

## 💻 Inference

The `Centaurea_cyanus_prediction.py` script in [here](https://github.com/barrakat/SegFlora/blob/main/code), for example, can be used to produce instance segmentation of *"Centaurea cyanus*" on UAV-based RGB images of ground sampling distance 1.22-4.88 mm. 

```python
import ultralytics
from ultralytics import YOLO
path = 'https://github.com/barrakat/SegFlora/blob/main/figures/'

# load the trained model
model = '/zenodo/CBarrasso/UAV_SegetalFlora/models/Centaurea_cyanus/best.pt'

# load one test plot monitored at 10, 20 and 40 m above-ground for Centaurea cyanus predictions
image_10m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X10.png"
image_20m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X20.png"
image_30m = "https://github.com/barrakat/SegFlora/blob/main/figures/plot_26_flight_X40.png"

# inference
!yolo predict model=$model source=$image_10m imgsz=864 conf=0.269 project=$path save_txt=True save_conf=True save=True line_width=1 retina_masks=True
!yolo predict model=$model source=$image_20m imgsz=864 conf=0.269 project=$path save_txt=True save_conf=True save=True line_width=1 retina_masks=True
!yolo predict model=$model source=$image_40m imgsz=864 conf=0.269 project=$path save_txt=True save_conf=True save=True line_width=1 retina_masks=True

```

And here the output results for one test plot:
<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_3.png" width="500"/><br/>
</p>


The models were trained on the number of instances per species shown below:

<p align="center">
    <img src="https://github.com/barrakat/SegFlora/blob/main/figures/Figure_2.png" width="500"/><br/>
</p>

---

## 📊 Results

|Species|mIoU|
| --------- | ------- |
| YOLOv8_nano_img640 | 300 epochs, 640 image size on my own instances |
| YOLOv8_nano_img1024 | 100 epochs, 1024 image size on my own instances |
| full_inst_YOLOv8_nano_img640  | 300 epochs, 640 image size on full group instances |
| full_inst_YOLOv8_nano_img1024 | 100 epochs, 1024 image size on full group instances |

In Figure 2, we can observe the relationship between mAP50 (mean Average Precision at IoU 0.50) and the duration and memory usage of the four trained YOLO nano models. The findings indicate that a lower number of epochs and a higher image size led to higher mAP50 scores for both the own instances and the full group instances.

---
## 👏 Acknowledgments

This work was supported by the German Federal Ministry of Education and Research (BMBF, SCADS22B) and the Saxon State Ministry for Science, Culture and Tourism (SMWK) by funding the competence center for Big Data and AI “ScaDS.AI Dresden/Leipzig”. The work was also partly funded by the Horizon European project Earth Bridge (ID: 101079310) and by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany’s Excellence Strategy – EXC 2070 – 390732324. The authors gratefully acknowledge the GWK support for funding this project by providing computing time through the Center for Information Services and HPC (ZIH) at TU Dresden. We thank the UNESCO biosphere reserve “Upper Lusatian Health and Pond Landscape” and the agricultural cooperative “Heidefarm Sdier eG” who allowed us to collect the data for this study. We further thank others who have helped in the data collection and labelling of the images, in particular Sophia Lewitz, Bela Rehnen, Stephanie Roilo, Anja Steingrobe.

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
