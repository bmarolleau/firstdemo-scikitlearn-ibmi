# firstdemo-scikitlearn-ibmi

This demo is based on this [Jupyter Notebook](https://github.com/bmarolleau/firstdemo-scikitlearn-ibmi/blob/master/Churn-IBMi.ipynb)

A first Scikit-Learn demo on IBM i 7.3 forked from this excellent [Scikit Learn and WML tutorial](https://github.com/IBM/customer-churn-prediction/blob/master/notebooks/customer-churn-prediction.ipynb) 

This demo uses a Python 3.6 env, scikit-learn (pandas, seaborn, matplotlib) , jupyter or ipython. 

Simple scenario: extract data from Db2 for i or a CSV file, and create and prepare your datasets, create a supervised classification model (https://scikit-learn.org/stable/modules/svm.html) .

This model can be tested and evaluated, and persisted on disk on IBM i for inference, or exported on an accelerated server or even Watson Machine Learning (on prems, Cloud).
The trained model is stored using joblib (pip install joblib)  in the SVC_Model_CHURN_IBMi_V1.joblib file here, with an accuracy of 0.8, recall 0.7. Room for improvement.

A complete presentation will be shared in the link below.

More information on ML/DL Solutions on IBM Systems & Cloud, including IBM i [here](https://t.co/3QFohFlmIR)

## How to run the demo? 
-  Git clone on your system 
-  Install the required packages (yum install, pip install) then 
-  Simply launch jupyter on your machine  jupyter notebook --port 8888 --ip <your-ip>
-  IPython alternative:  run -i %<FILE-NAME.py>  , where FILE-NAME.py is the name of each python script from step 0 to 16. Respect the order, as each script depends on the previous one.

NB: the dataset used is the CSV file WA_Fn-UseC_-Telco-Customer-Churn.csv  in that particular example.

You can use IBM ACS to create a Db2 table from the CSV and use the 0_load_Dataset_Db2.py to load the data from this table.

