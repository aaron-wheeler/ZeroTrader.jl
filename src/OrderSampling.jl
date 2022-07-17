using Brokerage, Distributions, Random

function zero_trade(rounds, num_agents, num_MM, assets, stock_prices, num_assets)
    # instantiate Pareto distribution for trader activation
    granularity = (8.0 - 1.0)/num_agents
    pareto_xaxis = 1.01:granularity:8.01
    prob_activation = pdf.(Pareto(1,1), pareto_xaxis)
    for i in 1:rounds
        # probabilistic activation of traders
        trade_draw = (1 - rand(prob_activation[1:num_agents])) * num_agents
        agents_to_trade = ceil(Int, trade_draw)
        trade_queue = collect(Int, agents_to_trade:num_agents)
        shuffle!(trade_queue)

        # determine new risky wealth and place orders
        for i in 1:length(trade_queue)
            id = trade_queue[i] + num_MM
            risk_fraction = rand(Uniform())
            risky_wealth, assets, stock_prices = get_trade_details!(id, assets, stock_prices)
            total_wealth = get_total_wealth(risky_wealth, id)
            risky_wealth_allocation = total_wealth * risk_fraction
            pick_stocks(num_assets, risky_wealth_allocation, assets, stock_prices, id)
        end
    end
end

function pick_stocks(num_assets, risky_wealth_allocation, assets, stock_prices, id)
    # determine portfolio weights
    portfolio_weights = rand(Dirichlet(num_assets, 1.0))
    for i in 1:length(portfolio_weights)
        if portfolio_weights[i] != 0.0
            ticker = i
            desired_shares = portfolio_weights[i] * (risky_wealth_allocation / stock_prices[i])
            share_amount = desired_shares - assets[i]
            place_order(ticker, share_amount, id)
        else
            continue
        end
    end
end

function place_order(ticker, share_amount, id)
    if share_amount < 0.0
        fill_amount = abs(share_amount)
        order_id = 1111 # arbitrary (for now)
        Client.placeMarketOrder(ticker,order_id,"SELL_ORDER",fill_amount,id)
    elseif share_amount > 0.0
        fill_amount = share_amount
        order_id = 1111 # arbitrary (for now)
        Client.placeMarketOrder(ticker,order_id,"BUY_ORDER",fill_amount,id)
    end
end