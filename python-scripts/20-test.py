#XInfer=pd.DataFrame(X_train_scaled, columns=X_train.columns).head(20).values                                                                                                              
#print(clf_svc.predict(XInfer))                                                                                                                                                            
#[0 0 0 1 0 1 0 0 0 0 0 1 0 1 0 1 0 0 0 0]

#X_train_scaled.shape                                                                                                                                                                      
#(4718, 25)

X_test_scaled.shape                                                                                                                                                                       
#(2325, 25)
print("Testing model on IBM i")
print("Test Dataset:")
print(X_test_scaled)

XInfer=pd.DataFrame(X_test_scaled, columns=X_train.columns).head(20).values                                                                                                               
print("Result on 20 examples")
print(clf_svc.predict(XInfer))                                                                                                                                                            
#[1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0 1]

