#------------------------------------------------------------------------------

# Author: Caterina Barrasso
# Date: 15 August 2024 

# Code to reproduce the results of the publication: 'Remote sensing 
# of segetal flora in arable fields using off-the-shelf UAV-based imagery and 
# deep learning for result-based payments' 

#------------------------------------------------------------------------------

# directory
directory = '/zenodo/CBarrasso/UAV_SegetalFlora/data/' 

#####################################
#    Figure 1 : SPECIES COVERAGE    #
#####################################

# libraries and data
library(RColorBrewer)
library(ggplot2)
data = read.csv(paste0(directory,"field_species_abundance.csv"))

# processing
colourCount = length(unique(data$name))
getPalette = colorRampPalette(brewer.pal(11, "Spectral"))

fig = ggplot(data, aes(x = management, fill = name, y = abundance)) + 
geom_bar(stat = "identity", colour = "black") + 
scale_y_continuous(expand = c(0,0)) +  xlab("Coverage %")+
scale_fill_manual(values =getPalette(colourCount))+ 
coord_flip()+theme(axis.text.x = element_text(size = 15, face = "italic"),
axis.text.y = element_text(size = 15),
axis.title.x = element_blank(),
axis.title.y =element_blank(),legend.position = "bottom",legend.text = element_text(size=15),
plot.margin = unit(c(0.1, 1.5, 0.2, 0.2), "inches"),
legend.title = element_blank()) 

ggsave("Figure1b.png", fig, dpi = 900, width = 15, height = 3)

#####################################
#   Figure 3 : DETECTION ANALYSIS   #
#####################################

# libraries and data
library(MuMIn)
library(rrtable)
library(sjPlot)
library(ggplot2)
library(DHARMa)
library(car)
library(reshape2)
library(data.table)

library(flextable)
library(jtools) 

data = read.csv(paste0(directory,"field_plot_average_trait_data.csv"))
height = read.csv(paste0(directory,'field_plant_height.csv'))
key_indicator_literature = read.csv(paste0(directory,'field_species_literature_height.csv'))

# modeling
data$detection[data$detection=='yes'] = 1
data$detection[data$detection=='no'] = 0
data$detection = as.numeric(data$detection)
model = glm(detection~coverage+height+flower,data=data,family=binomial)

# dredge analysis
oop = options(na.action = "na.fail")
dd = dredge(model)
table = df2flextable(as.data.frame(dd))
dredge_result = theme_booktabs(table)
dredge_result = width(dredge_result, width = 1)
selected_model = glm(detection~height+flower,data=data,family=binomial)

# effect size
p1 = plot_model(selected_model,type = "pred",terms = "height [all]") + labs(y = "")
p2 = plot_model(selected_model,type = "pred",terms = "flower [all]", cex=1.5) + labs(y = "")
p1 + theme(text = element_text(size = 50),axis.text = element_text(colour = "black"),legend.position = "top")
p2 + theme(text = element_text(size = 50),axis.text = element_text(colour = "black"),legend.position = "top")

# checking assumptions 
vif(selected_model)
residuals =  simulateResiduals(fittedModel = selected_model)
plot = plot(residuals)

# model output
summary(selected_model)
tab_model(selected_model,transform = NULL)

set_theme(base = theme_classic(), 
          theme.font = 'arial',  
          axis.title.size = 2.0, 
          axis.textsize.x = 1.5, 
          axis.textsize.y = 1.5) 

# plant height figure
colnames(height) <- as.character(unlist(height[1,]))
height = height[2:23,]
colnames(height)[2:61] <- 2:61
long = melt(setDT(height), id.vars = 'scientific name', variable.name = "height")
names(long)[3]='plant height'
long = long[!is.na(long$`plant height`),]

# format data
long$detection[long$`scientific name`=='Anchusa arvensis']='yes'
long$detection[long$`scientific name`=='Centaurea cyanus']='yes'
long$detection[long$`scientific name`=='Myosotis arvensis']='no'
long$detection[long$`scientific name`=='Veronica arvensis']='no'
long$detection[long$`scientific name`=='Veronica persica']='no'
long$detection[long$`scientific name`=='Hordeum vulgare']='yes'
long$detection[long$`scientific name`=='Aphanes arvensis']='no'
long$detection[long$`scientific name`=='Equisetum arvense']='yes'
long$detection[long$`scientific name`=='Cirsium arvense']='yes'
long$detection[long$`scientific name`=='Erodium cicutarium']='no'
long$detection[long$`scientific name`=='Geranium pusillum']='no'
long$detection[long$`scientific name`=='Vicia sativa']='yes'
long$detection[long$`scientific name`=='Papaver dubium']='yes'
long$detection[long$`scientific name`=='Arenaria serpyllifolia']='no'
long$detection[long$`scientific name`=='Capsella bursa-pastoris']='yes'
long$detection[long$`scientific name`=='Silene latifolia']='no'
long$detection[long$`scientific name`=='Thlaspi arvense']='no'
long$detection[long$`scientific name`=='Trifolium arvense']='no'
long$detection[long$`scientific name`=='Tripleurospermum inodorum']='yes'
long$detection[long$`scientific name`=='Valerianella locusta']='no'
long$detection[long$`scientific name`=='Vicia hirsuta']='yes'
long$detection[long$`scientific name`=='Viola arvensis']='no'
long = long[,c(1,3:4)]
names(long)[1]='name'
names(long)[2]='height'
long$height= as.numeric(long$height)

# plot
mean = aggregate(long$height, list(long$name), FUN=mean)
mean$diff = 71.98-mean$x
cutoff <- data.frame(yintercept=71.98, Lines='winter barley mean height')
long$name<- as.factor(long$name)

legend = ggplot(long) +aes(x = factor(name,levels = rev(levels(factor(name)))), y = height, alpha = detection)  + 
geom_point(position = position_jitter(w = .15), size = 2,alpha = 0.2,show.legend = F) +
geom_boxplot(width = .5, lwd=1, fill ='pink1') +coord_flip()+
scale_alpha_manual(values = c(0.2,0.8),name="") +labs(x = "",y = "") +
geom_hline(aes(yintercept=yintercept, linetype=Lines), cutoff, 
color = "purple", size = 1.5)+
guides()+theme_bw()+
theme(axis.text.y = element_text(face = "italic",size = 15),axis.text.x = element_text(size = 15),
legend.position = "bottom",legend.margin = margin(0, 0, 0, 0),  legend.text = element_text(size=15))

fig = ggplot(long, aes(x = factor(name,levels = rev(levels(factor(name)))), y = height, alpha = detection)) +
geom_point(position = position_jitter(w = .15), size = 2,alpha = 0.2,show.legend = F) +
geom_boxplot(width = .5, lwd=1, fill ='pink1') +scale_alpha_manual(values = c(0.2,0.8),name="")+
geom_hline(aes(yintercept=yintercept, linetype=Lines), cutoff, linetype="dashed",color = "purple", size = 1.5)+
stat_summary(fun.x=mean,geom = "point", color = "purple", size =7,shape=20, alpha=1)+
geom_point(data = key_indicator_literature,
aes(x = species, y = mean), color = "blue", size = 7,shape=20, alpha=1) +
labs(title = "",x = "",y = "plant height (cm)") +coord_flip()+
guides(alpha = guide_legend(nrow=1,byrow=TRUE))+theme_bw()+
theme(axis.text.y = element_text(face = "italic",size = 20),axis.text.x = element_text(size = 20),
legend.position = "bottom",legend.margin = margin(0, 0, 0, 0),  legend.text = element_text(size=20))

ggsave("Figure3b.png", fig, dpi = 900, width = 15, height = 12)
ggsave("Figure3b_legend.png", legend, dpi = 900)

#####################################
#   Figure 4 : YOLO SEGMENTATION    #
#####################################

# libraries and data
library(ggpubr)

library(rstatix)
library(dplyr)
library(ggplot2)
library(stringr)
library(raster)

accuracy = read.csv(paste0(directory,'YOLO_segmentation_accuracy.csv'))
  
# Figure 4A:

# Centaurea cyanus:
centaurea_annot = raster(paste0(directory,'test_plots/masks/Centaurea/plot_26_flight_X10.tiff'))
centaurea_pred_10 = raster(paste0(directory,'predictions/Centaurea/Centaurea_plot_26_flight_X10.png.tiff'))
centaurea_pred_20 = raster(paste0(directory,'predictions/Centaurea/Centaurea_plot_26_flight_X20.png.tiff'))
centaurea_pred_40 = raster(paste0(directory,'predictions/Centaurea/Centaurea_plot_26_flight_X40.png.tiff'))

r3 <- raster(centaurea_annot)
r3[centaurea_annot == 250 & centaurea_pred_10 == 250] <- 1
r3[centaurea_annot == 250 & centaurea_pred_10 == 0] <- 2
r3[centaurea_annot == 0 & centaurea_pred_10 == 250] <- 3
r3[centaurea_annot == 0 & centaurea_pred_10 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(centaurea_annot)
r3[centaurea_annot == 250 & centaurea_pred_20 == 250] <- 1
r3[centaurea_annot == 250 & centaurea_pred_20 == 0] <- 2
r3[centaurea_annot == 0 & centaurea_pred_20 == 250] <- 3
r3[centaurea_annot == 0 & centaurea_pred_20 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(centaurea_annot)
r3[centaurea_annot == 250 & centaurea_pred_40 == 250] <- 1
r3[centaurea_annot == 250 & centaurea_pred_40 == 0] <- 2
r3[centaurea_annot == 0 & centaurea_pred_40 == 250] <- 3
r3[centaurea_annot == 0 & centaurea_pred_40 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

# Cirsium arvense:
Cirsium_annot = raster(paste0(directory,'test_plots/masks/Cirsium/plot_32_flight_X10.tiff'))
Cirsium_pred_10 = raster(paste0(directory,'predictions/Cirsium/Cirsium_plot_32_flight_X10.png.tiff'))
Cirsium_pred_20 = raster(paste0(directory,'predictions/Cirsium/Cirsium_plot_32_flight_X20.png.tiff'))
Cirsium_pred_40 = raster(paste0(directory,'predictions/Cirsium/Cirsium_plot_32_flight_X40.png.tiff'))

r3 <- raster(Cirsium_annot)
r3[Cirsium_annot == 250 & Cirsium_pred_10 == 250] <- 1
r3[Cirsium_annot == 250 & Cirsium_pred_10 == 0] <- 2
r3[Cirsium_annot == 0 & Cirsium_pred_10 == 250] <- 3
r3[Cirsium_annot == 0 & Cirsium_pred_10 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Cirsium_annot)
r3[Cirsium_annot == 250 & Cirsium_pred_20 == 250] <- 1
r3[Cirsium_annot == 250 & Cirsium_pred_20 == 0] <- 2
r3[Cirsium_annot == 0 & Cirsium_pred_20 == 250] <- 3
r3[Cirsium_annot == 0 & Cirsium_pred_20 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Cirsium_annot)
r3[Cirsium_annot == 250 & Cirsium_pred_40 == 250] <- 1
r3[Cirsium_annot == 250 & Cirsium_pred_40 == 0] <- 2
r3[Cirsium_annot == 0 & Cirsium_pred_40 == 250] <- 3
r3[Cirsium_annot == 0 & Cirsium_pred_40 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

# Equisetum arvense:
Equisetum_annot = raster(paste0(directory,'test_plots/masks/Equisetum/plot_26_flight_X10.tiff'))
Equisetum_pred_10 = raster(paste0(directory,'predictions/Equisetum/Equisetum_plot_26_flight_X10.png.tiff'))
Equisetum_pred_20 = raster(paste0(directory,'predictions/Equisetum/Equisetum_plot_26_flight_X20.png.tiff'))
Equisetum_pred_40 = raster(paste0(directory,'predictions/Equisetum/Equisetum_plot_26_flight_X40.png.tiff'))

r3 <- raster(Equisetum_annot)
r3[Equisetum_annot == 250 & Equisetum_pred_10 == 250] <- 1
r3[Equisetum_annot == 250 & Equisetum_pred_10 == 0] <- 2
r3[Equisetum_annot == 0 & Equisetum_pred_10 == 250] <- 3
r3[Equisetum_annot == 0 & Equisetum_pred_10 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Equisetum_annot)
r3[Equisetum_annot == 250 & Equisetum_pred_20 == 250] <- 1
r3[Equisetum_annot == 250 & Equisetum_pred_20 == 0] <- 2
r3[Equisetum_annot == 0 & Equisetum_pred_20 == 250] <- 3
r3[Equisetum_annot == 0 & Equisetum_pred_20 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Equisetum_annot)
r3[Equisetum_annot == 250 & Equisetum_pred_40 == 250] <- 1
r3[Equisetum_annot == 250 & Equisetum_pred_40 == 0] <- 2
r3[Equisetum_annot == 0 & Equisetum_pred_40 == 250] <- 3
r3[Equisetum_annot == 0 & Equisetum_pred_40 == 0] <- 4
colors <- c('darkorange','red','honeydew4') # remove blue color since there aren't TP
plot(r3,col=colors)

# Tripleurospermum inodorum:
Tripleurospermum_annot = raster(paste0(directory,'test_plots/masks/Tripleurospermum/plot_33_flight_X10.tiff'))
Tripleurospermum_pred_10 = raster(paste0(directory,'predictions/Tripleurospermum/Tripleurospermum_plot_33_flight_X10.png.tiff'))
Tripleurospermum_pred_20 = raster(paste0(directory,'predictions/Tripleurospermum/Tripleurospermum_plot_33_flight_X20.png.tiff'))
Tripleurospermum_pred_40 = raster(paste0(directory,'predictions/Tripleurospermum/Tripleurospermum_plot_33_flight_X40.png.tiff'))

r3 <- raster(Tripleurospermum_annot)
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_10 == 250] <- 1
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_10 == 0] <- 2
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_10 == 250] <- 3
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_10 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Tripleurospermum_annot)
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_20 == 250] <- 1
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_20 == 0] <- 2
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_20 == 250] <- 3
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_20 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

r3 <- raster(Tripleurospermum_annot)
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_40 == 250] <- 1
r3[Tripleurospermum_annot == 250 & Tripleurospermum_pred_40 == 0] <- 2
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_40 == 250] <- 3
r3[Tripleurospermum_annot == 0 & Tripleurospermum_pred_40 == 0] <- 4
colors <- c('blue','darkorange','red','honeydew4')
plot(r3,col=colors)

# Figure 4B:
accuracy$resolution[accuracy$height==10] = '1.22 mm'
accuracy$resolution[accuracy$height==20] = '2.44 mm'
accuracy$resolution[accuracy$height==40] = '4.88 mm'

management = str_match(accuracy$plot, "plot_\\s*(.*?)\\s*_flight")[,2]
accuracy$management = as.numeric(management)
accuracy = accuracy %>% mutate(management = ifelse(management>25 & management <36, "extensive","intensive"))

legend_title <- "management"

plot = ggplot(accuracy, aes(x = species, y = mIoU, fill=management))+
geom_boxplot()+
theme_bw()+scale_fill_grey(legend_title)+
theme(axis.text.x = element_text(size = 15,face = "italic",angle = 45,hjust=1),
axis.text.y = element_text(size = 15),
axis.title.x = element_blank(),
axis.title.y = element_text(size = 15),
plot.margin = unit(c(0, 0.5, 0, 0.5), 
"inches"))+coord_cartesian(ylim = c(0.2, 1))+
ylab('mIoU')+ facet_grid(cols = vars(resolution))+
scale_fill_manual(legend_title, values = c("dimgrey", "grey"))

# analysis:
accuracy$comb = paste0(accuracy$species,'_',accuracy$management)
m_10 = accuracy[accuracy$height==10,]
m_20 = accuracy[accuracy$height==20,]
m_40 = accuracy[accuracy$height==40,]

shapiro.test(m_10$mIoU)
shapiro.test(m_20$mIoU)
shapiro.test(m_40$mIoU)

res.kruskal.10_m = m_10 %>% kruskal_test(mIoU ~ comb)
pwc <- m_10 %>% dunn_test(mIoU ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.20_m = m_20 %>% kruskal_test(mIoU ~ comb)
pwc <- m_20 %>% dunn_test(mIoU ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.40_m = m_40 %>% kruskal_test(mIoU ~ comb)
pwc <- m_40 %>% dunn_test(mIoU ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

ggsave("Figure4b.png", plot, dpi = 900, width = 13, height = 8)

#####################################
#   Figure 5 : YOLO COVERAGE/PRES.  #
#####################################

# libraries and data
library(dplyr)
library(raster)
library(Metrics)
library(MLmetrics)
library(lsa)
library(data.table)
library(raster)
library(ggplot2)
library(rstatix)
library(stringr)
library(ggpubr)

# format ground-truth coverage:
ground_truth = read.csv(paste0(directory,'field_plot_average_trait_data.csv'))
ground_truth$scientific.name[ground_truth$scientific.name=='Vicia sativa'] = 'Vicia'
ground_truth$scientific.name[ground_truth$scientific.name=='Vicia hirsuta'] = 'Vicia'
species = c('Centaurea cyanus','Anchusa arvensis','Equisetum arvense','Vicia','Cirsium arvense',
            'Tripleurospermum inodorum','Papaver dubium')
ground_truth = ground_truth[ground_truth$scientific.name %in% species,]
ground_truth= ground_truth[,1:3]

plot_ID = c(paste0('plot_ID_',26:45))
plot_ID = as.data.frame(plot_ID[!plot_ID=='plot_ID_42'])
names(plot_ID)[1]='plot_ID'
plot_ID = cbind(plot_ID, rep(species, each = 19))
names(plot_ID)[2]='scientific.name'
gt_coverage = full_join(ground_truth, plot_ID, by= c('plot_ID','scientific.name'))
gt_coverage$coverage[is.na(gt_coverage$coverage)] <- 0
gt_coverage = gt_coverage %>% 
group_by(plot_ID,scientific.name) %>% 
summarise(Frequency = sum(coverage))
names(gt_coverage)[3]='ground_truth_coverage' 

# format RGB-based manual annotation coverage:

RGB_coverage = list()

for (i in species){
  
  # RGB manual mask
  truncated = stringr::str_extract(i, '\\w*')
  setwd(paste0(directory,'test_plots/masks/',truncated,'/'))
  masks = list.files(pattern = ".tiff")
  
  # extract coverage per species and plot ID
  spec_species = list()
  for (j in masks){
  raster = raster(j) 
  plot_ID = as.numeric(str_match(j, "plot_\\s*(.*?)\\s*_flight_"))[[2]]  
  plot_ID_full = paste0('plot_ID_',plot_ID)
  pixels = ncell(raster)
  class = as.data.frame(freq(raster))
  prop = (class$count/pixels*100)
  bind_true = cbind(class,prop)
  bind_true = bind_true[,c(1,3)]
  names(bind_true)[1]='class_true'
  names(bind_true)[2]='prop_true'
  bind_true = bind_true[bind_true$class_true==250,]
  names(bind_true)[1]='class_true'
  names(bind_true)[2]='prop_true'
  bind_true = bind_true[bind_true$class_true==250,]
  if (nrow(bind_true)==0){class_true =250
  prop_true =0
  bind_true=as.data.frame(cbind(class_true,prop_true))} else {bind_true=as.data.frame(bind_true)}
  db = as.data.frame(cbind(i,bind_true$prop_true, plot_ID_full))
  names(db)[1] = 'scientific.name'
  names(db)[2] = 'annotation_coverage'
  names(db)[3] = 'plot_ID'
  spec_species[[j]] <- db
  }

  bind = rbindlist(spec_species, use.names=TRUE,fill=TRUE)
  RGB_coverage[[i]] <- bind
  print(i)
} 

annot_coverage = rbindlist(RGB_coverage, use.names=TRUE,fill=TRUE)

# format predicted coverage:

predicted_coverage = list()

for (i in species){
  
  # predicted mask
  truncated = stringr::str_extract(i, '\\w*')
  setwd(paste0(directory,'predictions/',truncated,'/'))
  masks = list.files(pattern = ".tiff")
  
  # extract coverage per species and plot ID
  spec_species = list()
  for (j in masks){
    raster = raster(j) 
    plot_ID = as.numeric(str_match(j, "plot_\\s*(.*?)\\s*_flight_"))[[2]]  
    plot_ID_full = paste0('plot_ID_',plot_ID)
    height = as.numeric(str_match(j, "flight_X\\s*(.*?)\\s*.png.tiff"))[[2]]
    pixels = ncell(raster)
    class = as.data.frame(freq(raster))
    prop = (class$count/pixels*100)
    bind_true = cbind(class,prop)
    bind_true = bind_true[,c(1,3)]
    names(bind_true)[1]='class_true'
    names(bind_true)[2]='prop_true'
    bind_true = bind_true[bind_true$class_true==250,]
    names(bind_true)[1]='class_true'
    names(bind_true)[2]='prop_true'
    bind_true = bind_true[bind_true$class_true==250,]
    if (nrow(bind_true)==0){class_true =250
    prop_true =0
    bind_true=as.data.frame(cbind(class_true,prop_true))} else {bind_true=as.data.frame(bind_true)}
    db = as.data.frame(cbind(i,bind_true$prop_true, plot_ID_full, height))
    names(db)[1] = 'scientific.name'
    names(db)[2] = 'pred_coverage'
    names(db)[3] = 'plot_ID'
    spec_species[[j]] <- db
    print(j)
  }
  
  bind = rbindlist(spec_species, use.names=TRUE,fill=TRUE)
  predicted_coverage[[i]] <- bind
  print(i)
} 

pred_coverage = rbindlist(predicted_coverage, use.names=TRUE,fill=TRUE)

# combine data and generate presence/absence information per plot:
db_combine = full_join(pred_coverage, gt_coverage, by= c('plot_ID','scientific.name'))
db_combine = full_join(db_combine, annot_coverage, by= c('plot_ID','scientific.name'))
rm(list=setdiff(ls(), "db_combine"))

db_combine$management[db_combine$plot_ID=='plot_ID_26']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_27']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_28']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_29']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_30']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_31']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_32']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_33']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_34']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_35']='extensive'
db_combine$management[db_combine$plot_ID=='plot_ID_36']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_37']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_38']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_39']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_40']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_41']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_42']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_43']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_44']='intensive'
db_combine$management[db_combine$plot_ID=='plot_ID_45']='intensive'

db_combine$resolution[db_combine$height==10] = '1.22 mm'
db_combine$resolution[db_combine$height==20] = '2.44 mm'
db_combine$resolution[db_combine$height==40] = '4.88 mm'

db_combine$presence_pred[db_combine$pred_coverage>0] <- 1 
db_combine$presence_pred[db_combine$pred_coverage==0] <- 0 
db_combine$presence_ground[db_combine$annotation_coverage>0] <- 1 
db_combine$presence_ground[db_combine$annotation_coverage==0] <- 0

# calculate accuracy + make plot and analysis: 
db_combine$pred_coverage = as.numeric(db_combine$pred_coverage)
db_combine$ground_truth_coverage = as.numeric(db_combine$ground_truth_coverage)
db_combine$annotation_coverage = as.numeric(db_combine$annotation_coverage)
db_combine[,c(3,6:7)][db_combine[,c(3,6:7)]==0] <- 0.000001

accuracy = list()
for (i in unique(db_combine$management)){
  save_1 = list()
  for (j in unique(db_combine$scientific.name)){
    save = list()
    for (z in unique(db_combine$height)){
     subset = db_combine[(db_combine$management==i & db_combine$scientific.name==j & db_combine$height==z),]
     RMSE_ground = rmse(subset$ground_truth_coverage, subset$pred_coverage)
     if (is.na(RMSE_ground)==TRUE){RMSE_ground=0}
     RMSE_annotations = rmse(subset$annotation_coverage, subset$pred_coverage)
     if (is.na(RMSE_annotations)==TRUE){RMSE_annotations=0}
     F1 = F1_Score(subset$presence_ground,subset$presence_pred)
     if (is.na(F1)==TRUE){F1=0}
     cos_similarity_ground = cosine(subset$ground_truth_coverage,subset$pred_coverage) 
     cos_similarity_annotations = cosine(subset$annotation_coverage,subset$pred_coverage) 
     db = as.data.frame(cbind(j,z,i,RMSE_ground,RMSE_annotations,F1, cos_similarity_ground, cos_similarity_annotations))
     save[[z]] <- db  
    }
    bind = rbindlist(save, use.names=TRUE,fill=TRUE)
    save_1[[j]] <- bind
    print(j)
  }
  bind_2 = rbindlist(save_1, use.names=TRUE,fill=TRUE)
  accuracy[[i]] <- bind_2
}

accuracy_comb = rbindlist(accuracy, use.names=TRUE,fill=TRUE)
names(accuracy_comb)[1]='species'
names(accuracy_comb)[2]='height'
names(accuracy_comb)[3]='management'
names(accuracy_comb)[7]='cos_sim_ground'
names(accuracy_comb)[8]='cos_sim_annotations'

accuracy_comb$resolution[accuracy_comb$height==10] = '1.22 mm'
accuracy_comb$resolution[accuracy_comb$height==20] = '2.44 mm'
accuracy_comb$resolution[accuracy_comb$height==40] = '4.88 mm'

long = melt(setDT(accuracy_comb), id.vars = c("species","height",'management','resolution'), variable.name = "metric")
long$metric = as.character(long$metric)
long$metric[long$metric=='RMSE_ground']='RMSE plant survey'
long$metric[long$metric=='RMSE_annotations']='RMSE annotations'
long$metric[long$metric=='cos_sim_ground']='cosine similarity plant survey'
long$metric[long$metric=='cos_sim_annotations']='cosine similarity annotations'

# plot:
long$value = as.numeric(long$value)

plot = long %>% ggplot(aes(x=resolution, y=value,fill=as.factor(management)))+  
geom_boxplot(lwd=1)+
geom_point(position = position_dodge(width = .75), 
pch=23, aes(fill=as.factor(species),group = management), alpha= 0.8, size = 4) + 
facet_wrap(~metric,  scales = "free_y", nrow=2)+ theme_bw()+scale_fill_manual(values=c('#BE7ACF','#FDBF6F',
'#5b1847','#7f37d9','#0dc3f1','#134b57','#54a600','#4c6b00','#c87544'))+
theme(panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
axis.text.y = element_text(size = 15),
axis.title.y = element_text(size = 15),
axis.text.x = element_text(size = 15),
axis.title.x=element_blank(),
legend.title=element_text(size=15),
legend.text=element_text(size=12),
strip.text = element_text(size = 15))+
labs(fill="legend")

ggsave("Figure5", plot, dpi = 900, width = 17, height = 10)

# stat: 
long$comb = paste0(long$height,'_',long$management)
m_cos_annot = long[long$metric=='cosine similarity annotations',]
m_cos_survey = long[long$metric=='cosine similarity plant survey',]
m_rmse_annot = long[long$metric=='RMSE annotations',]
m_rmse_survey = long[long$metric=='RMSE plant survey',]
m_f1 = long[long$metric=='F1',]

shapiro.test(m_cos_annot$value)
shapiro.test(m_cos_survey$value)
shapiro.test(m_rmse_annot$value)
shapiro.test(m_rmse_survey$value)
shapiro.test(m_f1$value)

res.kruskal.m_cos_annot = m_cos_annot %>% kruskal_test(value ~ comb)
pwc <- m_cos_annot %>% dunn_test(value ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.m_cos_survey = m_cos_survey %>% kruskal_test(value ~ comb)
pwc <- m_cos_survey %>% dunn_test(value ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.m_rmse_annot = m_rmse_annot %>% kruskal_test(value ~ comb)
pwc <- m_rmse_annot %>% dunn_test(value ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.m_rmse_survey = m_rmse_survey %>% kruskal_test(value ~ comb)
pwc <- m_rmse_survey %>% dunn_test(value ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

res.kruskal.m_f1 = m_f1 %>% kruskal_test(value ~ comb)
pwc <- m_f1 %>% dunn_test(value ~ comb, p.adjust.method = "bonferroni") 
pwc <- pwc %>% add_xy_position(x = "comb")

#####################################
# Figure 6 : UNDETECTABLE SPECIES   #
#####################################

# libraries and data
library(ggpubr)
library(pwr)
library(tidyr)
library(cooccur)
library(tibble)

data = read.csv(paste0(directory,"HH_point_cloud.csv"))
coverage = read.csv(paste0(directory,'field_plot_average_trait_data.csv'))
  
# HH analysis
plot = data[data$HH.derivation=='point cloud plot',]
field = data[data$HH.derivation=='field survey',]
m_40 = data[data$HH.derivation=='point cloud RGB 40m',]
extensive = data[data$HH.derivation=='field survey',]
extensive = extensive[extensive$plot_ID<36,]

shapiro.test(plot$std)
shapiro.test(field$std)
shapiro.test(m_40$std)
shapiro.test(extensive$std)

fig_6_1 = ggscatter(plot, x = "std", y = "non.detectable.species..", 
add = "reg.line",conf.int = TRUE, 
cor.method = "pearson", xlab = "std", ylab = "non-detectable species %",palette = c("#C27CD3", "#FDBF6F"))+
geom_point(aes(size = 7,alpha = 0.2,color = management))+theme(axis.text.y = element_text(size = 20),axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 20),axis.title.x = element_text(size = 20))+theme_bw() +
theme(axis.text.y = element_text(size = 20),legend.position="none",axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 30),axis.title.x = element_text(size = 30))+ stat_cor(label.x.npc="right", 
label.y.npc="top", hjust=1, size = 10,show.legend = FALSE)+ guides(color = FALSE, size = FALSE)

fig_6_2 = ggscatter(field, x = "std", y = "non.detectable.species..", 
add = "reg.line",conf.int = TRUE, 
cor.method = "pearson", xlab = "std", ylab = "non-detectable species %",palette = c("#C27CD3", "#FDBF6F"))+
geom_point(aes(size = 7,alpha = 0.2,color = management))+theme(axis.text.y = element_text(size = 20),axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 20),axis.title.x = element_text(size = 20))+theme_bw() +
theme(axis.text.y = element_text(size = 20),legend.position="none",axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 30),axis.title.x = element_text(size = 30))+ stat_cor(label.x.npc="right", 
label.y.npc="top", hjust=1, size = 10,show.legend = FALSE)+ guides(color = FALSE, size = FALSE)

fig_6_3 = ggscatter(m_40, x = "std", y = "non.detectable.species..", 
add = "reg.line",conf.int = TRUE, 
cor.method = "pearson", xlab = "std", ylab = "non-detectable species %",palette = c("#C27CD3", "#FDBF6F"))+
geom_point(aes(size = 7,alpha = 0.2,color = management))+theme(axis.text.y = element_text(size = 20),axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 20),axis.title.x = element_text(size = 20))+theme_bw() +
theme(axis.text.y = element_text(size = 20),legend.position="none",axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 30),axis.title.x = element_text(size = 30))+ stat_cor(label.x.npc="right", 
label.y.npc="top", hjust=1, size = 10,show.legend = FALSE)+ guides(color = FALSE, size = FALSE)

fig_6_4 = ggscatter(extensive, x = "std", y = "non.detectable.species..", 
add = "reg.line",conf.int = TRUE, 
cor.method = "spearman", xlab = "std", ylab = "non-detectable species %",palette = c("#C27CD3", "#FDBF6F"))+
geom_point(aes(size = 7,alpha = 0.2,color = management))+theme(axis.text.y = element_text(size = 20),axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 20),axis.title.x = element_text(size = 20))+theme_bw() +
theme(axis.text.y = element_text(size = 20),legend.position="none",axis.text.x = element_text(size = 20),
axis.title.y = element_text(size = 30),axis.title.x = element_text(size = 30))+ stat_cor(label.x.npc="right", 
label.y.npc="top", hjust=1, size = 10,show.legend = FALSE)+ guides(color = FALSE, size = FALSE)

ggsave("Figure6b_1.png", fig_6_1, dpi = 900, width = 9, height = 6)
ggsave("Figure6b_2.png", fig_6_2, dpi = 900, width = 9, height = 6)
ggsave("Figure6b_3.png", fig_6_3, dpi = 900, width = 9, height = 6)
ggsave("Figure6b_4.png", fig_6_4, dpi = 900, width = 9, height = 6)

# power analysis:
r <- 0.6
sig <-0.05
power <- 0.8
p.out <- pwr.r.test(
n = NULL,
r = r,
sig.level = sig,
power = power,
alternative = 'two.sided'
)
p.out

plot= plot(p.out)
ggsave("power_analysis.png", plot, dpi = 900, width=18, height=11)

# co-occurrence analysis
coverage = coverage[,1:3]
coverage = spread(coverage, key = plot_ID, value = coverage)
coverage = replace(coverage, is.na(coverage), 0)
formatting <- coverage %>% remove_rownames %>% column_to_rownames(var="scientific.name")
formatting[formatting > 0] <- 1 

cooccur <- cooccur(mat=formatting,
                   type="spp_site",
                   thresh=TRUE,
                   spp_names=TRUE)

summary(cooccur)
plot(cooccur)

#####################################
# Figure 7 : WORKFLOW POTENTIAL     #
#####################################

# libraries and data
library(data.table)
library(ggplot2)
library(DHARMa)
library(sjPlot)
library(vctrs)
library(ggpie)

height = read.csv(paste0(directory,'field_plant_height.csv'))
literature_height = read.csv(paste0(directory,'key_indicators.csv'))
key_indicator_literature = read.csv(paste0(directory,'field_species_literature_height.csv'))
  
# format data
colnames(height) <- as.character(unlist(height[1,]))
height = height[2:23,]
long = melt(setDT(height), id.vars = 1, variable.name = "height")
names(long)[3]='plant height'
long = long[!is.na(long$`plant height`),]
long$`plant height` = as.numeric(long$`plant height`)

# fit model on empirical data
long$detection[long$`scientific name`=='Anchusa arvensis']='yes'
long$detection[long$`scientific name`=='Centaurea cyanus']='yes'
long$detection[long$`scientific name`=='Myosotis arvensis']='no'
long$detection[long$`scientific name`=='Veronica arvensis']='no'
long$detection[long$`scientific name`=='Veronica persica']='no'
long$detection[long$`scientific name`=='Hordeum vulgare']='yes'
long$detection[long$`scientific name`=='Aphanes arvensis']='no'
long$detection[long$`scientific name`=='Equisetum arvense']='yes'
long$detection[long$`scientific name`=='Cirsium arvense']='yes'
long$detection[long$`scientific name`=='Erodium cicutarium']='no'
long$detection[long$`scientific name`=='Geranium pusillum']='no'
long$detection[long$`scientific name`=='Vicia sativa']='yes'
long$detection[long$`scientific name`=='Papaver dubium']='yes'
long$detection[long$`scientific name`=='Arenaria serpyllifolia']='no'
long$detection[long$`scientific name`=='Capsella bursa-pastoris']='yes'
long$detection[long$`scientific name`=='Silene latifolia']='no'
long$detection[long$`scientific name`=='Thlaspi arvense']='no'
long$detection[long$`scientific name`=='Trifolium arvense']='no'
long$detection[long$`scientific name`=='Tripleurospermum inodorum']='yes'
long$detection[long$`scientific name`=='Valerianella locusta']='no'
long$detection[long$`scientific name`=='Vicia hirsuta']='yes'
long$detection[long$`scientific name`=='Viola arvensis']='no'
long = long[,c(1,3:4)]
names(long)[1]='name'
names(long)[2]='height'
long$height= as.numeric(long$height)
long$binary[long$detection=='yes'] = 1
long$binary[long$detection=='no'] = 0
long$binary = as.numeric(long$binary)

model = glm(binary~height,data=long,family=binomial)
residuals =  simulateResiduals(fittedModel = model)
plot = plot(residuals)
tab_model(model,transform = NULL, show.se = TRUE, bootstrap = TRUE)

# prediction on mean plant height per species to find cut-off value:
mean = long[ ,list(mean=mean(height)), by=name]
mean$detection[mean$name=='Anchusa arvensis']='yes'
mean$detection[mean$name=='Centaurea cyanus']='yes'
mean$detection[mean$name=='Myosotis arvensis']='no'
mean$detection[mean$name=='Veronica arvensis']='no'
mean$detection[mean$name=='Veronica persica']='no'
mean$detection[mean$name=='Hordeum vulgare']='yes'
mean$detection[mean$name=='Aphanes arvensis']='no'
mean$detection[mean$name=='Equisetum arvense']='yes'
mean$detection[mean$name=='Cirsium arvense']='yes'
mean$detection[mean$name=='Erodium cicutarium']='no'
mean$detection[mean$name=='Geranium pusillum']='no'
mean$detection[mean$name=='Vicia sativa']='yes'
mean$detection[mean$name=='Papaver dubium']='yes'
mean$detection[mean$name=='Arenaria serpyllifolia']='no'
mean$detection[mean$name=='Capsella bursa-pastoris']='yes'
mean$detection[mean$name=='Silene latifolia']='no'
mean$detection[mean$name=='Thlaspi arvense']='no'
mean$detection[mean$name=='Trifolium arvense']='no'
mean$detection[mean$name=='Tripleurospermum inodorum']='yes'
mean$detection[mean$name=='Valerianella locusta']='no'
mean$detection[mean$name=='Vicia hirsuta']='yes'
mean$detection[mean$name=='Viola arvensis']='no'

pred = data.frame(height=mean$mean)
prediction = predict(model, pred, type="response")
db= as.data.frame(cbind(prediction,mean))
db$prediction= as.numeric(db$prediction)
# --> cut-off: 0.21

# transfer model on other species:
pred = data.frame(height=literature_height$mean)
prediction = predict(model, pred, type="response")
db= as.data.frame(cbind(prediction,literature_height))
db$prediction= as.numeric(db$prediction)
db$class[db$prediction < 0.21] <- 'no' 
db$class[db$prediction > 0.21] <- 'yes' 
db$formula ='mean'
db = db[,c(2,8:9)]

# plot
cols <- c("no" = "gray89", "yes" = "pink1")
db$group = vec_rep_each(1:3, c(45, 45, 47))

heat_map = ggplot(data =  db, aes(x = key.indicator,
y=formula, fill = as.factor(class))) + geom_tile(color='black') +
scale_fill_manual(values = cols,name = "expected detection")+ylab("")+xlab("")+
facet_wrap(~group, nrow=3,scales="free")+
theme_bw() + theme(plot.margin = unit(c(1,1,1,1.5), "cm"),axis.text.y = element_text(size = 15),axis.text.x = element_text(face = "italic",angle = 45,size = 15, hjust = 1),
axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15,face='italic'),legend.position = 'top')

ggsave("figure7_1.png", heat_map, dpi = 900, width=17, height=11)

# pie graph
A = ggdonut(data = db, group_key = "class", count_type = "full",
            label_info = "all", label_type = "horizon", label_split = NULL,
            label_size = 7, label_pos = "out",fill_color=c('pink1','gray89','dimgrey'))

ggsave("figure7_2.png", A, dpi = 900, width=17, height=8)

#####################################
# Figure S9 : LOSS                  #
#####################################

# libraries and data
library(ggplot2)
library(data.table)
library(tidyr)

library(cowplot)

data = read.csv(paste0(directory,"training_validation_loss_mAP.csv"))

# format data and plot
loss_long = gather(data, data_type, value, 'train.seg_loss':'val.seg_loss', factor_key=TRUE)
loss_subset = loss_long[loss_long$data_type=='train.seg_loss' | loss_long$data_type=='val.seg_loss',]

plot = ggplot(loss_subset, aes(epoch,value,colour = data_type)) + geom_point(size=2,alpha = 0.4)

p1 = plot + theme_minimal()+
  theme(legend.title = element_blank(),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        legend.text = element_text(size=15),
        strip.text = element_text(size=12,face = "italic"))+
  scale_colour_manual(values =c('royalblue1','coral1'))+ 
  facet_wrap(~species,scales="free",nrow = 2)+
  scale_y_continuous(limits = c(0, 20))+
  labs(x = "epoch", y= "segmentation loss")

ggsave("figureS9.png", p1, dpi = 900, width = 13, height = 8)

#####################################
# Figure S13 : SPECIES COVER        #
#####################################

# libraries and data
library(dplyr)
library(raster)
library(qdapRegex)
library(ggplot2)
library(purrr)
library(tidyr)

coverage = read.csv(paste0(directory,"field_plot_average_trait_data.csv"))
coverage= coverage[,1:3]
coverage = reshape(coverage, idvar = "scientific.name", timevar = "plot_ID", direction = "wide")
setwd(paste0(directory,'test_plots/masks/aggregated/'))
masks = list.files(path=".")
masks = masks[1:20]

# format field coverage data
coverage = coverage[coverage$scientific.name=='Centaurea cyanus' |
           coverage$scientific.name=='Equisetum arvense' |
           coverage$scientific.name=='Papaver dubium'|
           coverage$scientific.name=='Vicia sativa'|
           coverage$scientific.name=='Vicia hirsuta'|
           coverage$scientific.name=='Tripleurospermum inodorum'|
           coverage$scientific.name=='Cirsium arvense'|
           coverage$scientific.name=='Anchusa arvensis'|
           coverage$scientific.name=='Capsella bursa-pastoris',]

names(coverage) = gsub(pattern = "coverage.", replacement = "", x = names(coverage))

comb = coverage %>%
filter(scientific.name %in% c("Vicia sativa", "Vicia hirsuta")) %>%
summarize(`scientific name` = "Vicia", across(c("plot_ID_26", "plot_ID_27", "plot_ID_28",
"plot_ID_29","plot_ID_30","plot_ID_31","plot_ID_32","plot_ID_33",
"plot_ID_34","plot_ID_35","plot_ID_36","plot_ID_37",
"plot_ID_38","plot_ID_39","plot_ID_40","plot_ID_41","plot_ID_42",
"plot_ID_43","plot_ID_44","plot_ID_45"), sum)) %>% bind_rows(coverage, .)

comb[10,1]='Vicia'
comb[10,4]=comb[5,4]
comb[10,5]=comb[5,5]
comb[10,6]=comb[5,6]
comb[10,7]=comb[5,7]
comb[10,8]=comb[5,8]
comb[10,9]=comb[5,9]
comb[10,10]=comb[5,10]
comb = comb[c(1:4,7:10),c(1:21)]
comb[is.na(comb)] <- 0

# prepare RGB-based manual annotation coverage
RGB_cov<-list()

for (i in masks){
  
  mask = raster(i)
  plot = names(mask)
  plot = ex_between(plot, "plot_", "_flight")[[1]]
  pixels = ncell(mask)
  class = as.data.frame(freq(mask))
  class$species = with(class, ifelse(value == 10, 'Centaurea cyanus',
  ifelse(value == 20, 'Anchusa arvensis',
  ifelse(value == 30, 'Equisetum arvense',
  ifelse(value == 40, 'Vicia',
  ifelse(value == 50, 'Cirsium arvense',
  ifelse(value == 60, 'Tripleurospermum inodorum',
  ifelse(value == 70, 'Papaver dubium',
  ifelse(value == 80, 'Capsella bursa-pastoris','other')))))))))
  prop = round(class$count*100/pixels, digits = 2)
  class$coverage = prop
  class= class[,3:4]
  names(class)[1]='scientific name'
  names(class)[2]=paste0('plot_ID_',plot)
  RGB_cov[[i]] = class
  print(i)
}

RGB = RGB_cov %>% reduce(full_join, by = "scientific name")
RGB[is.na(RGB)] <- 0
RGB = RGB[2:9,]

# combine data and make plot
RGB_plot = gather(RGB, plot, coverage, plot_ID_26:plot_ID_45, factor_key=TRUE) 
names(RGB_plot)[3]='RGB_coverage'
ground_plot = gather(comb, plot, coverage, plot_ID_26:plot_ID_45, factor_key=TRUE) 
names(ground_plot)[3]='ground_coverage'
names(ground_plot)[1]='scientific name'
db = merge(RGB_plot,ground_plot,by=c('scientific name','plot'))
names(db)[1]='name'

plot = ggplot(db, aes(x=ground_coverage, y=RGB_coverage)) +
geom_point(shape=19,size = 5,alpha = 0.5, color ='pink1') +  
geom_abline(slope=1.,lwd=1,color = "purple", size = 1.5) + 
facet_wrap(~name, scales = "free")+
theme_bw() +
theme(axis.text.y = element_text(size = 15),axis.text.x = element_text(size = 15),
axis.title.y = element_text(size = 15),axis.title.x = element_text(size = 15))+
xlab("ground-based coverage %")+ ylab("RGB-based coverage %")

fig = plot + ggh4x::facetted_pos_scales(
x = list(
scale_x_continuous(limits = c(0, 2)),
scale_x_continuous(limits = c(0, 0.6)),
scale_x_continuous(limits = c(0,25)),
scale_x_continuous(limits = c(0, 15)),
scale_x_continuous(limits = c(0, 25)),
scale_x_continuous(limits = c(0,2)),
scale_x_continuous(limits = c(0, 3)),
scale_x_continuous(limits = c(0, 10))
),
y = list(
scale_y_continuous(limits = c(0,2)),
scale_y_continuous(limits = c(0,0.6)),
scale_y_continuous(limits = c(0,25)),
scale_y_continuous(limits = c(0,15)),
scale_y_continuous(limits = c(0,25)),
scale_y_continuous(limits = c(0,2)),
scale_y_continuous(limits = c(0,3)),
scale_y_continuous(limits = c(0,10))))

ggsave("figureS13.png", fig, dpi = 900, width = 8, height = 5)


