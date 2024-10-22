# IBM i & Machine Learning 101
###  "firstdemo-scikitlearn-ibmi" repository

How to simply use machine learning on IBM ? this repository illustrates the use of real time scoring and data visualization open source technologies on IBM i (aka AS/400), close to business critical applications and data. 

Proposed scenario: In this notebook: 
1) extract data from Db2 for i or a CSV file, 
2) create and prepare your datasets
3) visualize data
4) create a supervised classification model (https://scikit-learn.org/stable/modules/svm.html) . 

Resulting model can be tested and evaluated, and persisted on disk on IBM i for inference, or exported on an accelerated server or even Watson Machine Learning (on prems, Cloud).
It is persisted on disk using joblib (pip install joblib)  in the SVC_Model_CHURN_IBMi_V1.joblib file on the IFS file system.

In this simple scenario, we manage to get an accuracy of 0.8, recall 0.7, which is good starting point!! 

## Documentation
- Main asset of this repo is this [Jupyter Notebook](https://github.com/bmarolleau/firstdemo-scikitlearn-ibmi/blob/master/Churn-IBMi.ipynb)

- Cool presentation [Augment your Apps with H2O Driverless AI, Scikit-Learn & Machine Learning on IBM i](https://ibm.box.com/v/machinelearning-ibmi)  

- Watson ML & Scikit learn tutorial [here](https://github.com/IBM/customer-churn-prediction/blob/master/notebooks/customer-churn-prediction.ipynb) 


## How to use this repository ? 

This demo uses a Python 3.6, scikit-learn (pandas, seaborn, matplotlib) , jupyter or ipython. It can upgraded to more recent Python versions, but make sure your dependencies are aligned with the chosen Python version. 

### Setup Overview
-  Git clone this repository on your system 
-  Install the required packages (yum install, pip install) . Please refer to the setup_instruction.md  
-  Simply launch jupyter on your machine  
```jupyter notebook --port 8888 --ip <your-ip>``` 
-  Python/IPython step by step alternative: Execute python scripts sequentially or use Interactive python with  ``` run -i %<FILE-NAME.py> ```  , where FILE-NAME.py is the name of each python script from step 0 to 20. Respect the order, as each script depends on the previous one. 
- Dataset used is the CSV file ``` WA_Fn-UseC_-Telco-Customer-Churn.csv```  in that particular example. You can use IBM ACS to create a Db2 table from the CSV and use the ```0_load_Dataset_Db2.py```  to load the data from this table.

### Setup Details : IBM i & Machine Learning setup instructions

Notes
-------
-  Please note that we installed here all  ```python3-* ```packages (python version 3.6)  and GCC version 10 is mandatory, so make sure gcc points to gcc 10 inside your chroot  ( ```gcc -v``` , use ```ln -s gcc-10 /QOpenSys/pkgs/bin/gcc``` if necessary)  or on your system if you decide to run in the IFS / without chroot. GCC 10 is required to compile ```argon2-cffi-bindings``` python 3.6 package (headers conflict time.h:124:3: error: conflicting types for 'sigset_t' when using GCC 6)
-  I used in step 3 a custom chroot_setup_script.sh script that normally resides in ```/QOpenSys/QIBM/ProdData/SC1/OpenSSH/sbin/chroot_setup_script.sh``` that I modified to be able to specify to ```CHROOT_PATH``` . Please let me know if there is an easier process with chroot_setup or other standard scripts.
 
 Step by step instructions:
-------
1/ Install ibmichroot  – each user will be using a "chroot jail" :
 ``` bash
[13:59:12][DEMOP.IBM.COM][~]# yum install ibmichroot
 ``` 
2/ (optional) Create user profile 
``` bash
[14:36:54][DEMOP.IBM.COM][~]# system "CRTUSRPRF USRPRF(MLUSR1) USRCLS(*PGMR) "
 ```
3/ chroot settings for ssh
``` bash
[17:15:08][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# ./chroot_setup_script_MOP.sh mlusr1 /QOpenSys/mop_chroots/container-ml
```
 
4/ Copy PASE commands and binaries to the chroot dir
``` bash
[18:33:29][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# chroot_setup container-ml 
```
 
5/ Globalization support aka NLS – Necessary if using locale data 
``` bash
[18:33:29][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# chroot_setup container-ml nls
 ``` 
6/ Install ML packages (400/500 MB)
``` bash
[17:07:09][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# yum install --installroot  /QOpenSys/mop_chroots/container-ml tcl tk python3 python3-* libzmq openssl bash libffi-devel.ppc64 libffi6.ppc64 gcc10.ppc64 git
```
 
7/  Check GCC version in chroot -  GCC V10 required here
``` bash
[22:31:14][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# chroot /QOpenSys/mop_chroots/container-ml gcc -v
```
 
8/ (Optional) – Data scientist user profile customization: bash as default shell in chroot
``` bash
[18:38:26][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# db2util "CALL QSYS2.SET_PASE_SHELL_INFO('mlusr1', '/QOpenSys/pkgs/bin/bash')"
```
 
9/  Install Python packages in CHROOT
``` bash
[22:40:20][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# chroot /QOpenSys/mop_chroots/container-ml pip3.6 install jupyterlab joblib
```
10/ git clone this repository in the chroot directory 
``` bash
[22:48:15][DEMOP.IBM.COM] cd /QOpenSys/mop_chroots/container-ml && git clone https://github.com/bmarolleau/firstdemo-scikitlearn-ibmi 
```
10/ Start Jupyterlab from the chroot and start working: 
``` bash
[22:48:15][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# chroot /QOpenSys/mop_chroots/container-ml jupyter notebook --port 8888 --ip <YOURIP>
```
 
11/ (Optional) Use ssh instead: Login to chroot with ssh for running python scripts or notebooks.
``` bash
[22:48:33][DEMOP.IBM.COM][/QOpenSys/mop_chroots]# ssh mlusr1@localhost
mlusr1@localhost's password: 
*************   IBM i 7.5 Montpellier Client Engineering EMEA  
************   Contact: benoit.marolleau@fr.ibm.com  *************
```
``` bash
-bash-5.2$  jupyter notebook --port 8888 --ip <YOURIP>
[I 22:45:29.967 NotebookApp] Serving notebooks from local directory: /home/mlusr1
[I 22:45:29.967 NotebookApp] Jupyter Notebook 6.4.10 is running at:
[I 22:45:29.967 NotebookApp] http://<YOURIP>:8888/?token=bdee0196a3cf9fb13ef7a95847ad68f0328debdbc749
```
12/ From Jupyterlab Web UI (web browser) , open the notebook you previously cloned on your IBM i. Then, refer to this [Jupyter Notebook](https://github.com/bmarolleau/firstdemo-scikitlearn-ibmi/blob/master/Churn-IBMi.ipynb) for more instructions on how to get started with scikit learn.

## Reference links (chroot, Machine learning etc.)

- [IBM Documentation: chroot and ssh ](https://www.ibm.com/support/pages/using-chroot-ibm-i-restrict-ssh-sftp-and-scp-specific-directories)
- [ IFS containers ](https://techchannel.com/open-source-on-ibm-i/getting-started-with-ifs-containers/)
- [IBM i OSS](https://ibm.github.io/ibmi-oss-resources/)
- [scikit learn](https://scikit-learn.org/stable/)
