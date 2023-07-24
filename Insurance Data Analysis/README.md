# **Health Insurance Data Analysis** #

This project analyzes an insurance dataset using Python and the Seaborn library. The main goal is to explore the dataset and identify any potential relationships between the variables, particularly the "smoker" and "charges" variables.

![legal_medical_analysis_cropped](https://user-images.githubusercontent.com/105461536/226491928-5700af4c-6e73-43ba-b1f1-91cf99a8f9c8.jpg)


## **Dataset** ##
The insurance dataset used in this project contains information on medical costs for different individuals. The dataset includes the following columns:

•	age: age of the individual

•	sex: gender of the individual (male or female)

•	bmi: body mass index of the individual

•	children: number of children the individual has

•	smoker: whether the individual is a smoker (yes or no)

•	region: the region where the individual lives (northeast, southeast, southwest, or northwest)

•	charges: medical charges for the individual

The dataset can be found in the [**insurance.csv**](https://github.com/OlePole1/Portfolio_projects/blob/main/Insurance%20Data%20Analysis/insurance-data.csv) file.

## **Analysis** ##
The [**insurance project.ipynb**](https://github.com/OlePole1/Portfolio_projects/blob/main/Insurance%20Data%20Analysis/Insurance%20project.ipynb) notebook contains the code for analyzing the dataset. The notebook first loads the dataset using the Seaborn library and performs some initial exploration of the data, such as checking for missing values and calculating summary statistics.
The notebook then uses various seaborn functions to create visualizations of the data, such as histograms, box plots, and scatter plots. These visualizations are used to identify any potential relationships between the variables, particularly the "smoker" and "charges" variables.

## **Findings** ##
The study found that there is a positive relationship between the "smoker" attribute and the "charges" attribute in the dataset. This means that on average, smokers tend to have higher medical charges than non-smokers. Additionally, the study found that this relationship is consistent across different age groups, with older individuals generally having higher charges than younger individuals regardless of their smoking status.

It is important to note that the study is limited to the data in the dataset and may not necessarily generalize to the broader population. Additionally, the study did not account for other variables that could affect medical charges, such as pre-existing conditions or lifestyle factors beyond smoking status. Therefore, the results should be interpreted with caution and further research may be needed to fully understand the relationship between smoking and medical charges.

