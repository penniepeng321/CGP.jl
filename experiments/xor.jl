using CGP
using Logging
using ArgParse

CGP.Config.init("cfg/test.yaml")

function xorfit(c::Chromosome, nbits::Int64, nsamples::Int64)
    accuracy = 0
    for d in 1:nsamples
        ins = bitrand(nbits)
        outputs = process(c, Float64.(ins))
        if outputs[1] == xor(ins...)
            accuracy += 1
        end
    end
    accuracy /= nsamples
    accuracy
end

function get_args()
    argtable = ArgParseSettings()
    @add_arg_table(
        argtable,
        "--seed", arg_type = Int, default = 0,
        "--log", arg_type = String, default = "xor.log",
        "--nbits", arg_type = Int, default = 2,
        "--nsamples", arg_type = Int, default = 10
    )
    parse_args(argtable)
end

function run_xor(args::Dict)
    srand(args["seed"])
    Logging.configure(filename="xor.log", level=INFO)
    nin = args["nbits"]
    nout = 1
    fitness = x->xorfit(x, args["nbits"], args["nsamples"])
    maxfit, best = oneplus(nin, nout, fitness; id="xor")
end

if ~isinteractive()
    run_xor(get_args())
end

