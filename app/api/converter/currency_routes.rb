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

            def permitted_params
                @permitted_params ||= declared(params, include_missing: false)
            end

            params :currency_params do
                requires :decimals, type: Integer, desc: 'How many decimal places including the leading number'
                requires :symbol, type: String, desc: 'Symbol of currency'
                requires :desc, type: String, desc: 'Description of currency'
                requires :conversion, type: Float, desc: 'Conversion amount of currency to USD'
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
                
            desc 'Create a Currency in the db'
            params do
                use :currency_params
            end
            post :create do
                binding.pry
                obj = Currency.create!(permitted_params)
                {
                    created: obj
                }
            end

            desc 'Update a Currency in the db'
            params do
                requires :id, type: Integer, desc: 'Currency ID'
                use :currency_params
            end
            put ':id' do
                currency = Currency.find(permitted_params[:id])
                currency.update_attributes!(permitted_params)
                {
                    updated: currency
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