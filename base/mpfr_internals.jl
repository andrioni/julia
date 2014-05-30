# This module is inside MPFR
# WARNING: These functions aren't safe for general use
# Use with discretion
# Please notice that this follows the C interface, that is, variables keep their original precision
module Internals
importall ..MPFR

# This allows to call MPFR easier
macro mpfr_ccall(f, ret, types, vars...)
    quote
        ccall(($(string(:mpfr_,f)), :libmpfr),
               $ret,
               $types,
               $(vars...))
    end
end

# Basic setters
for (fC, ret, t) in ((:set_si, Int32, Clong),
                     (:set_ui, Int32, Culong),
                     (:set_d,  Int32, Float64))
    @eval begin
        $(symbol(string(:mpfr_,fC)))(z::BigFloat, x::$t) = @mpfr_ccall $fC $ret (Ptr{BigFloat}, $t, Int32) &z x ROUNDING_MODE[end]
        $(symbol(string(:mpfr_,fC)))(z::BigFloat, x::$t, r::RoundingMode) = @mpfr_ccall $fC $ret (Ptr{BigFloat}, $t, Int32) &z x to_mpfr(r)
    end
end

# Binary ops
for fC in (:add, :sub, :mul, :div, :pow)
    @eval begin
        $(symbol(string(:mpfr_,fC)))(z::BigFloat, x::BigFloat, y::BigFloat) = @mpfr_ccall $fC Int32 (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32) &z &x &y ROUNDING_MODE[end]
        $(symbol(string(:mpfr_,fC)))(z::BigFloat, x::BigFloat, y::BigFloat, r::RoundingMode) = @mpfr_ccall $fC Int32 (Ptr{BigFloat}, Ptr{BigFloat}, Ptr{BigFloat}, Int32) &z &x &y to_mpfr(r)
    end
end

end # module
