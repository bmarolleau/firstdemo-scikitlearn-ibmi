
# Find interactions between current features and append them to the dataframe
def add_interactions(dataset):
    # Get feature names
    comb = list(combinations(list(dataset.columns), 2))
    col_names = list(dataset.columns) + ['_'.join(x) for x in comb]
    
    # Find interactions
    poly = PolynomialFeatures(interaction_only=True, include_bias=False)
    dataset = poly.fit_transform(dataset)
    dataset = pd.DataFrame(dataset)
    dataset.columns = col_names
    
    # Remove interactions with 0 values
    no_inter_indexes = [i for i, x in enumerate(list((dataset ==0).all())) if x]
    dataset = dataset.drop(dataset.columns[no_inter_indexes], axis=1)
    
    return dataset


X_inter = add_interactions(X)
X_inter.head(15)

# Select best features
select = sklearn.feature_selection.SelectKBest(k=25)
selected_features = select.fit(X_inter, y_le)
indexes = selected_features.get_support(indices=True)
col_names_selected = [X_inter.columns[i] for i in indexes]

X_selected = X_inter[col_names_selected]
X_selected.head(10)



