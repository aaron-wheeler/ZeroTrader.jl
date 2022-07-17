module ZeroTrader

using Brokerage, Distributions, Random

include("TraderResources.jl")
include("OrderSampling.jl")

# Run Zero-intelligence Aggregate Traders
function ZT_run(num_traders, num_assets, rounds; username, password, init_cash_range, init_shares_range, num_MM)
    Client.createUser(username, password)
    user = Client.loginUser(username, password)
    assets = zeros(Float64, num_assets)
    stock_prices = zeros(Float64, num_assets)
    init_traders(num_traders, init_cash_range, init_shares_range, num_assets)
    zero_trade(rounds, num_traders, num_MM, assets, stock_prices, num_assets)
end

export ZT_run

end
