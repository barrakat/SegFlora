#----------------------------------------------------------------------------#
# load required modules 
#----------------------------------------------------------------------------#

import os
import glob
import numpy as np
from PIL import Image
import re
from torchvision import transforms
from sklearn.metrics import confusion_matrix
import pandas as pd
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score

#----------------------------------------------------------------------------#
# functions
#----------------------------------------------------------------------------#

def compute_iou(y_pred, y_true):
     y_pred = y_pred.flatten()
     y_true = y_true.flatten()
     current = confusion_matrix(y_true, y_pred, labels=[0,250])
     intersection = np.diag(current)
     ground_truth_set = current.sum(axis=1)
     predicted_set = current.sum(axis=0)
     union = ground_truth_set + predicted_set - intersection
     IoU = intersection / union.astype(np.float32)
     return np.nanmean(IoU)

def compute_recall(y_pred, y_true):
     y_pred = y_pred.flatten()
     y_true = y_true.flatten()
     y_pred = (y_pred.cpu().numpy()).astype(int)
     y_true = (y_true.cpu().numpy()).astype(int)
     y_pred = (y_pred > 0).astype(int)  
     y_true = (y_true > 0).astype(int) 
     recall = recall_score(y_true, y_pred)
     return (recall)

def compute_precision(y_pred, y_true):
     y_pred = y_pred.flatten()
     y_true = y_true.flatten()
     y_pred = (y_pred.cpu().numpy()).astype(int)
     y_true = (y_true.cpu().numpy()).astype(int)
     y_pred = (y_pred > 0).astype(int)  
     y_true = (y_true > 0).astype(int) 
     precision = precision_score(y_true, y_pred)
     return (precision)

#----------------------------------------------------------------------------#
# Centaurea cyanus
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Centaurea_cyanus/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Centaurea_cyanus/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Centaurea_cyanus/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Centaurea_cyanus/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Centaurea cyanus',
          'height' : height
          }
        )

    print(file)

Centaurea = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Cirsium arvense
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Cirsium_arvense/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Cirsium_arvense/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Cirsium_arvense/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Cirsium_arvense/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Cirsium arvense',
          'height' : height
          }
        )

    print(file)

Cirsium = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Anchusa arvensis
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Anchusa_arvensis/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Anchusa_arvensis/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Anchusa_arvensis/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Anchusa_arvensis/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Anchusa arvensis',
          'height' : height
          }
        )

    print(file)

Anchusa = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Equisetum arvense
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Equisetum_arvense/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Equisetum_arvense/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Equisetum_arvense/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Equisetum_arvense/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Equisetum arvense',
          'height' : height
          }
        )

    print(file)

Equisetum = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Tripleurospermum inodorum
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Tripleurospermum_inodorum/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Tripleurospermum_inodorum/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Tripleurospermum_inodorum/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Tripleurospermum_inodorum/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Tripleurospermum inodorum',
          'height' : height
          }
        )

    print(file)

Tripleurospermum = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Papaver dubium
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Papaver_dubium/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Papaver_dubium/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Papaver_dubium/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Papaver_dubium/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Papaver dubium',
          'height' : height
          }
        )

    print(file)

Papaver = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# Vicia
#----------------------------------------------------------------------------#

os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Vicia/')
masks = glob.glob('*.png.tiff')
os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Vicia/')
ground_truth = os.listdir()

d = []
for file in (masks):
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Vicia/')
    mask_file = Image.open(file)
    number = re.search('plot_(.*)_flight', file)
    number = number.group(1)
    height = re.search('_X(.*).png', file)
    height = height.group(1)
    os.chdir('/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/masks/Vicia/')
    ground_truth_file = 'plot_'+number+"_flight_X10.tiff"
    ground_truth_file = Image.open(ground_truth_file)
    convert_tensor = transforms.ToTensor()
    ground_truth_tensor = convert_tensor(ground_truth_file)
    mask_tensor = convert_tensor(mask_file)
    iou = compute_iou(mask_tensor,ground_truth_tensor)
    recall = compute_recall(mask_tensor,ground_truth_tensor)
    precision = compute_precision(mask_tensor,ground_truth_tensor)

    d.append(
          {
          'IoU': iou,
          'precision': precision,
          'recall': recall,
          'plot': file,
          'species':  'Vicia',
          'height' : height
          }
        )

    print(file)

Vicia = pd.DataFrame(d)

#----------------------------------------------------------------------------#
# save file
#----------------------------------------------------------------------------#

frames = [Centaurea, Equisetum, Vicia, Tripleurospermum, Papaver, Cirsium, Anchusa]
result = pd.concat(frames)
result.to_csv("/zenodo/CBarrasso/UAV_SegetalFlora/data/YOLO_segmentation_accuracy.csv")


