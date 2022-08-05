class StocksController<ApplicationController

    def search
        if params[:stock].present?
            @stock=Stock.new_lookup(params[:stock])
            if @stock    #in case of a valid search
                respond_to do |format|    
                    #accept JS formata, go to partial 'result' which will have the JS code
                    format.js {render partial:'users/result'}   
                end
            else      #invalid symbol
                respond_to do |format|    
                flash.now[:alert]="Please enter a valid symbol to search"  #flash.now occurs for only 1 cycle
                format.js {render partial:'users/result'}
                end
            end
        else         #empty string
            respond_to do |format| 
                flash.now[:alert]="Please enter a symbol to search"
                format.js {render partial:'users/result'}
            end
        end
    end
end