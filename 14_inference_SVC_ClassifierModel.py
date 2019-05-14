import numpy as np

XInfer= np.array([[20.0, 0.0, 1.0, 0.0, 60.55, 10.0, 15.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]])
print("Support Vector Machine (aka Scikit Learn SVC) Model Inference - Telco Churn on IBM i 7.3")
print("Input Data to classify:", end="")
print(XInfer)
print("Result (Class):", end="")
print(clf_svc.predict(XInfer))
	
