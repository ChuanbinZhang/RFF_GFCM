function y = locallog( x )

y = x;
ii = find( y );
y( ii ) = log( y( ii ));
