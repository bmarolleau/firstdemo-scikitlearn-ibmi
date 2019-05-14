
# Create training data for non-preprocessed approach
X_npp = customer_data.iloc[:, :-1].apply(LabelEncoder().fit_transform)
pd.DataFrame(X_npp).head(5)

# Create training data for that will undergo preprocessing
X = customer_data_encoded.iloc[:, :-2]
X.head()

# Extract labels
y_unenc = customer_data['Churn']

# Convert strings of 'yes' and 'no' to binary values of 0 or 1
le = preprocessing.LabelEncoder()
le.fit(y_unenc)

y_le = le.transform(y_unenc)
pd.DataFrame(y_le)


