using ZeroTrader, Dates

## Example use case
parameters = (
    username = "aaron",
    password = "password123",
    init_cash_range = 10000.0:0.01:30000.0,
    init_shares_range = 0.0:0.01:120.0,
    num_MM = 30 # number of reserved ids set aside for market makers
)

server_info = (
    host_ip_address = "localhost",
    port = "8080"
)

num_traders, num_assets = 10, 2
market_open = Dates.now() + Dates.Second(15) # DateTime(2022,7,19,13,19,41,036)
market_close = market_open + Dates.Second(2)

ZT_run(num_traders, num_assets, market_open, market_close, parameters, server_info)

# include("test/example_run.jl")