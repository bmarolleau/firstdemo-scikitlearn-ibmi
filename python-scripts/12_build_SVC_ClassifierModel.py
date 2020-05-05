
#Support Vector Macines on preprocessed data
from sklearn.svm import SVC
# Run classifier
clf_svc = svm.SVC(random_state=42)
clf_svc.fit(X_train_scaled, y_train)

