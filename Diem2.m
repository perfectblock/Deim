function Throughput= Diem(N, f, QC, p, D, N_tx, D_tx, To)


% Function Throughput estimates the Throughput of the Diem Blockchain
% Inputs:
%   N- Total number of validators (give N>2)
%   f- Number of faulty nodes 
%   QC- Quorum size. Enter -1 if you intend to set QC=2f+1 
%   p- Packet delivery ratio
%   D- Average P2P latency. D is in ms. for instance, if you enter D=2, it means D=2 ms.  
%   N_tx- Number of transactions per block 
%   D_tx- Processing time of 1 transaction. D_tx is in ms. for instance, if you enter D_tx=2, it means D_tx=2 ms.
%   To- Time out value (in second). for instance if you enter 2, it means 2s


clc


%Left side vectors are used in the mathematical model and right side
%vectores are the equivalants in the simulation
%(i,j,k)=(a,b,c)
%(i',j',k')=(A,B,C)
%PY_k-->PY[]
%PY_(k+1)-->PY1[]
%PY_(k+2)-->PY2[]


if QC==-1
    QC=2*f+1;
 end

D=0.001*D;  
D_tx=0.001*D_tx;  





PY=zeros(1,N-QC+1);
PY1=zeros(1,N-QC+1);
PY2=zeros(1,N-QC+1);
PX=zeros(1,N-QC+1);
PX1=zeros(1,N-QC+1);
PX2=zeros(1,N-QC+1);


for  i=1:N-QC+1
    C=i+QC-1;
    PX(i)=(p^C)*((1-p)^(N-C))*nchoosek(N,C)*(N-f)/N;  
    %Result= P{X_k=k'} 
    %Result= P{X_k=k'}
  
      
end


for  i=1:N-QC+1
    c=i+QC-1;
    t=zeros(1,N-QC+1); %temporary vector  
    for j=i:N-QC+1
        C=j+QC-1;
    t(j)=((p^c)*((1-p)^(C-c))*nchoosek(C,c))*PX(j);
    end
    PY(i)=sum(t);
end


for  i=1:N-QC+1
    B=i+QC-1;
    t=zeros(1,N-QC+1); %temporary vector 
    for j=i:N-QC+1
        c=j+QC-1;
    t(j)=((p^B)*((1-p)^(c-B))*nchoosek(c,B))*PY(j);
    end
    PX1(i)=sum(t)*(N-f-1)/(N-1);
end



for  i=1:N-QC+1
    b=i+QC-1;
    t=zeros(1,N-QC+1); %temporary vector 
    for j=i:N-QC+1
        B=j+QC-1;
    t(j)=((p^b)*((1-p)^(B-b))*nchoosek(B,b))*PX1(j);
    end
    PY1(i)=sum(t);
end


for  i=1:N-QC+1
    A=i+QC-1;
    t=zeros(1,N-QC+1); %temporary vector 
    for j=i:N-QC+1
        b=j+QC-1;
    t(j)=((p^A)*((1-p)^(b-A))*nchoosek(b,A))*PY1(j);
    end
    PX2(i)=sum(t)*(N-f-2)/(N-2);
end



for  i=1:N-QC+1
    a=i+QC-1;
    t=zeros(1,N-QC+1); %temporary vector 
    for j=i:N-QC+1
        A=j+QC-1;
    t(j)=((p^a)*((1-p)^(A-a))*nchoosek(A,a))*PX2(j);
    end
    PY2(i)=sum(t);
end


Ps=sum(PY2);


%n_k     ----->n
%n_(k+1) ----->n1
%n_(k+2) ----->n2


n=ceil(p*N*(N-f)/N);


t=zeros(1,floor(n)-QC+1); %temporary vector

for i=1:floor(n)-QC+1 
    T=QC+i-1;
    t(i)=(p^T)*((1-p)^(floor(n)-T))*(nchoosek(floor(n),T));
    
end

   n1=ceil(sum(t)*p*N*(N-f-1)/(N-1));
   
   t=zeros(1,floor(n1)-QC+1); %temporary vector
   for i=1:floor(n1)-QC+1 
    T=QC+i-1;
    t(i)=(p^T)*((1-p)^(floor(n1)-T))*(nchoosek(floor(n1),T));
    
   end

   n2=ceil(sum(t)*p*N*(N-f-2)/(N-2));
  
   
   % Definitions 
   %E[T_(nk)]----->ETn
   %E[T_(nk1)]----->ETn1
   %E[T_(nk2)]----->ETn2
   %E[T_s]----->ETs
   %E[T_c]----->ETc
   
   t=zeros(1,QC); %temporary vector
for i=1:QC  
    
    t(i)=1/(n-i+1); 
    
     end


ETn=D*sum(t);
   
  
for i=1:QC 
    
    t(i)=1/(n1-i+1);
    
end
   

   ETn1=D*sum(t);
   
   for i=1:QC  
    
    t(i)=1/(n2-i+1);
    
   end
 
   ETn2=D*sum(t);
   
   ETs=3*D+ ETn+ ETn1+ ETn2+8*N_tx*D_tx
  
   
   if ETs>To
       ETs=inf,
   end
   
 
   ETc= ETs+(1-Ps)*To
   Throughput= N_tx*3/ETc
 
   