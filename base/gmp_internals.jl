# This module is inside GMP
# WARNING: These functions aren't safe for general use
# Use with discretion
module Internals
importall ..GMP

# This allows to call GMP easier
macro gmp_ccall(f, ret, types, vars...)
    quote
        ccall(($(string(:__gmpz_,f)), :libgmp),
               $ret,
               $types,
               $(vars...))
    end
end

# Basic setters
for (fC, ret, t) in ((:set_si, Void, Clong),
                     (:set_ui, Void, Culong),
                     (:set_d,  Void, Float64))
    @eval begin
        $(symbol(string(:gmp_,fC)))(z::BigInt, x::$t) = @gmp_ccall $fC $ret (Ptr{BigInt}, $t) &z x
    end
end

# Binary ops
for fC in (:add, :sub, :mul, :fdiv_q, :tdiv_q, :fdiv_r, :tdiv_r,
           :gcd, :lcm, :and, :ior, :xor, :mod, :addmul, :and,
           :divexact, :invert, :submul)
    @eval begin
        $(symbol(string(:gmp_,fC)))(z::BigInt, x::BigInt, y::BigInt) = @gmp_ccall $fC Void (Ptr{BigInt}, Ptr{BigInt}, Ptr{BigInt}) &z &x &y
    end
end

end # module
