using JuMP, Gurobi,CSVFiles,DataFrames;
file_path="F:/Clemson/Sem 2/IE 6850/Assignment/Project 2/dist_modified.csv"
distance =readcsv(file_path);
alpha=0.5;
narmy=3;
numnodes=18;
numarc=length(distance[:,3]);
b=zeros(numnodes);
b[1]=1;
b[11]=-1;
nplus=[1,1,2,2,3,4,4,4,5,5,6,6,6,6,7,7,8,9,10,10,11,11,11,12,12,12,13,13,13,14,15,16,2,3,3,4,4,5,7,11,6,7,7,8,11,10,8,9,11,11,11,12,12,13,17,14,15,13,15,17,16,15,16,18];
nminus=[2,3,3,4,4,5,7,11,6,7,7,8,11,10,8,9,11,11,11,12,12,13,17,14,15,13,15,17,16,15,16,18,1,1,2,2,3,4,4,4,5,5,6,6,6,6,7,7,8,9,10,10,11,11,11,12,12,12,13,13,13,14,15,16];
GOT1=Model(solver=GurobiSolver());
#Defining variable for placing an army
@variable(GOT1,x[1:numarc],Bin)
#Defining dual variable for shortest path
@variable(GOT1,pi[1:numnodes])
#defining objective to maximize the shortest distance
@objective(GOT1,Max,sum(b[i]*pi[i] for i=1:numnodes))
#defining the constraints for dual shortest problem
@constraint(GOT1,C1[i=1:numarc],sum(pi[j] for j in nplus[i])-sum(pi[j] for j in nminus[i])<=distance[i,3]+alpha*distance[i,3]*x[i])
#defining constraints for number of available armies
@constraint(GOT1,C2,sum(x[i] for i=1:numarc)<=narmy)
#logical constraint
#@constraint(GOT1,C3[i=1:numarc],x[i]<=getdual(C1[i]))
status=solve(GOT1)
println("The shortest maximum distance for visiting King's Landing is= ",getobjectivevalue(GOT1)," when number of available armies are= ",narmy)
army=getvalue(x);
for i=1:numarc;
    if army[i]>0
        println("From ",distance[i,1]," To ",distance[i,2])
    else
    end
end
