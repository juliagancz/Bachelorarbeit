function varargout = princomp(wf);

%     [Spiker - Tool for detecting neural events]
%     Copyright (C) 2006 Heiko Stemmann
% 
%     This program is free software; you can redistribute it and/or modify it under the
%     terms of the GNU General Public License as published by the Free Software Foundation;
%     either version 2 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
%     without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%     See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program;
%     if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
%

wf = wf';
mean_waveform = mean(wf,2);
for i = 1:length(mean_waveform)
    wfs_mean_sub(i,:) = wf(i,:)-mean_waveform(i);
end
cov_matr = cov(double(wfs_mean_sub'));
[V, D] = eig(cov_matr);
D = D(find(D));
[i,j]= sort(D,'descend');
V2take =  V(:,j(1:3));
princmp = V2take' * double(wfs_mean_sub);

if nargout == 2
    figure;hold on;
    pca_plot = plot(princmp(1,:),princmp(2,:),'k.');
    set(gca,'plotboxaspectratio',[1 1 1],...
        'fontsize',18);
    xlab = xlabel('1st Principle Component');
    set(xlab,'fontsize',18);
    ylab = ylabel('2nd Principle component');
    set(ylab,'fontsize',18);
end

nout = nargout;

switch nout
case 1
    varargout = {princmp'};
case 2
    varargout(1) = {princmp'};
    varargout(2) = {pca_plot};
case 3
    warning('Too many output arguments - no argument returned!');
otherwise
        
end