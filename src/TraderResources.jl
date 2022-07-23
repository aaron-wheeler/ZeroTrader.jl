using Brokerage

function init_traders(num_traders, init_cash_range, init_shares_range, num_assets)
    for i in 1:num_traders
        name = "ZeroTrader $(i)"
        cash = rand(init_cash_range)
        holdings = Dict{Int64, Float64}()
        for ticker in 1:num_assets
            init_shares = rand(init_shares_range)
            holdings[ticker] = init_shares
        end
        portfolio = Client.createPortfolio(name, cash, holdings)
    end
end

function get_trade_details!(id, assets, stock_prices)
    holdings = Client.getHoldings(id)
    # get shares in ticker-based sequence
    shares = values(holdings)
    risky_wealth = 0.0
    for i in 1:length(shares)
        stock_prices[i] = Client.getMidPrice(i)
        assets[i] = shares[i]
        risky_wealth += assets[i] * stock_prices[i]
    end
    return risky_wealth, assets, stock_prices
end

function get_total_wealth(risky_wealth, id)
    total_wealth = risky_wealth + Client.getCash(id)
    return total_wealth
end