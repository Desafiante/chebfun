classdef chebfun3
%CHEBFUN3   CHEBFUN3 class for representing functions on [a,b]x[c,d]x[e,g].
%   Class for approximating functions defined on finite cubes. The 
%   functions should be smooth.
%
%   CHEBFUN3(F) constructs a CHEBFUN3 object representing the function F on
%   [-1, 1] x [-1, 1] x [-1, 1]. F should be a function handle, e.g.,
%   @(x,y,z) x.*y + cos(x).*z, or a tensor of doubles corresponding to 
%   values of a function at points generated by ndgrid. F should be 
%   "vectorized" in the sense that it may be evaluated at a tensor of 
%   points and returns a tensor output. 
%
%   CHEBFUN3(F, 'eps', ep) specifies chebfun3eps to be ep.
%
%   CHEBFUN3(F, [A B C D E G]) specifies a cube [A B] x [C D] x [E G] where
%   the function is defined. A, B, C, D, E and G must all be finite.
%
%   If F is a tensor, F = (f_{ijk}), the numbers f_{ijk} are used as 
%   function values at tensor Chebyshev points of the 2nd kind generated by 
%   ndgrid.
%
%   CHEBFUN3(F, 'equi'), for a discrete tensor of values at equispaced 
%   points in 3D.
%
%   CHEBFUN3(F, [m n p]) returns a representation of a trivariate 
%   polynomial of length (m, n, p), i.e., with degree (m-1) in x, degree 
%   (n-1) in y and degree (p-1) in z. The polynomial is compressed in low 
%   multilinear rank form and the multilinear rank (r1, r2, r3) is still 
%   determined adaptively.
%
%   CHEBFUN3(F, 'rank', [r1 r2 r3]) returns a CHEBFUN3 with multilinear 
%   rank (r1, r2, r3) approximation to F.
% 
%   CHEBFUN3(F, 'coeffs') where F is a tensor, uses F as coefficients in 
%   a Chebyshev tensor expansion.
%
% See also CHEBFUN3V and CHEBFUN3T.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS PROPERTIES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
properties
    % COLS: Mode-1 fibers, i.e., columns which are functions of x used in 
    % Tucker representation.
    cols
    
    % ROWS: Mode-2 fibers, i.e. rows which are functions of y used in 
    % Tucker representation.
    rows
    
    % TUBES: Mode-3 fibers, i.e. tubes which are functions of z used in 
    % Tucker representation.
    tubes
    
    % CORE: discrete core tensor in Tucker representation
    core
    
    % DOMAIN: box of CHEBFUN3, default is [-1, 1] x [-1, 1] x [-1, 1].
    domain
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS CONSTRUCTOR:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
methods
    function f = chebfun3(varargin)
        % The main CHEBFUN3 constructor!
        
        % Return an empty CHEBFUN3:
        if ( (nargin == 0) || isempty(varargin{1}) )
            return
        end
        
        % Call the constructor, all the work is done here:
        f = constructor(f, varargin{:});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLASS METHODS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
methods (Access = public, Static = true)    
    % Outer product of discrete tensors.
    varargout = outerProd(varargin);
    
    % Tensor x matrix.
    varargout = txm(varargin);
    
    % Unfold a discrete tensor to create a matrix.
    varargout = unfold(varargin);
    
    % Reshape a discrete matrix to get a tensor.
    varargout = fold(varargin);
    
    % Tensor product of Chebyshev points.
    [xx, yy, zz] = chebpts3(m, n, p, domain, kind);

    % Convert 3D values to 3D coefficients.
    coeffs3D = vals2coeffs(vals3D);
    
    % Convert 3D coefficients to 3D values.
    vals3D = coeffs2vals(coeffs3D);
        
    % Faster subscripts from linear index.
    varargout = myind2sub(varargin);
    
    % HOSVD of discrete tensors.
    varargout = discrete_hosvd(varargin);
    
end

methods (Access = public)
    % Retrieve and modify preferences for this class.
    varargout = subsref(f, index);
    
    % Get properties of a CHEBFUN3 object.
    out = get(f, idx);

    % Permute a CHEBFUN3.
    out = permute(f, varargin);

    % Evaluate a CHEBFUN3.
    out = feval(f, varargin);
        
    % Evaluate at vectors to get a tensor of values.
    out = fevalt(f, varargin);
        
    % Evaluate on a tensor product grid.
    varargout = chebpolyval3(varargin);
    
    % Sample a CHEBFUN3 on a tensor product grid
    varargout = sample(varargin);
    
    % Tucker rank of a CHEBFUN3 (i.e., size of the core in each direction).
    varargout = rank(f);
        
    % Length of a CHEBFUN3 (i.e., the number of Chebyshev or Fourier points
    % at each direction).
    varargout = length(f);

    % Size of a CHEBFUN3.
    varargout = size(f, varargin);
        
    % Minimum of a CHEBFUN3 along one dimension.
    varargout = min(varargin);
    
    % Maximum of a CHEBFUN3 along one dimension.
    varargout = max(varargin);

    % Minimum of a CHEBFUN3 along two dimensions.
    varargout = min2(varargin);
    
    % Maximum of a CHEBFUN3 along two dimensions.
    varargout = max2(varargin);
    
    % Global minimum of a CHEBFUN3.
    varargout = min3(f);
    
    % Global maximum of a CHEBFUN3.
    varargout = max3(f);
    
    % Global minimum and maximum of a CHEBFUN3.
    varargout = minandmax3(f);
    
    % Norm of a CHEBFUN3.
    varargout = norm(f, p);    
    
    % Display a CHEBFUN3.
    varargout = disp(f, varargin);
    
    % Display a CHEBFUN3.
    varargout = display(varargin);
    
    % Simplify a CHEBFUN3.
    out = simplify(varargin);
    
    % Vertical scale of a CHEBFUN3.
    out = vscale(f);
    
    % Vertical concatenation of CHEBFUN3 objects.
    out = vertcat(varargin);
    
    % Just one common root of 3 CHEBFUN3 objects.
    varargout = root(f, g, h); 
    
    % Roots of a CHEBFUN3 object.
    varargout = roots(f, varargin);
    
    % Number of degrees of freedom needed to represent a CHEBFUN3.
    out = ndf(f);
    
    % Get the low-rank representation (Tucker expansion) of a CHEBFUN3.
    varargout = tucker(f);    

    % Definite integral of a CHEBFUN3 over the domain in one
    % direction. Output is a Chebfun2 object.
    out = sum(varargin);
    
    % Definite integral of a CHEBFUN3 over the domain in two directions. 
    % Output is a Chebfun object.
    out = sum2(varargin);

    % Definite integral of a CHEBFUN3 over its domain.
    out = sum3(f);    
    
    % Volume of the domain of a CHEBFUN3.
    out = domainvolume(f);
    
    % Line integral of a CHEBFUN3 over a 3D parametric curve.
    out = integral(f, varargin);
    
    % Surface integral of a CHEBFUN3 over a surface represented as a CHEBFUN2.
    out = integral2(f, varargin);
        
    % Average or mean value of a CHEBFUN3 in one direction.
    out = mean(f, varargin);
    
    % Average or mean value of a CHEBFUN3 in two directions.
    out = mean2(f, varargin);    
    
    % Average or mean value of a CHEBFUN3.
    out = mean3(f);
    
    % Standard deviation of a CHEBFUN3.
    out = std3(f);

    % Squeeze a CHEBFUN3 into a CHEBFUN2 or a CHEBFUN.
    out = squeeze(f);

    % Create a scatter plot of the core tensor of a CHEBFUN3.
    varargout = coreplot(f, varargin);
    
    % Plot a CHEBFUN3.
    out = plot(f, varargin);
    
    % Plot slices of a CHEBFUN3.
    out = slice(f, varargin);
    
    % Scan plot of a CHEBFUN3.
    out = scan(f, varargin);
    
    % Isosurface plot of a CHEBFUN3.
    out = isosurface(f, varargin);
    
    % SURF for a CHEBFUN3 over its domain.
    varargout = surf(f, varargin);
    
    % plotcoeffs of a CHEBFUN3.
    varargout = plotcoeffs(f, varargin);
    
    % Tensor of coefficients of a CHEBFUN3.
    varargout = chebcoeffs3(f);
    
    % A wrapper for chebcoeffs3.
    varargout = coeffs3(f);
end

methods
    
    % Unary plus for a CHEBFUN3.
    out = uplus(f, g);
    
    % Plus for CHEBFUN3 objects.
    out = plus(f, g, tol);
    
    % Unary minus for a CHEBFUN3.
    out = uminus(f);
    
    % Subtraction of two CHEBFUN3 objects.
    out = minus(f, g);
    
    % Pointwise multiplication for CHEBFUN3 objects.
    out = times(f, g);
    
    % Pointwise multiplication for CHEBFUN3 objects.
    out = mtimes(f, g);
    
    % Pointwise power of a CHEBFUN3.
    out = power(varargin);
    
    % Pointwise right divide of CHEBFUN3 objects.
    out = rdivide(f, g);
    
    % Pointwise left divide of CHEBFUN3 objects.
    out = mrdivide(f, g);
    
    % Pointwise CHEBFUN3 left array divide.
    out = ldivide(f, g);
    
    % Left divide for CHEBFUN3 objects.
    out = mldivide(f, g);
    
    % Absolute value of a CHEBFUN3.
    out = abs(f);
    
    % Real part of a CHEBFUN3.
    out = real(f);
    
    % Imaginary part of a CHEBFUN3.
    out = imag(f);
    
    % Complex conjugate of a CHEBFUN3.
    out = conj(f);
    
    % Create f + i g for two CHEBFUN3 objects.
    out = complex(f, g);
    
    % Sine of a CHEBFUN3.
    out = sin(f);
    
    % Cosine of a CHEBFUN3.
    out = cos(f);
    
    % Tangent of a CHEBFUN3.
    out = tan(f);
      
    % Tangent of a CHEBFUN3 (in degrees).
    out = tand(f);
      
    % Hyperbolic tangent of a CHEBFUN3.
    out = tanh(f);
      
    % Exponential of a CHEBFUN3.
    out = exp(f);
      
    % Hyperbolic sine of a CHEBFUN3.
    out = sinh(f);
      
    % Hyperbolic cosine of a CHEBFUN3.
    out = cosh(f);
            
    % Compose command for CHEBFUN3 objects.
    out = compose(f, varargin);
      
    % Square root of a CHEBFUN3.
    out = sqrt(f, varargin);
      
    % Natural logarithm of a CHEBFUN3.
    out = log(f, varargin);
      
    % HOSVD of a CHEBFUN3.
    varargout = hosvd(f, varargin);
      
    % Test whether a CHEBFUN3 object is empty.
    out = isempty(f);
      
    % Determine whether a CHEBFUN3 is identically zero over its domain.
    varargout = iszero(f);
        
    % Real-valued CHEBFUN3 test.
    out = isreal(f);

    % Equality test for CHEBFUN3 objects.
    out = isequal(f, g);
      
    % Partial derivative of a CHEBFUN3 object.
    out = diff(f, varargin);
      
    % Partial derivative of a CHEBFUN3 object in the first variable.
    out = diffx(f, varargin);
      
    % Partial derivative of a CHEBFUN3 object in the second variable.
    out = diffy(f, varargin);
      
    % Partial derivative of a CHEBFUN3 object in the third variable.
    out = diffz(f, varargin);
      
    % Gradient of a CHEBFUN3.
    varargout = grad(f);
      
    % Gradient of a CHEBFUN3.
    varargout = gradient(f);
    
    % Normal vector of a CHEBFUN3.
    varargout = normal(f, varargin);
      
    % Laplacian of a CHEBFUN3.
    out = lap(f);
      
    % Laplacian of a CHEBFUN3.
    out = laplacian(f);
      
    % Biharmonic operator of a CHEBFUN3.
    out = biharm(f);
    
    % Biharmonic operator of a CHEBFUN3.
    out = biharmonic(f);
      
    % Scaled Laplacian of a CHEBFUN3.
    out = del2(f);
      
    % Indefinite integral of a CHEBFUN3 in one variable.
    out = cumsum(f, varargin);
      
    % Indefinite integral of a CHEBFUN3 in two variables.
    out = cumsum2(f, varargin);

    % Indefinite integral of a CHEBFUN3 in all variables.
    out = cumsum3(f);
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% HIDDEN METHODS:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods ( Hidden = true, Static = false )
    
        % Test if two CHEBFUN3 objects have the same domain.
        out = domainCheck(f, g);

    end
end