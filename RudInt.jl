
# # Class Interpreter 0
# Base interpreter with numbers, plus, and minus
#

module RudInt

push!(LOAD_PATH, pwd())

using Revise
using Error
using Lexer
export parse, calc, interp

#
# ==================================================
#

abstract type AE 
end
 
struct NumNode <: AE
	n::Real
end
 
struct BinopNode <: AE
	op::Function
	lhs::AE
	rhs::AE
end

struct OneopNode <: AE
    op::Function
    n::AE
end

struct CollatzNode <: AE
    n::AE
end

#
# ==================================================
#

function collatz(n::Real)
  return collatz_helper(n, 0)
end
 
function collatz_helper(n::Real, num_iters::Int)
  if n == 1
    return num_iters
  end
  if mod(n,2)==0
    return collatz_helper(n/2, num_iters+1)
  else
    return collatz_helper(3*n+1, num_iters+1)  
  end
end

d = Dict(:+ => +, :- => -, :* => *, :/ => /, :mod => mod, :collatz => collatz)

#
# ==================================================
#

function parse( expr::Number )
    return NumNode(expr)
end

function parse(expr::Array{Any})
    
    if haskey(d, expr[1])     
        if length(expr) != 3
            if length(expr) == 2
                if expr[1] == :- || expr[1] == :collatz
                    return OneopNode(d[expr[1]], parse(expr[2])) #negative of number  
                else
                    throw(LispError("Wrong number of parameters!"))  
                end
            else
            throw(LispError("Wrong number of parameters!"))     
            end
        
        elseif (expr[1] != :collatz)
            return BinopNode(d[expr[1]], parse( expr[2] ), parse( expr[3] ) )
        else 
            throw(LispError("Too many parameters!"))
        end

    end

    throw(LispError("Unknown operator!"))
end

function parse( expr::Any )
  throw( LispError("Invalid type $expr") )
end

#
# ==================================================
#

function calc( ast::NumNode )
    return ast.n
end

function calc( ast::BinopNode ) 
    if calc(ast.rhs) == 0 && ast.op == / 
        throw(LispError("Division by 0")) 
        
    else
        return ast.op(calc(ast.lhs), calc(ast.rhs))
    end
end

function calc( ast::OneopNode )
    if ast.op == collatz
        if calc(ast.n) <= 0
            throw(LispError("Cannot collatz number <= 0"))
        else    
            return collatz(calc(ast.n))
        end
    
    else
        return -calc(ast.n)
    end
end

#
# ==================================================
#

function interp(cs::AbstractString)
    lxd = Lexer.lex(cs)
    ast = parse(lxd)
    return calc(ast)
end

end #module

