clear
filename = 'D:\Julia\BA\In Vivo\Ratte1\Rat20190513_2019-07-03_12-34-05_0010c\experiment1_105.raw.kwd';
[data,ttl] = analyse_Kwd(filename);
%%
% diff = zeros(18,18);
% nnz = zeros(18,18);
% numel = zeros(18,18);
% d = zeros(18,18);
k = 1:18;
diff = zeros(18,18,1000);
random = randi(18000000,1,1000);
b1 = elek_i/elek_j;
for i = 1:18
    elek_i = data{1}(i,random);
        for j = 1:18
            %if i == j
             %   continue
            %else
                elek_j = data{1}(j,random);
                diff(i,j,:) = elek_i - elek_j;
                %k = k+1;
            %end
        end
%     Elektrode_k(j,:) = diff(i,j,:);
    k = k+1;
    clear diff(j,:)
end

elek_i = data{1}(3,random);%x
elek_j = data{1}(2,random);%y
b1 = elek_i/elek_j;%x/y
ycalc1 = b1*elek_i;
format long
scatter(elek_i,elek_j)
hold on
plot(elek_i,ycalc1)
grid on
hold off

% nnz = nnz(cell2mat(diff{1}));
% numel = numel(cell2mat(diff{1}));
% d = (nnz)/(numel);

%elek10 = data{1}(9,:);
%elek11 = data{1}(8,:);
%corr_1_4 = elek11-elek10;
%plot(corr_1_4);
%d = nnz(corr_1_4)/numel(corr_1_4);