%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Feature for main.m
%%
%%	Author:				University of Regina
%%	Copyright:		University of Regina
%%	Supervisor:		
%%	Last rev:			
%%	Comment:			COPYRIGHTED MATERIAL COLLECTED FROM
%%								http://www.cs.uregina.ca/Links/class-info/425/Lab5/M-Functions/dftuv.m
%%								DFTUV Computes meshgrid frequency matrices.
%%						  	[U, V] = DFTUV(M, N) computes meshgrid frequency matrices U
%%								and U and V are useful for computing frequency-domain filter 
%%   							functions that can be used with DFTFILT.  U and V are both 
%%								M-by-N.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U, V] = dftuv(M, N)

% Set up range of variables.
u 			= 0:(M-1);
v 			= 0:(N-1);

% Compute the indices for use in meshgrid
idx 		= find(u > M/2);
u(idx)	= u(idx) - M;
idy			= find(v > N/2);
v(idy)	= v(idy) - N;

% Compute the meshgrid arrays
[V, U]	= meshgrid(v, u);
