<div align="center">
<h2>Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments</h2>

**Caterina Barrasso**<sup>1,2</sup> · **Robert Krüger**<sup>3</sup> · **Anette Eltner**<sup>3</sup> · **Anna Cord**<sup>1,2,4</sup>

<sup>1</sup>Chair of Computational Landscape Ecology, TUD;&emsp;&emsp;&emsp;<sup>2</sup>ScaDS.AI;&emsp;&emsp;&emsp;
<sup>3</sup>Geosensor Systems Group, TUD;&emsp;&emsp;&emsp;<sup>4</sup>University of Bonn

<a href="https://arxiv.org/abs/2401.06762"><img src='https://img.shields.io/badge/arXiv-Seeing%20the%20Roads%20Through%20the%20Trees-red' alt='Paper PDF'></a>
<a href='https://huggingface.co/datasets/torchgeo/ChesapeakeRSC/'><img src='https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-ChesapeakeRSC%20Dataset-yellow'></a>
</div>
<p align="left">
<img src="https://github.com/barrakat/SegFlora/blob/main/figures/logo.png" width="900" />
</p>
</div> 

---

## 📒 Project Structure
[📍 About](#-about)
[🧪 Running Tests](#-running-tests)
[💻 Results](#-results)
[🗺 Discussion](#-discussion)
[👏 Acknowledgments](#-acknowledgments)

---


## 📍 About

In this project, I am comparing the performance of the best-trained tree seedling detector in Norway. I am using my own labeled instances (530 in total, shown as red quadrants in Figure 1A) extracted from 82 tiled orthomosaics, each measuring 10 meters. These results are being compared against the full instances labeled by the entire class group (5074 in total, shown as blue quadrants in Figure 1A) from 3065 tiled orthomosaics of the same size (Figure 1C).

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_1.png" width="900" />
<ins><figcaption>Figure 1</figcaption></ins>
<figure>
</pre> 

I trained two different models for each instance group, as explained in the "Running Tests" section below. Subsequently, I discuss the performance results obtained in four specific areas in Norway (depicted in Figure 1B). These results are elaborated upon in the "Results" section below.

---

## 🧪 Running tests

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

## 💻 Results

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
## 🗺 Discussion

> - `ℹ️ Point 1` --> Training the models with an increased image size primarily had an impact on the memory usage for YOLOv8_nano and both memory usage and duration for full_inst_YOLOv8_nano. However, despite these differences, the mAP50 consistently showed improvement when image size was increased and epochs were reduced. Comparing YOLOv8_nano_img1024 and full_inst_YOLOv8_nano_img1024, it was observed that YOLOv8_nano_img1024 achieved a doubled mAP50 compared to full_inst_YOLOv8_nano_img1024, while also requiring nearly 1/4th of the training duration (as illustrated in Figure 2).

> - `ℹ️ Point 2` --> The model trained on my own 530 instances (YOLOv8_nano_img1024) demonstrated a remarkably similar accuracy compared to the model trained on the full 5074 instances (full_inst_YOLOv8_nano_img1024), with F1 scores of 0.45 and 0.48, respectively. Notably, YOLOv8_nano_img1024 exhibited slightly higher true positives and lower false positives, as indicated in Figure 4. Considering the lower training duration illustrated in Figure 2 and the highly comparable accuracy displayed in Figure 4, training on a smaller number of instances proved to be more convenient in this particular case.

> - `ℹ️ Point 3` --> Figure 5 presents several observed examples where the YOLOv8_nano_img1024 model (highlighted in red) failed to make accurate predictions, as denoted by the green boxes. One of the primary strategies for enhancing model accuracy involves improving the quality of training instances. In Figure 5, three specific examples provide valuable insights for improving data quality: i) Labeling more big leafless trees: Including additional labeled instances of large leafless trees would facilitate their proper mapping and detection, ii) Careful labeling of plant species: Paying close attention to the accuracy of plant species labeling is crucial for precise predictions, iii) Exploring alternative tile sizes for data labeling: Trying different tile sizes during the labeling process can help prevent the occurrence of two predicted bounding boxes on the same tree.

By implementing these suggested improvements, it is anticipated that the overall accuracy of the model can be enhanced.

<pre>
<figure>
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Figure_5.png" width="900" />
<ins><figcaption>Figure 5</figcaption></ins>
<figure>
</pre> 

---

## Citation

How to cite this work:

```
@article{barrasso2024,
  title={Remote sensing of segetal flora in arable fields using off-the-shelf UAV-based imagery and deep learning for result-based payments},
  author={Caterina Barrasso, Robert Krüger, Anette Eltner, Anna F. Cord},
  journal={under review in: Remote Sensing in Ecology and Conservation},
  year={}
}
```
BibTeX:
```
@article{DeepWeeds2019,
  author = {Alex Olsen and
    Dmitry A. Konovalov and
    Bronson Philippa and
    Peter Ridd and
    Jake C. Wood and
    Jamie Johns and
    Wesley Banks and
    Benjamin Girgenti and
    Owen Kenny and 
    James Whinney and
    Brendan Calvert and
    Mostafa {Rahimi Azghadi} and
    Ronald D. White},
  title = {{DeepWeeds: A Multiclass Weed Species Image Dataset for Deep Learning}},
  journal = {Scientific Reports},
  year = 2019,
  number = 2058,
  month = 2,
  volume = 9,
  issue = 1,
  day = 14,
  url = "https://doi.org/10.1038/s41598-018-38343-3",
  doi = "10.1038/s41598-018-38343-3"
}

```

## 👏 Acknowledgments

> - `This work was supported by the German Federal Ministry of Education and Research (BMBF, SCADS22B) and the Saxon State Ministry for Science, Culture and Tourism (SMWK) by funding the competence center for Big Data and AI “ScaDS.AI Dresden/Leipzig”. The work was also partly funded by the Horizon European project Earth Bridge (ID: 101079310) and by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany’s Excellence Strategy – EXC 2070 – 390732324. The authors gratefully acknowledge the GWK support for funding this project by providing computing time through the Center for Information Services and HPC (ZIH) at TU Dresden. We thank the UNESCO biosphere reserve “Upper Lusatian Health and Pond Landscape” and the agricultural cooperative “Heidefarm Sdier eG” who allowed us to collect the data for this study. We further thank others who have helped in the data collection and labelling of the images, in particular Sophia Lewitz, Bela Rehnen, Stephanie Roilo, Anja Steingrobe.`

---
