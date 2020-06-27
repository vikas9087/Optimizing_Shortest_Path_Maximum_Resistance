#Using packages
using JuMP, Gurobi,CSVFiles,DataFrames;
#model name
file_path="F:/Clemson/Sem 2/IE 6850/Assignment/Project 2/dist_modified.csv"
distance =readcsv(file_path);
alpha=0.5;
narmy=3;
numnodes=18;
numarc=length(distance[:,3]);
b=zeros(numnodes,numnodes);
for i=1:numnodes
    for j=1:numnodes
        if i==j
            b[i,j]=-1
        else
            b[1,i]=1
        end
    end
end
#Tail nodes emerging out of arc
nplus=[1,1,2,2,3,4,4,4,5,5,6,6,6,6,7,7,8,9,10,10,11,11,11,12,12,12,13,13,13,14,15,16,2,3,3,4,4,5,7,11,6,7,7,8,11,10,8,9,11,11,11,12,12,13,17,14,15,13,15,17,16,15,16,18];
#Head nodes for each arc
nminus=[2,3,3,4,4,5,7,11,6,7,7,8,11,10,8,9,11,11,11,12,12,13,17,14,15,13,15,17,16,15,16,18,1,1,2,2,3,4,4,4,5,5,6,6,6,6,7,7,8,9,10,10,11,11,11,12,12,12,13,13,13,14,15,16];
GOT2=Model(solver=GurobiSolver());
#Defining variable for placing an army
@variable(GOT2,x[1:numarc],Bin);
#Defining dual variable for shortest path for each node
@variable(GOT2,pi2[1:numnodes]);
@variable(GOT2,pi3[1:numnodes]);
@variable(GOT2,pi4[1:numnodes]);
@variable(GOT2,pi5[1:numnodes]);
@variable(GOT2,pi6[1:numnodes]);
@variable(GOT2,pi7[1:numnodes]);
@variable(GOT2,pi8[1:numnodes]);
@variable(GOT2,pi9[1:numnodes]);
@variable(GOT2,pi10[1:numnodes]);
@variable(GOT2,pi11[1:numnodes]);
@variable(GOT2,pi12[1:numnodes]);
@variable(GOT2,pi13[1:numnodes]);
@variable(GOT2,pi14[1:numnodes]);
@variable(GOT2,pi15[1:numnodes]);
@variable(GOT2,pi16[1:numnodes]);
@variable(GOT2,pi17[1:numnodes]);
@variable(GOT2,pi18[1:numnodes]);
#defining objective to maximize the shortest distance
@objective(GOT2,Max,sum(b[i,2]*pi2[i]+b[i,3]*pi3[i]+b[i,4]*pi4[i]+b[i,5]*pi5[i]+b[i,6]*pi6[i]+b[i,7]*pi7[i]+b[i,8]*pi8[i]+b[i,9]*pi9[i]+b[i,10]*pi10[i]+b[i,11]*pi11[i]+b[i,12]*pi12[i]+b[i,13]*pi13[i]+b[i,14]*pi14[i]+b[i,15]*pi15[i]+b[i,16]*pi16[i]+b[i,17]*pi17[i]+b[i,18]*pi18[i] for i=1:numnodes));
#defining the constraints for dual shortest problem
@constraint(GOT2,C1[i=1:numarc],sum(pi2[j] for j in nplus[i])-sum(pi2[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C2[i=1:numarc],sum(pi3[j] for j in nplus[i])-sum(pi3[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C3[i=1:numarc],sum(pi4[j] for j in nplus[i])-sum(pi4[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C4[i=1:numarc],sum(pi5[j] for j in nplus[i])-sum(pi5[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C5[i=1:numarc],sum(pi6[j] for j in nplus[i])-sum(pi6[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C6[i=1:numarc],sum(pi7[j] for j in nplus[i])-sum(pi7[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C7[i=1:numarc],sum(pi8[j] for j in nplus[i])-sum(pi8[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C8[i=1:numarc],sum(pi9[j] for j in nplus[i])-sum(pi9[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C9[i=1:numarc],sum(pi10[j] for j in nplus[i])-sum(pi10[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C10[i=1:numarc],sum(pi11[j] for j in nplus[i])-sum(pi11[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C11[i=1:numarc],sum(pi12[j] for j in nplus[i])-sum(pi12[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C12[i=1:numarc],sum(pi13[j] for j in nplus[i])-sum(pi13[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C13[i=1:numarc],sum(pi14[j] for j in nplus[i])-sum(pi14[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C14[i=1:numarc],sum(pi15[j] for j in nplus[i])-sum(pi15[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C15[i=1:numarc],sum(pi16[j] for j in nplus[i])-sum(pi16[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C16[i=1:numarc],sum(pi17[j] for j in nplus[i])-sum(pi17[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
@constraint(GOT2,C17[i=1:numarc],sum(pi18[j] for j in nplus[i])-sum(pi18[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i]);
#defining constraints for number of available armies
@constraint(GOT2,C18,sum(x[i] for i=1:numarc)<=narmy)
#logical constraint
#@constraint(GOT2,C3[i=1:numarc],x[i]<=getdual(C1[i]))
tic()
status=solve(GOT2)
toc()
println("The avergae shortest maximum distance for visiting all castles is= ",floor(getobjectivevalue(GOT2)/(numnodes-1))," when number of available armies are= ",narmy)
army=getvalue(x);
for i=1:numarc;
    if army[i]>0
        println("From ",distance[i,1]," To ",distance[i,2])
    else
    end
end
