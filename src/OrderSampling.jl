using Brokerage, Distributions, Dates, Random

function ZT_run(num_traders, num_assets, market_open, market_close, parameters, server_info)
    # unpack parameters
    username, password, init_cash_range, init_shares_range, num_MM = parameters
    host_ip_address, port = server_info

    # connect to brokerage
    url = "http://$(host_ip_address):$(port)"
    Client.SERVER[] = url
    Client.createUser(username, password)
    user = Client.loginUser(username, password)
 
    # initialize traders
    init_traders(num_traders, init_cash_range, init_shares_range, num_assets)
    
    # instantiate Pareto distribution for trader activation
    granularity = (8.0 - 1.0)/num_traders
    time = 1.01:granularity:8.01
    prob_activation = (pdf.(Pareto(1,1), time))[1:num_traders]

    # prepare recyclable trading vectors
    assets = zeros(Float64, num_assets)
    stock_prices = zeros(Float64, num_assets)

    # hold off trading until the market opens
    if Dates.now() < market_open
        @info "Waiting until market open..."
        pre_market_time = Dates.value(market_open - now()) / 1000 # convert to secs
        sleep(pre_market_time)
    end

    # execute trades until the market closes
    @info "Initiating trade sequence now."
    while Dates.now() < market_close
        # probabilistic activation of traders
        trade_draw = (1 - rand(prob_activation)) * num_traders
        agents_to_trade = ceil(Int, trade_draw)
        trade_queue = collect(Int, agents_to_trade:num_traders)
        shuffle!(trade_queue)

        # determine new risky wealth and place orders
        for i in 1:length(trade_queue)
            id = trade_queue[i] + num_MM
            risk_fraction = rand(Uniform())
            risky_wealth, assets, stock_prices = get_trade_details!(id, assets, stock_prices)
            total_wealth = get_total_wealth(risky_wealth, id)
            risky_wealth_allocation = total_wealth * risk_fraction
            pick_stocks(num_assets, risky_wealth_allocation, assets, stock_prices, id)
            # check early exit condition
            if Dates.now() > market_close
                break
            end
        end
    end
    @info "Trade sequence complete."
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
        # println("SELL: trader = $(id), size = $(fill_amount), ticker = $(ticker).")
        Client.placeMarketOrder(ticker,order_id,"SELL_ORDER",fill_amount,id)
    elseif share_amount > 0.0
        fill_amount = share_amount
        order_id = 1111 # arbitrary (for now)
        # println("BUY: trader = $(id), size = $(fill_amount), ticker = $(ticker).")
        Client.placeMarketOrder(ticker,order_id,"BUY_ORDER",fill_amount,id)
    end
end