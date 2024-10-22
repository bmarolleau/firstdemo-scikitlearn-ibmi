

# Use the scaler fit on trained data to scale our test data
X_test_scaled = scaler.transform(X_test)
pd.DataFrame(X_test_scaled, columns=X_train.columns).head()

# Get accuracy score
from sklearn.metrics import accuracy_score
# Get model confidence of predictions
y_score_svc = clf_svc.decision_function(X_test_scaled)
y_score_svc

# Get Precision vs. Recall score
from sklearn.metrics import average_precision_score
# Get accuracy score
y_pred_svc = clf_svc.predict(X_test_scaled)
acc_svc = accuracy_score(y_test, y_pred_svc)
print(acc_svc)

# Get Precision vs. Recall score
average_precision_svc = average_precision_score(y_test, y_score_svc)

print('Average precision-recall score: {0:0.2f}'.format(
      average_precision_svc))




