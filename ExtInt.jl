
#
# Class Interpreter 3
# With numbers, plus, minus, if0, with, variable references,
# user-defined functions (lambda), and function calls.
#

module ExtInt

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

# <AE> ::= <number>
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

# <AE> ::= (if0 <AE> <AE> <AE>)
struct If0Node <: AE
    cond::AE
    zerobranch::AE
    nzerobranch::AE
end

struct BindNode <: AE
    sym::Symbol
    binding_expr::AE
end

# <AE> ::= (with <id> <AE> <AE>)
struct WithNode <: AE
    bindings::Array{BindNode}
    body::AE 
end

# <AE> ::= <id>
struct VarRefNode <: AE
    sym::Symbol
end

# <AE> ::= (lambda <id> <AE>)
struct FuncDefNode <: AE
    formals::Array{Symbol}
    body::AE
end

# <AE> ::= (<AE> <AE>)
struct FuncAppNode <: AE
    fun_expr::AE
    arg_exprs::Array{AE}
end

#
# ==================================================
#

abstract type RetVal
end

abstract type Environment
end

struct NumVal <: RetVal
    n::Real
end

struct ClosureVal <: RetVal
    formals::Array{Symbol}
    body::AE
    env::Environment
end

#
# ==================================================
#

struct EmptyEnv <: Environment
end

struct ExtendedEnv <: Environment
    sym::Symbol
    val::RetVal
    parent::Environment
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
# ==================================================
#

function parse( expr::Number )
    return NumNode( expr )
end

function parse( expr::Symbol )
    if haskey(d, expr) || expr == :if0 || expr == :with || expr == :lambda 
        throw(LispError("Invalid symbol"))
    else          
        return VarRefNode( expr )
    end
end

function parse( expr::Array{Any} )
    if length(expr) == 0
        throw(LispError("Need more parameters!"))

    elseif haskey(d, expr[1])     
        if length(expr) != 3
            if length(expr) == 2
                if expr[1] == :- || expr[1] == :collatz
                    return OneopNode(d[expr[1]], parse(expr[2])) 
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

    elseif expr[1] == :if0
        if length(expr) != 4
            throw(LispError("Wrong number of parameters!"))
        else
            return If0Node( parse(expr[2]), parse(expr[3]) , parse(expr[4]) )
        end

    elseif expr[1] == :with
        if length(expr) != 3
            throw(LispError("Wrong number of parameters!"))
        else
            symSet = Set()
            bindArray = Any[]
             for x in expr[2]
                 if (haskey(d, x[1]) || x[1] == :if0 || x[1] == :with || x[1] == :lambda || typeof(parse(x[1])) == NumNode
                    || in(x[1], symSet))
                    
                    throw(LispError("Wrong symbol name!"))
                    
                 elseif length(x) != 2
                    throw(LispError("Invalid BindNode"))
                    
                 else 
                    push!(symSet, x[1])
                    push!(bindArray, BindNode(x[1], parse(x[2])))
                 end
             end
                return WithNode( bindArray, parse(expr[3])) 
            #end
        end

    elseif expr[1] == :lambda
        if (length(expr) != 3)
            throw(LispError("Wrong number of parameters!"))
        else
            symSet2 = Set()
            for x in expr[2]
                if (haskey(d, x) || x == :if0 || x == :with || x == :lambda 
                        || typeof(parse(x)) == NumNode || in(x, symSet2))
                
                    throw(LispError("Invalid symbol"))
                
                else
                    push!(symSet2, x)
                end
            end
            return FuncDefNode(expr[2], parse(expr[3]))   
        end

    else
        AElist = AE[]
        if (length(expr) > 1)
            for x=2 : length(expr)
                push!(AElist, parse(expr[x]))
            end
                return FuncAppNode( parse(expr[1]), AElist)
        else
            return(parse(expr[1]))
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

function calc( ast::NumNode, env::Environment )
    return NumVal( ast.n )
end

function calc( ast::BinopNode, env::Environment )
    rhs = calc( ast.rhs, env )
    lhs = calc( ast.lhs, env )
    if rhs.n == 0 && ast.op == / 
        throw(LispError("Division by 0")) 
        
    elseif typeof(rhs) != NumVal || typeof(lhs) != NumVal
        throw(LispError("Cannot operate on non numbers!"))
        
    else
        return NumVal(ast.op(lhs.n, rhs.n))
    end
end

function calc( ast::OneopNode, env::Environment )
    n = calc(ast.n, env)
    
    if typeof(n) != NumVal
        throw(LispError("Cannot operate on non numbers!"))
        
    elseif ast.op == collatz
        if n.n <= 0
            throw(LispError("Cannot collatz number <= 0"))
    
        else
            return NumVal(collatz(n.n))
        end
    
    else
        return NumVal(-n.n)
    end
end

function calc( ast::If0Node, env::Environment )
    cond = calc( ast.cond, env )
    if (typeof(cond) != NumVal)
        throw(LispError("Invalid If0 condition"))
        
    elseif cond.n == 0
        return calc( ast.zerobranch, env )
        
    else
        return calc( ast.nzerobranch, env )
    end
end

function calc( ast::WithNode, env::Environment )
    ext_env = env
    for x=1 : length(ast.bindings)
        new_exp = (ast.bindings[x])
        binding_val = calc( new_exp.binding_expr, env )
        ext_env = ExtendedEnv( new_exp.sym, binding_val, ext_env )
    end
    return calc( ast.body, ext_env )
end

function calc( ast::VarRefNode, env::EmptyEnv )
    throw( Error.LispError("Undefined variable " * string( ast.sym )) )
end

function calc( ast::VarRefNode, env::ExtendedEnv )
    if ast.sym == env.sym
        return env.val
    else
        return calc( ast, env.parent )
    end
end

function calc( ast::FuncDefNode, env::Environment )
    if length(ast.formals) == 0
        return calc(ast.body)
    else
        return ClosureVal( ast.formals, ast.body, env )
    end
end

function calc( ast::FuncAppNode, env::Environment )
    closure_val = calc( ast.fun_expr, env )
    ext_env = closure_val.env
    
    if typeof(closure_val) != ClosureVal
        throw(LispError("Invalid entry!"))
        
    elseif length(ast.arg_exprs) != length(closure_val.formals)
        throw(LispError("Invalid entry!"))
        
    else
        for x=1 : length(ast.arg_exprs)
            actual_parameter = calc(ast.arg_exprs[x], env)
            ext_env = ExtendedEnv( closure_val.formals[x], actual_parameter, ext_env )
        end
        return calc( closure_val.body, ext_env )
    end
end

function calc( ast::Any )
    return calc( ast, EmptyEnv() )
end

#
# ==================================================
#

function interp( cs::AbstractString )
    lxd = Lexer.lex( cs )
    ast = parse( lxd )
    return calc( ast, EmptyEnv() )
end

# evaluate a series of tests in a file
function interpf( fn::AbstractString )
  f = open( fn )

  cur_prog = ""
  for ln in eachline(f)
      ln = chomp( ln )
      if length(ln) == 0 && length(cur_prog) > 0
          println( "" )
          println( "--------- Evaluating ----------" )
          println( cur_prog )
          println( "---------- Returned -----------" )
          try
              println( interp( cur_prog ) )
          catch errobj
              println( ">> ERROR: lxd" )
              lxd = Lexer.lex( cur_prog )
              println( lxd )
              println( ">> ERROR: ast" )
              ast = parse( lxd )
              println( ast )
              println( ">> ERROR: rethrowing error" )
              throw( errobj )
          end
          println( "------------ done -------------" )
          println( "" )
          cur_prog = ""
      else
          cur_prog *= ln
      end
  end

  close( f )
end

end #module
