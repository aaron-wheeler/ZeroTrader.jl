using ZeroTrader
using Test

@testset "ZeroTrader.jl" begin
    @test 1 == 1
end

# parameters = (
#     username = "aaron",
#     password = "password123",
#     init_shares_range = 0.0:0.01:20.0,
#     init_cash_range = 10000.0:0.01:30000.0,
#     num_MM = 30 # number of reserved ids set aside for market makers
# )

# num_traders, num_assets, rounds = 10, 2, 10

# ZT_run(num_traders, num_assets, rounds; parameters...)
