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

<img src="OriginalImage.JPG" width="500" height ="700" alt="Original LANDSAT 8 Image during Flooding">

- Multi Layer Perceptron Classification

<img src="mlpf1.JPG" width="500" height ="700" alt="Multi Layer Perceptron Classification">

- MLP: Water vs Everything Else

<img src="mlp.JPG" width="500" height ="700" alt="MLP: Water vs Everything else, zoomed to flooded region">

- Ensemble Classifier

<img src="beforeFilter.JPG" width="500" height ="700" alt="Ensemble Classifier">


- Ensemble Classifier - After Mode Filter

<img src="afterFilter.JPG" width="500" height ="700" alt="Ensemble Classifier - After Mode Filter">


References:
- LANDSAT-8 imagery(http://earthexplorer.usgs.gov/)
- Image Preprocessing - QGIS (http://www.qgis.org/en/site/), ArcGIS (https://www.arcgis.com/features/index.html)
- Feature selection performed using Orfeo Toolbox (https://www.orfeo-toolbox.org/)
- Feature Selection: Vatsavai, Ranga Raju. "High-resolution urban image classification using extended features." In 2011 IEEE 11th International Conference on Data Mining Workshops, pp. 869-876. IEEE, 2011. 