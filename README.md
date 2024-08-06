<h1 align="center">
<br>
Report
<a href="https://www.deltager.no/event/deep_learning_for_forest_remote_sensing_applications_with_examples_in_python_22052023#init">NOVA Course</a> 
</h1>
<p align="center">
<img src="https://github.com/barrakat/NOVA/blob/main/Figures/Capture.PNG" width="300" />
</p>
</div> 

---

## 📒 Project Structure
[📍 Overview](#-overview)
[🧪 Running Tests](#-running-tests)
[💻 Results](#-results)
[🗺 Discussion](#-discussion)
[👏 Acknowledgments](#-acknowledgments)

---


## 📍 Overview

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

Code in folder [here](https://github.com/barrakat/NOVA/blob/main/Code).

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

## 👏 Acknowledgments

> - `ℹ️  I am grateful to Stefano Puliti for his invaluable teaching and expertise in the field of forestry and deep learning. Additionally, I would like to express my gratitude to Hans Ole Ørka, the instructors of the NOVA course, and all the wonderful individuals I had the pleasure of meeting during my time in Ås.`

---
