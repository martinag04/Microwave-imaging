function RI = ProjectionTriu(svdOperator,difference,soglia)
%nm = length(difference);
%nv = nm;
Esc =  difference;
%Esc=reshape(Es1c,nm*nv,1);%
Esc(isnan(Esc))=0;

Sc = svdOperator.Sc;
Uc = svdOperator.Uc;
Vc = svdOperator.Vc;
s1c=diag(Sc);
valsingnc=(abs(s1c/s1c(1))); %la pos 1 tiene el max

n_values = length(Vc);
RIc=zeros(n_values,1);
%RI=zeros(n_values,length(soglia));

    
[~,Ntrc]=min(abs(20*log10(valsingnc)-soglia));

for ii=1:Ntrc
    RIc=RIc+Vc(:,ii)*(Uc(:,ii)'*Esc)/s1c(ii);
    %RIc=RIc+abs(Vc(:,ii))^2;%Cover
end

RI = RIc;%/max(RIc);

end