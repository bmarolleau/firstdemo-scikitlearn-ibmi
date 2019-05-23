# firstdemo-scikitlearn-ibmi

A first Scikit-Learn demo on IBM i 7.3 forked from this excellent [Scikit Learn and WML tutorial](https://github.com/IBM/customer-churn-prediction/blob/master/notebooks/customer-churn-prediction.ipynb) 

This demo uses a Python 3.6 env, scikit-learn, ipython. 

Simple scenario: extract data from Db2 for i or a CSV file, and create and prepare your datasets, create a supervised classification model (https://scikit-learn.org/stable/modules/svm.html) .

This model can be tested and evaluated, and persisted on disk on IBM i for inference, or externalize on an accelerated server or even Watson Machine Learning (on prems, Cloud).

## How to run the demo? 
Simply launch ipython from a bash shell.  Then type run -i %<FILE-NAME.py>  , where FILE-NAME.py is the name of each python script from step 0 to 16. Respect the order, as each script depends on the previous one.
Once the model created and persisted, you can simply invoke the inference part, as shown in script 20_*.py
NB: the dataset used is the CSV file WA_Fn-UseC_-Telco-Customer-Churn.csv  in that particular example
You can use IBM ACS to create a Db2 table from the CSV and use the 0_load_Dataset_Db2.py to load the data from this table.

Next: A version with jupyter (web IDE for python & R) instead of ipython as an interactive python environment.

More information on AI Solutions and ML/DL on IBM i [here](https://t.co/3QFohFlmIR)
