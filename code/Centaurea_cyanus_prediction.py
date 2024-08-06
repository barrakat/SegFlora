#----------------------------------------------------------------------------#
# load required modules 
#----------------------------------------------------------------------------#

import ultralytics
from ultralytics import YOLO
import os
import cv2
from ultralytics import YOLO
import numpy as np
import torch
import time

#----------------------------------------------------------------------------#
# load model
#----------------------------------------------------------------------------#

path_to_tiles="/zenodo/CBarrasso/UAV_SegetalFlora/data/test_plot/images/"
model = YOLO("/zenodo/CBarrasso/UAV_SegetalFlora/model/Centaurea_cyanus/best.pt")

#----------------------------------------------------------------------------#
# model predict
#----------------------------------------------------------------------------#

start = time.time()
results = model.predict(source=path_to_tiles, imgsz=864, conf=0.269, save=True, save_txt=False, stream=True)
end = time.time()
print("The time of execution of above program is :",(end-start) * 10**3, "ms")

#----------------------------------------------------------------------------#
# save predictions
#----------------------------------------------------------------------------#

for result in results:

  if result.masks == None:
   pass
  
  try:
    masks = result.masks.data
    boxes = result.boxes.data
    clss = boxes[:, 5]
    species_indices = torch.where(clss == 0)
    species_masks = masks[species_indices]
    species_mask = torch.any(species_masks, dim=0).int() * 255
    name = result.path
    cv2.imwrite('/zenodo/CBarrasso/UAV_SegetalFlora/data/predictions/Centaurea_cyanus/Centaurea_'+name.split('/')[7]+'.jpg', species_mask.cpu().numpy())
  except:
    pass




