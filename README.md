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

## Structure
[📘 About](#-about)
[💻 Inference](#-inference)
[📊 Results](#-results)
[👏 Acknowledgments](#-acknowledgments)
[📝 Citation](#-citation)

---

## 📘 About
This repository contains code to reproduce the analyses of the publication "Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments" where we conducted multiple UAV flights in an arable area in the East of Germany with winter barley grown as main crop under different management intensities. Our goal was to develop an affordable monitoring system for mapping and conservation of segetal flora using an off-the-shelf UAV-based RGB camera and the YOLO deep learning architecture. Data and trained YOLO models per species can be found in [zenodo](https://zenodo.org/doi/10.5281/zenodo.13325668/)

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_1.png" width="900" />
<ins><figcaption>Figure 1</figcaption></ins>
<figure>
</pre> 

---

## 💻 Inference

We provide a `train.py` script for reproducing experiments in the paper.

```bash
usage: train.py [-h] [--batch_size BATCH_SIZE] [--model {deeplabv3+,fcn,custom_fcn,unet,unet++}] [--num_epochs NUM_EPOCHS]
                [--num_filters NUM_FILTERS]
                [--backbone {resnet18,resnet34,resnet50,resnet101,resnet152,resnext50_32x4d,resnext101_32x8d}] [--lr LR] [--tmax TMAX]
                [--experiment_name EXPERIMENT_NAME] [--gpu_id GPU_ID] [--root_dir ROOT_DIR]

Train a semantic segmentation model.

options:
  -h, --help            show this help message and exit
  --batch_size BATCH_SIZE
                        Size of each mini-batch.
  --model {deeplabv3+,fcn,custom_fcn,unet,unet++}
                        Model architecture to use.
  --num_epochs NUM_EPOCHS
                        Number of epochs to train for.
  --num_filters NUM_FILTERS
                        Number of filters to use with FCN models.
  --backbone {resnet18,resnet34,resnet50,resnet101,resnet152,resnext50_32x4d,resnext101_32x8d}
                        Backbone architecture to use.
  --lr LR               Learning rate to use for training.
  --tmax TMAX           Cycle size for cosine lr scheudler.
  --experiment_name EXPERIMENT_NAME
                        Name of the experiment to run.
  --gpu_id GPU_ID       GPU ID to use (defaults to all GPUs if none).
  --root_dir ROOT_DIR   Root directory of the dataset.
```

Code in folder [here](https://github.com/barrakat/NOVA/blob/main/Code).

```python
from urllib import request

import detectree as dtr
import matplotlib.pyplot as plt
import rasterio as rio
from rasterio import plot

# download a tile from the SWISSIMAGE WMS
tile_url = (
    "https://wms.geo.admin.ch/?SERVICE=WMS&REQUEST=GetMap&VERSION=1.3.0&"
    "FORMAT=image/png&LAYERS=ch.swisstopo.images-swissimage&CRS=EPSG:2056"
    "&BBOX=2532980,1152150,2533380,1152450&WIDTH=800&HEIGHT=600"
)
tile_filename = "tile.png"
request.urlretrieve(tile_url, tile_filename)

# use the pre-trained model to segment the image into tree/non-tree-pixels
y_pred = dtr.Classifier().predict_img(tile_filename)

# side-by-side plot of the tile and the predicted tree/non-tree pixels
figwidth, figheight = plt.rcParams["figure.figsize"]
fig, axes = plt.subplots(1, 2, figsize=(2 * figwidth, figheight))
with rio.open(tile_filename) as src:
    plot.show(src, ax=axes[0])
axes[1].imshow(y_pred)
```

|Model|Description|
| --------- | ------- |
| YOLOv8_nano_img640 | 300 epochs, 640 image size on my own instances |
| YOLOv8_nano_img1024 | 100 epochs, 1024 image size on my own instances |
| full_inst_YOLOv8_nano_img640  | 300 epochs, 640 image size on full group instances |
| full_inst_YOLOv8_nano_img1024 | 100 epochs, 1024 image size on full group instances |

In Figure 2, we can observe the relationship between mAP50 (mean Average Precision at IoU 0.50) and the duration and memory usage of the four trained YOLO nano models. The findings indicate that a lower number of epochs and a higher image size led to higher mAP50 scores for both the own instances and the full group instances.

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_2.png" width="900" />
<ins><figcaption>Figure 2</figcaption></ins>
<figure>
</pre> 

The models YOLOv8_nano_img1024 and full_inst_YOLOv8_nano_img1024 were subsequently utilized to make predictions and evaluate their performance in the four testing areas depicted in Figure 1.

---

## 📊 Results

Below, in Figures 3 and 4, the confusion matrix, F1 score and scatterplot of predictions vs reference observations obtained with the two models: YOLOv8_nano_img1024 and full_inst_YOLOv8_nano_img1024

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_3.png" width="900" />
<ins><figcaption>Figure 3</figcaption></ins>
<figure>
</pre> 

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_4.jpg" width="900" />
<ins><figcaption>Figure 4</figcaption></ins>
<figure>
</pre> 

---
## 👏 Acknowledgments

> - `This work was supported by the German Federal Ministry of Education and Research (BMBF, SCADS22B) and the Saxon State Ministry for Science, Culture and Tourism (SMWK) by funding the competence center for Big Data and AI “ScaDS.AI Dresden/Leipzig”. The work was also partly funded by the Horizon European project Earth Bridge (ID: 101079310) and by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany’s Excellence Strategy – EXC 2070 – 390732324. The authors gratefully acknowledge the GWK support for funding this project by providing computing time through the Center for Information Services and HPC (ZIH) at TU Dresden. We thank the UNESCO biosphere reserve “Upper Lusatian Health and Pond Landscape” and the agricultural cooperative “Heidefarm Sdier eG” who allowed us to collect the data for this study. We further thank others who have helped in the data collection and labelling of the images, in particular Sophia Lewitz, Bela Rehnen, Stephanie Roilo, Anja Steingrobe.`
---

## 📝 Citation

How to cite this work:

```
@article{barrasso2024,
  title={Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments},
  author={Caterina Barrasso, Robert Krüger, Anette Eltner, Anna F. Cord},
  journal={under review in: Remote Sensing in Ecology and Conservation},
  year={}
}
```



---
