function varargout = clustercutter(wavepca, pca_plot)

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

% BUTTON = 0;
% counter = 0;
% 
% while BUTTON ~=3
%     counter = counter + 1;
%     [X(counter),Y(counter),BUTTON] = ginput(1);
%     plot(X,Y,'r');
% end
% X(counter + 1) = X(1);
% Y(counter + 1) = Y(1);
% plot(X,Y,'r');

X = [-2000 2000];
Y = [-2000 2000]; %von oben bis unten, wie groﬂ soll der Cluster sein

%inside = inpolygon(wavepca(:,1), wavepca(:,2), X, Y);
index2cluster = inpolygon(wavepca(:,1), wavepca(:,2),X,Y); %points specified by wavepca are inside of area X,Y.
%index2cluster = find(inside);


plot(wavepca(find(index2cluster), 1), wavepca(find(index2cluster), 2), '.g')
% keyboard


if nargout == 1
    varargout{1} = index2cluster;
end