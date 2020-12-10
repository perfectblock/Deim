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
