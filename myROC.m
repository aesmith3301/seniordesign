function [AUC]=myROC(decisiondata);


decisionvalues = decisiondata(:,2); %isolate the decision variables and truevalues into its own array
truevalue = decisiondata(:,1);

%decision threshold directly uses the decision varialbe
rearrangeddecision = sort(decisionvalues,'ascend'); %rearrange the decision variables from small to large to have the plot points not jump around

for n = 1:size(decisiondata,1)
    
    A=0; B=0; C=0; D=0; %A,B,C,D are TP,FP,FN,TN in the decision matrix
    newdecisionvalues = decisionvalues - rearrangeddecision(n);  %generate a new decision values based on the decision threshold
    
    for I = 1:length(decisionvalues) %the loop test if the decision values are true or false based on the new threshold
        if newdecisionvalues(I)>=0   %set to 1 if larger, set to 0 if smaller
            newdecisionvalues(I)=1;
        end
        if newdecisionvalues(I)<0
            newdecisionvalues(I)=0;
        end
        
    end
    
    for I = 1:length(truevalue)  %forms the decision marix based on the new decision values and the true values for one specific threshold
       if truevalue(I)==0 && newdecisionvalues(I)==0
           D = D+1;
       end
       if truevalue(I)==0 && newdecisionvalues(I)==1
           B = B+1;
       end
       if truevalue(I)==1 && newdecisionvalues(I)==0
           C = C+1;
       end
       if truevalue(I)==1 && newdecisionvalues(I)==1
           A = A+1;
       end
    end
    
    sensitivity = A/(A+C);  %calculate necessary variables for ROC curve
    specificity = D/(B+D);
    FPF = 1-specificity;
    
    plotFPF(n) = FPF; %create an array of FPF and TPF values for ROC curve
    plotTPF(n) = sensitivity;
    
end
plotFPF(n+1) = 0; %Add initial 0 FPF and TPF points that exists in all ROC curves
plotTPF(n+1) = 0;

plot(plotFPF,plotTPF,'-O'); %plot the ROC curve
title('ROC Curve');
xlabel('False Positive Fraction');
ylabel('True Positive Fraction');

AUC = - trapz(plotFPF,plotTPF); %calculate the area under the curve for the ROC curve using trapezoid rule