module Converter
    class CurrencyRoutes < Grape::API
        version 'v1', using: :path
        format :json
        rescue_from :all

        helpers do
            def get_exchange_rate(currency)
                case currency
                when 'NTD'
                    30
                else
                    raise StandardError.new "No conversion found"
                end
            end
        end

        resource :currencies do
            get :count do
                count = Currency.count;
                {
                    count: count
                }
            end

            get :list do
                {
                    currencies: Currency.all
                }
            end

            get :bysymbol do
                symbol = params['symbol']
                curr = Currency.where(symbol: symbol)
                {
                    "currsWith#{symbol}": curr
                }
            end
                
            post :create do
                obj = Currency.create!(amount: params['amount'], decimals: params['decimals'], symbol: params['symbol'], desc: params['desc'], conversion: params['conversion'])
                {
                    created: obj
                }
            end

            post :exchange do
                to_currency = params['to_currency']
                from_currency = params['from_currency']
                amount = params['amount']
                from_rate = Currency.find_by(symbol: from_currency).conversion
                from_usd = amount.to_f * from_rate
                to_rate = Currency.find_by(symbol: to_currency).conversion
                to_curr = from_usd / to_rate
                {
                    amount: to_curr
                }
            end
        end
    end
end