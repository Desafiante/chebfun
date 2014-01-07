function G = quasimatrix(F)
%QUASIMATRIX   A quasimatrix is an array of CHEBFUN objects.
%
%   TODO: Use this to document the difference between an array-valued CHEBFUN
%   and a quasimatrix.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% This method is simply a wrapper for CHEB2QUASI():
G = cheb2quasi(F);

end