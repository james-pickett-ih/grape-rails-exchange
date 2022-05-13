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


        resource :converter do
            params do
                requires :amount, type: Float
                requires :to_currency, type: String
                requires :from_currency, type: String
            end
            get :exchange do
                converted_amount = params[:amount] * get_exchange_rate(params[:to_currency])
                {
                    amount: converted_amount,
                    currency: params[:to_currency]
                }
            end
        end
    end
end