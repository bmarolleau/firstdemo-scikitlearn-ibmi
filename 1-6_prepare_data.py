# Import packages & libraries 
import os
import pandas as pd
from pandas import Series, DataFrame
#import pandas_profiling

pd.set_option('display.max_rows', None,'display.max_columns', None)

import numpy as np

from collections import Counter

from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier, ExtraTreesClassifier, VotingClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import GridSearchCV, cross_val_score, StratifiedKFold, learning_curve, cross_validate
from sklearn.metrics import confusion_matrix, precision_score, recall_score, f1_score, make_scorer, roc_auc_score,accuracy_score, roc_curve
from scipy.stats import ks_2samp

from sklearn.preprocessing import Imputer, StandardScaler
#from sklearn import cross_validation
from sklearn import metrics

import os
import pandas as pd
import numpy as np
from sklearn import preprocessing, svm
from itertools import combinations
from sklearn.preprocessing import PolynomialFeatures, LabelEncoder, StandardScaler
import sklearn.feature_selection
from sklearn.model_selection import train_test_split
from collections import defaultdict
from sklearn import metrics
customer_data= pd.read_csv('WA_Fn-UseC_-Telco-Customer-Churn.csv')
pd.set_option('display.max_columns', 30)
customer_data.head(10)
customer_data = customer_data.drop('customerID', axis=1)
customer_data.head(5)
new_col = pd.to_numeric(customer_data.iloc[:, 18], errors='coerce')
new_col
customer_data.iloc[:, 18] = pd.Series(new_col)
customer_data
customer_data.isnull().values.any()

from sklearn.preprocessing import Imputer

imp = Imputer(missing_values="NaN", strategy="mean")

customer_data.iloc[:, 18] = imp.fit_transform(customer_data.iloc[:, 18].values.reshape(-1, 1))
customer_data.iloc[:, 18] = pd.Series(customer_data.iloc[:, 18])
customer_data.isnull().values.any()
customer_data.info()
pd.set_option('precision', 3)
customer_data.describe()
customer_data.describe(exclude=np.number)
customer_data.corr(method='pearson')
display(customer_data)

customer_data_encoded = pd.get_dummies(customer_data)
customer_data_encoded.head(10)
