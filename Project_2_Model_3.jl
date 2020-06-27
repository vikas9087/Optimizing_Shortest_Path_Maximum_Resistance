#Below packages help in solving Model and Importing data
using JuMP, Gurobi, DataFrames, CSVFiles;
#for drawing graphs below packages are to be used
using LightGraphs,GraphPlot, Cairo, Fontconfig,Compose;
#Storing unique forts into dictionary
file_path="F:/Clemson/Sem 2/IE 6850/Assignment/Project 2/distanceMatrix.csv";
file_read=DataFrame(load(file_path));
forts=union(file_read[:,1],file_read[:,2]);
nr_forts=length(forts);
location=Dict(enumerate(forts));
#Storing names of the nodes to column vector-to be used in graph plotting
node_name=Vector{String}(0);
for i=1:nr_forts
    push!(node_name,location[i])
end
#Adjacency Matrix & Plotting the graph
file_path="F:/Clemson/Sem 2/IE 6850/Assignment/Project 2/ad matrix.csv";
ad_matrix=convert(Array{Int64,2},readcsv(file_path));
G=SimpleGraph(ad_matrix);
nnodes=nv(G);
nedges=ne(G);
draw(PDF("mygraph.pdf", 30cm, 30cm), gplot(G,nodelabel=node_name,nodelabeldist=1.5))
#storing the distances in matrix form and shortest distances to unconnected nodes
file_path="F:/Clemson/Sem 2/IE 6850/Assignment/Project 2/distance_matrix.csv";
distmax=readcsv(file_path);
for i=1:nnodes
    ds=dijkstra_shortest_paths(G, i,distmax)
    sd=ds.dists
    for j=1:nnodes
        distmax[i,j]=sd[j]
        distmax[j,i]=sd[j]
    end
end
#To make diagonal elements non-zero,it reduces the time taken to solve
for i=1:nnodes
    distmax[i,i]=1e5
end
#formulating a model
GOT3=Model(solver=GurobiSolver());
#Binary variable to select if a node is visted
@variable(GOT3,x[i=1:nnodes,j=1:nnodes],Bin);
#Objective to minimize the total distance travelled
@objective(GOT3,Min,sum(distmax[i,j]*x[i,j] for i=1:nnodes,j=1:nnodes));
#Must start from Castle Black
@constraint(GOT3,C1,sum(x[1,j] for j=1:nnodes)==1);
#Must return to Castle Black
@constraint(GOT3,C2,sum(x[i,1] for i=1:nnodes)==1);
#Every castle should be visited exactly once
@constraint(GOT3,C3[j=1:nnodes],sum(x[i,j] for i=1:nnodes)==1);
@constraint(GOT3,C4[i=1:nnodes],sum(x[i,j] for j=1:nnodes)==1);
#MTZ constraints to avoid looping
@variable(GOT3,1<=u[1:nnodes]<=nnodes,Int);
@constraint(GOT3,u[1]==1);
@constraint(GOT3,C5[i=2:nnodes,j=2:nnodes],sum(u[i]-u[j]+1-(nnodes-1)*(1-x[i,j]))<=0);
tic()
status=solve(GOT3)
toq()
#Storing the values of nodes in a vector
println("The total minimum distance travelled from ",location[1]," and return to ",location[1]," after visiting every fort is= ",getobjectivevalue(GOT3))
H=SimpleDiGraph(nnodes)
value=getvalue(x);
for i=1:nnodes
    for j=1:nnodes
        if value[i,j]==1.0
            add_edge!(H,i,j)
        else
        end
    end
end
membership=[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2];
nodecolor = ["lightseagreen", "orange"];
nodefillc = nodecolor[membership];
draw(PNG("path_travelled_shortest.png", 20cm, 20cm), gplot(H,nodefillc=nodefillc,nodelabel=node_name,nodelabeldist=2,arrowlengthfrac=0.05,nodelabelangleoffset=π/2))
