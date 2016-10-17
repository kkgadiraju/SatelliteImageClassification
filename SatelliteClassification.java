/*
	Krishna Karthik Gadiraju / kkgadiraju
	Classify satellite attributes using weka
	Source: Weka Home page and tutorials

    To compile this code: javac -cp path-to-your-weka.jar-file SatelliteClassification.java
    To run this code: java -cp weka.jar:. SatelliteClassification  "may28-trainingTop10-AllBands-final.arff" "may28-testingTop10-AllBands-final.arff" "classifier-name"

    Tested java version: openjdk version "1.8.0_102"
    OpenJDK Runtime Environment (build 1.8.0_102-b14)

    Operating System: Red Hat Enterprise 7.2

 */

import java.io.File;
import java.io.FileNotFoundException;
import weka.core.converters.CSVSaver;
import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.trees.RandomForest;
import weka.classifiers.trees.J48;
import weka.classifiers.functions.MultilayerPerceptron;
import weka.classifiers.lazy.IBk;
import weka.core.Attribute;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;



public class SatelliteClassification {
	public static void main(String[] args){
		DataSource training=null,testing=null;
		Instances trData=null, teData=null;
		if(args.length<3){
			System.out.println("Enter 2 paths and type of classifier (nBayes, j48, randomForest, knn or mlp)  as command line arguments: training,testing");
			System.exit(0);
		}
		System.out.println("Training data source: "+args[0]);
		System.out.println("Testing data source: "+args[1]);
		System.out.println("Classifier type: "+args[2]);
		try {
			//link to files
			long startTime = System.nanoTime();
			training = new DataSource(args[0]);
			testing = new DataSource(args[1]);
			//read the file
			trData = training.getDataSet();
			teData = testing.getDataSet();
			System.out.println("Finished reading datasets.....");
			if(training!=null && testing!=null){
				System.out.println("Dataset structure.....");
				System.out.println(training.getStructure());
				System.out.println(testing.getStructure());

				//Set class attribute
				if (trData.classIndex() == -1)
					trData.setClassIndex(trData.numAttributes()-1);
				if (teData.classIndex() == -1)
					teData.setClassIndex(teData.numAttributes()-1);
				Classifier cModel;
				//Train classifiers
				switch(args[2]) {
					case "nbayes":
						cModel = (Classifier) new NaiveBayes();
						break;
					case "j48":
						cModel = (Classifier)new J48();
						break;
					case "randomForest":
						cModel = (Classifier)new RandomForest();
						break;
					case "mlp":
						cModel = (Classifier)new MultilayerPerceptron();
						break;
					case "knn":
						cModel = (Classifier)new IBk(10);
						break;
					default:
						System.out.println("Incompatible classifier name given, using Naive Bayes by default");
						cModel = (Classifier) new NaiveBayes(); //Set to naive bayes by default

				}
				cModel.buildClassifier(trData);
				// create copy
				Instances teResults = new Instances(teData);
				// label instances
				for (int i = 0; i < teResults.numInstances(); i++) {
					double clsLabel = cModel.classifyInstance(teData.instance(i));
					teResults.instance(i).setClassValue((int)clsLabel);
				}

				//write output to CSV
				CSVSaver outFile = new CSVSaver();
				outFile.setFile(new File(args[2]+".csv"));
				outFile.setInstances(teResults);
				outFile.writeBatch();
				long endTime = System.nanoTime();
				System.out.println("Finished execution in"+(endTime-startTime)/1000000+" seconds");

			}
			else{
				System.out.println("File read incorrectly.....");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
