# SatelliteImageClassification
Pixel based classification of satellite imagery
- sample training and testing points generated using Point Sampling plugin in QGIS
- feature generation using Orfeo Toolbox
- feature selection using Learning Vector Quantization
- CLassification using Decision Tree, Neural Networks, Random Forests, KNN and Naive Bayes Classifier
- Ensemble classifier for Flood Inundation Mapping - classifies a pixel as water if 2 or more than 2 of the above classifiers classify a pixel as water
- Mode filter used to remove individually wrongly classified pixels
- Classification accuracy to measure goodness of each model

Outcomes of the best classifier (Multi Layer Perceptron) are as shown below:

To compile and run SatelliteClassification.java, you need weka.jar that you can download from the Weka website.

```
Compile code:  javac -cp weka.jar SatelliteClassification.java  
Run code: java -cp weka.jar:. SatelliteClassification  "trainingFile" "testingFile" "classifiername"
```

- order: 

|clouds: white | 
|roads: yellow |
|shadow: black |
|urban: pink |
|vegetation: green |
|water: blue |

- Original LANDSAT 8 Image during Flooding
!["Original LANDSAT 8 Image during Flooding"](./OriginalImage.JPG?raw=true "Original LANDSAT 8 Image during Flooding")

- Multi Layer Perceptron Classification
!["Multi Layer Perceptron Classification"](./mlpf1.JPG?raw=true "Multi Layer Perceptron Classification")

- MLP: Water vs Everything Else
!["MLP: Water vs Everything Else"](./mlp.JPG?raw=true "MLP: Water vs Everything else, zoomed to flooded region")

- Ensemble Classifier
!["Ensemble Classifier"](./beforeFilter.JPG?raw=true "Ensemble Classifier")

- Ensemble Classifier - After Mode Filter
!["Ensemble Classifier - After Mode Filter"](./beforeFilter.JPG?raw=true "Ensemble Classifier - After Mode Filter")


References:
- LANDSAT-8 imagery(http://earthexplorer.usgs.gov/)
- Image Preprocessing - QGIS (http://www.qgis.org/en/site/), ArcGIS (https://www.arcgis.com/features/index.html)
- Feature selection performed using Orfeo Toolbox (https://www.orfeo-toolbox.org/)
- Feature Selection: Vatsavai, Ranga Raju. "High-resolution urban image classification using extended features." In 2011 IEEE 11th International Conference on Data Mining Workshops, pp. 869-876. IEEE, 2011. 