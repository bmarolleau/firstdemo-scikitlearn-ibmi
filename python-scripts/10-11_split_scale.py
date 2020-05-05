#Split Data
X_train, X_test, y_train, y_test = train_test_split(X_selected, y_le,\
                                                    test_size=0.33, random_state=42)
print(X_train.shape, y_train.shape)
print(X_test.shape, y_test.shape)

# Use StandardScaler
scaler = preprocessing.StandardScaler().fit(X_train, y_train)
X_train_scaled = scaler.transform(X_train)

pd.DataFrame(X_train_scaled, columns=X_train.columns).head()
pd.DataFrame(y_train).head()

