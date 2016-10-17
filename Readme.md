# SatelliteImageClassification
Pixel based classification of satellite imagery
- sample training and testing points generated using Point Sampling plugin in QGIS
- feature generation using Orfeo Toolbox
- feature selection using Learning Vector Quantization
- CLassification using Decision Tree, Neural Networks, Random Forests, KNN and Naive Bayes Classifier
- Classification accuracy to measure goodness of each model

Outcomes of the best classifier (Multi Layer Perceptron) are as shown below:

- order: 

|clouds: white | 
|roads: yellow |
|shadow: black |
|urban: pink |
|vegetation: green |
|water: blue |

!["Multi Layer Perceptron Classification"](./mlpf1.JPG?raw=true "Multi Layer Perceptron Classification")